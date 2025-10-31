# app/cheques/repository.py

from sqlalchemy.orm import Session, joinedload
from sqlalchemy import select
from sqlalchemy.exc import IntegrityError
from typing import List, Optional
from decimal import Decimal 

# Importar modelos y esquemas
from ..models.cheque import Cheque 
from ..schemas.cheques import ChequeCreate, ChequeUpdate
from ..models.cliente import Cliente
from ..models.nombre_impuesto import NombreImpuesto

class ChequeRepository:
    """
    Clase de repositorio que maneja las operaciones CRUD para el modelo Cheque.
    Incluye la lógica de negocio para actualizar automáticamente el saldo (Cli_Saldo) del cliente asociado.
    """
    def __init__(self, db: Session):
        """Inicializa el repositorio con la sesión de base de datos."""
        self.db = db

    def _adjust_client_balance(self, cli_id: int, amount_difference: Decimal):
        """
        Método privado para ajustar el saldo del cliente.
        
        Args:
            cli_id (int): ID del cliente cuyo saldo se ajustará.
            amount_difference (Decimal): Cantidad a sumar (positivo) o restar (negativo) al Cli_Saldo.
            
        Raises:
            ValueError: Si el cliente con el ID proporcionado no existe.
        """
        if amount_difference == Decimal(0): 
            return
        
        # Busca el cliente para asegurar su existencia y actualizar su saldo
        cliente = self.db.execute(
            select(Cliente).where(Cliente.Cli_ID == cli_id)
        ).scalars().first()
        
        if not cliente:
            raise ValueError(f"Cliente con ID {cli_id} no encontrado para ajustar saldo")
        
        # Aplica la diferencia: Un cheque representa un ingreso al cliente (saldo aumenta)
        cliente.Cli_Saldo += amount_difference
        self.db.add(cliente)
        # El commit es realizado por la función principal (create, update, delete)

# ----------------------------------------------------------------------
# MÉTODOS DE CONSULTA (GET)
# ----------------------------------------------------------------------

    def get_by_id(self, cheque_id: int) -> Optional[Cheque]:
        """
        Busca un cheque específico por su ID.
        
        Realiza un 'joinedload' para incluir el nombre del impuesto asociado 
        (si existe) en la misma consulta.
        """
        return self.db.execute(
            select(Cheque)
            .where(Cheque.Cheq_ID == cheque_id)
            .options(joinedload(Cheque.nombre_impuesto)) # Carga eager loading de la relación NomIm_ID
        ).scalars().first()

    def get_all_by_client(self, client_id: int) -> List[Cheque]:
        """
        Obtiene todos los cheques asociados a un cliente específico.
        
        Los resultados se ordenan por la fecha de vencimiento descendente.
        """
        return self.db.execute(
            select(Cheque)
            .where(Cheque.Cli_ID == client_id)
            .order_by(Cheque.Cheq_FechaVencimiento.desc())
            .options(joinedload(Cheque.nombre_impuesto))
        ).scalars().all()

# ----------------------------------------------------------------------
# MÉTODO DE CREACIÓN (CREATE)
# ----------------------------------------------------------------------

    def create(self, cheque_data: ChequeCreate) -> Optional[Cheque]:
        """
        Crea un nuevo cheque, valida las claves foráneas y ajusta el saldo del cliente.
        
        Flujo Transaccional:
        1. Valida la existencia del Cliente.
        2. Valida la existencia del NombreImpuesto (si se proporciona).
        3. Ajusta el saldo del cliente (SUMA el monto del cheque).
        4. Inserta el nuevo registro de cheque.
        
        Raises:
            ValueError: Si el Cliente o NombreImpuesto asociado no existe.
            IntegrityError: Si falla alguna restricción de base de datos.
        """
        cheq_monto_decimal = Decimal(str(cheque_data.Cheq_Monto)) # Asegura la precisión Decimal

        # 1. Validar Cliente (Revisa que la FK sea válida)
        if not self.db.execute(select(Cliente).where(Cliente.Cli_ID == cheque_data.Cli_ID)).scalars().first():
            raise ValueError(f"Cliente con ID {cheque_data.Cli_ID} no encontrado")
        
        # 2. Validar Nombre de Impuesto (Revisa que la FK sea válida)
        if cheque_data.NomIm_ID is not None:
            if not self.db.execute(select(NombreImpuesto).where(NombreImpuesto.NomIm_ID == cheque_data.NomIm_ID)).scalars().first():
                raise ValueError(f"Nombre de Impuesto con ID {cheque_data.NomIm_ID} no válido.")
        
        # Crea el objeto Cheque con el monto en formato Decimal
        db_cheque = Cheque(**cheque_data.dict(exclude={'Cheq_Monto'}), Cheq_Monto=cheq_monto_decimal) 

        try:
            # 3. Ajuste de Saldo: El monto del cheque se SUMA al saldo del cliente.
            self._adjust_client_balance(cheque_data.Cli_ID, cheq_monto_decimal)
            
            self.db.add(db_cheque)
            self.db.commit()
            self.db.refresh(db_cheque)
            
        except IntegrityError as e:
            self.db.rollback()
            raise IntegrityError(f"Error de integridad al cargar el cheque (ej. número duplicado). Detalles: {e}", params=None, orig=None)
        except ValueError as e:
             self.db.rollback()
             raise e # Propaga el error si el cliente no fue encontrado para el ajuste de saldo
        
        # Retorna el cheque recién creado con sus relaciones cargadas
        return self.get_by_id(db_cheque.Cheq_ID)
    
