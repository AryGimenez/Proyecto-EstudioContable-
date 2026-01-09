# backend/repositorios/deposito_repository.py

from sqlalchemy.orm import Session, joinedload
from sqlalchemy import select
from sqlalchemy.exc import IntegrityError
from typing import List, Optional
from decimal import Decimal

# Importaciones de modelos y esquemas
from ..models.deposito import Deposito
from ..models.cliente_model import ClienteModel
from ..schemas.deposito import DepositoCreate, DepositoUpdate 
# Asumo que estos esquemas manejan Decimal/float

class DepositoRepository:
    """
    Clase de repositorio que maneja las operaciones CRUD para el modelo Deposito.
    Implementa lógica transaccional para actualizar el saldo del cliente (Cli_Saldo)
    automáticamente ante la creación, actualización o eliminación de depósitos.
    """
    def __init__(self, db: Session):
        """Inicializa el repositorio con la sesión de base de datos."""
        self.db = db

    def _adjust_client_balance(self, cli_id: int, amount_difference: Decimal):
        """
        Método privado para ajustar el saldo del cliente.
        
        Args:
            cli_id (int): ID del cliente cuyo saldo se ajustará.
            amount_difference (Decimal): Cantidad a SUMAR al Cli_Saldo. 
                                         Debe ser positivo para aumentar o negativo para revertir.
                                         
        Raises:
            ValueError: Si el cliente con el ID proporcionado no existe.
        """
        if amount_difference == Decimal(0): # Aseguramos la comparación con tipo Decimal
            return

        cliente = self.db.execute(
            select(Cliente)
            .filter(Cliente.Cli_ID == cli_id)
        ).scalars().first()

        if not cliente:
            raise ValueError(f"Cliente con ID {cli_id} no encontrado para ajustar saldo.")
        
        # Un depósito siempre SUMA al saldo del cliente (es un pago/depósito)
        cliente.Cli_Saldo += amount_difference
        self.db.add(cliente)
        # El commit se realiza en la función principal (create, update, delete)

# ----------------------------------------------------------------------
# MÉTODOS DE CONSULTA (GET)
# ----------------------------------------------------------------------

    def get_by_id(self, deposito_id: int) -> Optional[Deposito]:
        """Busca un depósito específico por su ID."""
        return self.db.execute(
            select(Deposito)
            .filter(Deposito.Dep_ID == deposito_id)
        ).scalars().first()

    def get_all(self, skip: int = 0, limit: int = 100) -> List[Deposito]:
        """Obtiene una lista de todos los depósitos, con paginación."""
        return self.db.execute(
            select(Deposito)
            .offset(skip)
            .limit(limit)
        ).scalars().all()
    
    def get_all_by_client(self, client_id: int) -> List[Deposito]:
        """Obtiene todos los depósitos asociados a un cliente específico, ordenados por fecha."""
        return self.db.execute(
            select(Deposito)
            .filter(Deposito.Cli_ID == client_id)
            .order_by(Deposito.Dep_Fecha.desc())
        ).scalars().all()

# ----------------------------------------------------------------------
# MÉTODO DE CREACIÓN (CREATE)
# ----------------------------------------------------------------------

    def create(self, deposito_data: DepositoCreate) -> Deposito:
        """
        Crea un nuevo depósito, valida el cliente y SUMA el monto al saldo.
        
        Raises:
            ValueError: Si el Cliente asociado no existe.
            IntegrityError: Si falla alguna restricción de base de datos.
        """
        dep_monto_decimal = Decimal(str(deposito_data.Dep_Monto))

        # Crear el objeto Deposito con el monto en formato Decimal
        db_deposito = Deposito(**deposito_data.dict(exclude={'Dep_Monto'}), 
                                Dep_Monto=dep_monto_decimal)
        self.db.add(db_deposito)
        
        try:
            # 1. Ajuste de Saldo: SUMA el monto al saldo del cliente
            self._adjust_client_balance(deposito_data.Cli_ID, dep_monto_decimal)
            
            self.db.commit()
            self.db.refresh(db_deposito)
            
        except IntegrityError as e:
            self.db.rollback()
            raise IntegrityError(f"Error al cargar el depósito (IntegrityError). Detalles: {e}", params=None, orig=None)
        except ValueError as e:
             self.db.rollback()
             raise e # Propaga el error de Cliente no encontrado

        return db_deposito
    
# ----------------------------------------------------------------------
# MÉTODO DE ACTUALIZACIÓN (UPDATE)
# ----------------------------------------------------------------------

    def update(self, deposito_id: int, deposito_update: DepositoUpdate) -> Optional[Deposito]:
        """
        Actualiza un depósito existente, validando cambios y aplicando la diferencia de monto 
        o la transferencia de saldo entre clientes.
        
        Raises:
            ValueError: Si el cliente nuevo/anterior no existe.
        """
        db_deposito = self.get_by_id(deposito_id)
        if not db_deposito:
            return None
        
        old_monto_decimal = Decimal(str(db_deposito.Dep_Monto))
        old_cli_id = db_deposito.Cli_ID

        # Aplicar los campos de actualización antes de la lógica de saldo
        update_data = deposito_update.dict(exclude_unset=True) 
        for key, value in update_data.items():
             # Si es el monto, asegúrate de que se almacene como Decimal
            if key == 'Dep_Monto' and value is not None:
                setattr(db_deposito, key, Decimal(str(value)))
            else:
                setattr(db_deposito, key, value)
        
        # Recalcular el nuevo monto y cliente (usando el objeto db_deposito actualizado)
        new_monto_decimal = db_deposito.Dep_Monto
        new_cli_id = db_deposito.Cli_ID
        
        try:
            # 1. Lógica de Ajuste de Saldo Diferencial
            if old_cli_id == new_cli_id:
                # Caso A: Mismo Cliente - Aplicar solo la diferencia de monto
                # La diferencia debe ser (Nuevo Monto - Viejo Monto). Si Nuevo > Viejo, el saldo AUMENTA.
                balance_difference = new_monto_decimal - old_monto_decimal # 🟢 CORRECCIÓN: (Nuevo - Viejo)
                self._adjust_client_balance(old_cli_id, balance_difference)
            else:
                # Caso B: Cambio de Cliente - Transacción doble
                
                # Revertir el monto anterior del cliente viejo (Restar)
                self._adjust_client_balance(old_cli_id, -old_monto_decimal) 
                
                # Aplicar el nuevo monto al nuevo cliente (Sumar)
                self._adjust_client_balance(new_cli_id, new_monto_decimal) 

            self.db.add(db_deposito)
            self.db.commit()
            return self.get_by_id(db_deposito.Dep_ID)
            
        except ValueError as e:
            self.db.rollback()
            raise e
        
# ----------------------------------------------------------------------
# MÉTODO DE ELIMINACIÓN (DELETE)
# ----------------------------------------------------------------------

    def delete(self, deposito_id: int) -> Optional[Deposito]:
        """
        Elimina un depósito y revierte el monto del saldo del cliente.
        
        Flujo: El monto del depósito se RESTA del saldo del cliente para revertir la transacción.
        
        Raises:
            ValueError: Si el cliente asociado no existe.
        """
        db_deposito = self.get_by_id(deposito_id)
        if not db_deposito:
            return None
        
        dep_monto_decimal = Decimal(str(db_deposito.Dep_Monto))
        
        try:
            # 1. Lógica de saldo: Revertir el impacto (restar el monto del saldo del cliente)
            self._adjust_client_balance(db_deposito.Cli_ID, -dep_monto_decimal) 
            
            # 2. Eliminación
            deposito_eliminado = db_deposito
            self.db.delete(db_deposito)
            self.db.commit()
            return deposito_eliminado
            
        except ValueError as e:
            self.db.rollback()
            raise e