# ----------------------------------------------------------------------
# MÉTODO DE ACTUALIZACIÓN (UPDATE)
# ----------------------------------------------------------------------

    def update(self, cheque_id: int, cheque_update: ChequeUpdate) -> Optional[Cheque]:
        """
        Actualiza un cheque, valida cambios de FKs y recalcula el saldo del cliente.
        
        Flujo Transaccional:
        1. Determina si cambió el monto y/o el cliente.
        2. Aplica la diferencia neta al saldo (si el cliente no cambia).
        3. Si el cliente cambia, revierte el monto anterior del cliente viejo y aplica el nuevo monto al nuevo cliente.
        """
        db_cheque = self.db.execute(select(Cheque).where(Cheque.Cheq_ID == cheque_id)).scalars().first()
        if not db_cheque:
            return None
        
        update_data = cheque_update.dict(exclude_unset=True)
        old_monto_decimal = Decimal(str(db_cheque.Cheq_Monto))
        old_cli_id = db_cheque.Cli_ID

        # VALIDACIONES de FKs (Cliente y NombreImpuesto)
        if 'Cli_ID' in update_data and not self.db.execute(select(Cliente).where(Cliente.Cli_ID == update_data['Cli_ID'])).scalars().first():
            raise ValueError(f"Cliente con ID {update_data['Cli_ID']} no encontrado para la actualización.")
            
        if 'NomIm_ID' in update_data and update_data['NomIm_ID'] is not None:
            if not self.db.execute(select(NombreImpuesto).where(NombreImpuesto.NomIm_ID == update_data['NomIm_ID'])).scalars().first():
                raise ValueError(f"Nombre de Impuesto con ID {update_data['NomIm_ID']} no válido para la actualización.")

        # 1. Aplicar los cambios al objeto de la DB
        for key, value in update_data.items():
            # Convertir Cheq_Monto a Decimal si se proporciona
            if key == 'Cheq_Monto' and value is not None:
                setattr(db_cheque, key, Decimal(str(value)))
            else:
                setattr(db_cheque, key, value)

        new_monto_decimal = db_cheque.Cheq_Monto
        new_cli_id = db_cheque.Cli_ID
        
        try:
            # 2. Lógica de Ajuste de Saldo
            if old_cli_id == new_cli_id:
                # Caso A: Mismo Cliente - Aplicar solo la diferencia de monto
                # La diferencia (Nuevo - Viejo) se suma al saldo: si el nuevo monto es mayor, aumenta el saldo.
                balance_difference = new_monto_decimal - old_monto_decimal 
                self._adjust_client_balance(old_cli_id, balance_difference)
            else:
                # Caso B: Cambio de Cliente - Transacción doble
                
                # Revertir (restar) el monto anterior del cliente viejo 
                self._adjust_client_balance(old_cli_id, -old_monto_decimal) 
                
                # Aplicar (sumar) el nuevo monto al nuevo cliente 
                self._adjust_client_balance(new_cli_id, new_monto_decimal) 

            # 3. Commit
            self.db.add(db_cheque)
            self.db.commit()
            return self.get_by_id(db_cheque.Cheq_ID)
            
        except ValueError as e:
            self.db.rollback()
            raise e
        
# ----------------------------------------------------------------------
# MÉTODO DE ELIMINACIÓN (DELETE)
# ----------------------------------------------------------------------

    def delete(self, cheque_id: int) -> Optional[Cheque]:
        """
        Elimina un cheque y revierte el monto del saldo del cliente.
        
        Flujo Transaccional:
        1. Revierte el impacto del monto (RESTA el monto del cheque al saldo del cliente).
        2. Elimina el registro de cheque.
        """
        db_cheque = self.db.execute(select(Cheque).where(Cheque.Cheq_ID == cheque_id)).scalars().first()

        if not db_cheque:
            return None
        
        cheq_monto_decimal = Decimal(str(db_cheque.Cheq_Monto))
        
        try:
            # 1. Lógica de saldo: Revertir el impacto (restar el monto que se sumó al crear)
            self._adjust_client_balance(db_cheque.Cli_ID, -cheq_monto_decimal) 
            
            # 2. Eliminación
            cheque_eliminado = db_cheque
            self.db.delete(db_cheque)
            self.db.commit()
            return cheque_eliminado
            
        except ValueError as e:
            self.db.rollback()
            raise e