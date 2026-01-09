# backend/repositorios/pago_repository.py

from sqlalchemy.orm import Session, joinedload
from sqlalchemy import select
from fastapi import HTTPException, status
from typing import List, Optional
from decimal import Decimal # Usar Decimal para manejo de dinero

from ..models.pago import Pago
from ..models.cliente_model import ClienteModel
from ..models.impuesto import Impuesto
from ..schemas.pago import PagoCreate, PagoUpdate


class PagoRepository:
    """
    Clase de repositorio que maneja las operaciones CRUD para el modelo Pago.
    Un pago representa una transacción que incrementa el saldo (Cli_Saldo) del cliente 
    y está diseñado para cubrir un Impuesto específico (Imp_ID obligatorio).
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
            HTTPException: 404 NOT FOUND si el cliente no existe.
        """
        if amount_difference == Decimal(0): # Aseguramos la comparación con tipo Decimal
            return

        cliente = self.db.execute(
            select(Cliente)
            .filter(Cliente.Cli_ID == cli_id)
        ).scalars().first()

        if not cliente:
            # Propaga una excepción HTTP que FastAPI capturará
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=f"Cliente con ID {cli_id} no encontrado para ajustar saldo.")
        
        # Un pago siempre modifica el saldo del cliente
        cliente.Cli_Saldo += amount_difference
        self.db.add(cliente)
        # El commit es realizado por la función principal

# ----------------------------------------------------------------------
# MÉTODOS DE CONSULTA (GET)
# ----------------------------------------------------------------------

    def get_by_id(self, pago_id: int) -> Optional[Pago]:
        """Busca un pago específico por su ID, cargando Cliente e Impuesto asociados."""
        return self.db.execute(
            select(Pago)
            .filter(Pago.Pago_ID == pago_id)
            .options(joinedload(Pago.cliente), joinedload(Pago.impuesto)) # Carga eager loading
        ).scalars().first()
        
    def get_all(self, skip: int = 0, limit: int = 100) -> List[Pago]:
        """Obtiene una lista de todos los pagos, con paginación y relaciones cargadas."""
        return self.db.execute(
            select(Pago)
            .options(joinedload(Pago.cliente), joinedload(Pago.impuesto))
            .offset(skip)
            .limit(limit)
        ).scalars().all()
        
    def get_all_by_client(self, client_id: int) -> List[Pago]:
        """Obtiene todos los pagos asociados a un cliente específico, ordenados por fecha."""
        return self.db.execute(
            select(Pago)
            .filter(Pago.Cli_ID == client_id)
            .order_by(Pago.Pago_Fecha.desc()) 
            .options(joinedload(Pago.cliente), joinedload(Pago.impuesto))
        ).scalars().all()


# ----------------------------------------------------------------------
# MÉTODO DE CREACIÓN (CREATE)
# ----------------------------------------------------------------------

    def create(self, pago_data: PagoCreate) -> Pago:
        """
        Crea un nuevo pago, valida las FKs (Impuesto) y SUMA el monto al saldo del cliente.
        
        Raises:
            HTTPException: 400 (Imp_ID faltante) o 404 (Impuesto/Cliente no encontrado).
            Exception: Para cualquier otro error durante el commit.
        """
        pago_monto_decimal = Decimal(str(pago_data.Pago_Monto))
        
        # 1. Verificar existencia del impuesto (Imp_ID es obligatorio)
        if not pago_data.Imp_ID:
            raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Imp_ID es obligatorio para crear un pago, ya que está diseñado para impuestos.")
            
        impuesto = self.db.execute(
            select(Impuesto).filter(Impuesto.Imp_ID == pago_data.Imp_ID)
        ).scalars().first() 
        
        if not impuesto:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=f"Impuesto con ID {pago_data.Imp_ID} no encontrado.")
        
        # 2. Crear el objeto Pago (Manejo de Decimal)
        db_pago = Pago(**pago_data.dict(exclude={'Pago_Monto'}), Pago_Monto=pago_monto_decimal)
        self.db.add(db_pago)

        try:
            # 3. Lógica de Saldo: Los pagos siempre SUMAN el monto al saldo del cliente
            self._adjust_client_balance(pago_data.Cli_ID, pago_monto_decimal)
            
            # 4. Commit
            self.db.commit()
            self.db.refresh(db_pago)
            # Retornar el pago con las relaciones cargadas
            return self.get_by_id(db_pago.Pago_ID)
            
        except HTTPException:
            self.db.rollback()
            raise # Re-lanzar la HTTPException del helper si el cliente no existe
        except Exception as e:
            self.db.rollback()
            raise e


# ----------------------------------------------------------------------
# MÉTODO DE ACTUALIZACIÓN (UPDATE)
# ----------------------------------------------------------------------

    def update(self, pago_id: int, pago_update: PagoUpdate) -> Optional[Pago]:
        """
        Actualiza un pago, valida el nuevo Impuesto (si cambia) y aplica la diferencia de saldo.
        
        Flujo:
        1. Valida la existencia del nuevo Impuesto.
        2. Aplica los cambios al objeto.
        3. Si el cliente no cambia, ajusta la diferencia: `(MontoNuevo - MontoViejo)` se suma al saldo.
        4. Si el cliente cambia, revierte el monto viejo (`-MontoViejo`) y aplica el nuevo (`+MontoNuevo`).
        
        Raises:
            HTTPException: 404 NOT FOUND si el Pago, Impuesto, o Cliente no existe.
        """
        
        db_pago = self.get_by_id(pago_id)
        if not db_pago:
            return None
        
        update_data = pago_update.dict(exclude_unset=True) 
        
        old_monto_decimal = Decimal(str(db_pago.Pago_Monto))
        old_cli_id = db_pago.Cli_ID
        
        # 1. Validaciones (Impuesto)
        if 'Imp_ID' in update_data and update_data['Imp_ID'] is not None:
             impuesto = self.db.execute(
                 select(Impuesto).filter(Impuesto.Imp_ID == update_data['Imp_ID'])
             ).scalars().first()
             if not impuesto:
                 raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=f"Impuesto con ID {update_data['Imp_ID']} no encontrado para la actualización.")

        # 2. Aplicar los cambios al objeto
        for key, value in update_data.items():
            # Si es el monto, asegúrate de que se almacene como Decimal
            if key == 'Pago_Monto' and value is not None:
                setattr(db_pago, key, Decimal(str(value)))
            else:
                setattr(db_pago, key, value)

        # 3. Recalcular el nuevo monto y cliente
        new_monto_decimal = db_pago.Pago_Monto
        new_cli_id = db_pago.Cli_ID

        try:
            # 4. Lógica de Ajuste de Saldo Diferencial
            if old_cli_id == new_cli_id:
                # Caso A: Mismo cliente: Calcular la diferencia neta que debe sumarse al saldo.
                # CORRECCIÓN: Si el nuevo monto es mayor, el saldo DEBE aumentar. 
                # Por lo tanto, (Nuevo - Viejo).
                balance_difference = new_monto_decimal - old_monto_decimal 
                self._adjust_client_balance(old_cli_id, balance_difference)
            else:
                # Caso B: Cambio de cliente: Revertir del viejo y aplicar al nuevo
                
                # Revertir el monto anterior del cliente viejo (Restar)
                self._adjust_client_balance(old_cli_id, -old_monto_decimal) 
                
                # Aplicar el nuevo monto al nuevo cliente (Sumar)
                self._adjust_client_balance(new_cli_id, new_monto_decimal) 

            # 5. Commit
            self.db.add(db_pago)
            self.db.commit()
            return self.get_by_id(db_pago.Pago_ID)
            
        except HTTPException:
            self.db.rollback()
            raise
        
# ----------------------------------------------------------------------
# MÉTODO DE ELIMINACIÓN (DELETE)
# ----------------------------------------------------------------------
 
    def delete(self, pago_id: int) -> Optional[Pago]:
        """
        Elimina un pago y revierte el monto del saldo del cliente.
        
        Flujo: El monto del pago se RESTA del saldo del cliente para revertir la transacción.
        
        Raises:
            HTTPException: 404 NOT FOUND si el Cliente no existe para revertir el saldo.
        """
        db_pago = self.get_by_id(pago_id)
        if not db_pago:
            return None
        
        pago_monto_decimal = Decimal(str(db_pago.Pago_Monto))
        
        try:
            # 1. Lógica de saldo: Revertir el impacto (restar el monto del pago del saldo del cliente)
            self._adjust_client_balance(db_pago.Cli_ID, -pago_monto_decimal) 
            
            # 2. Eliminación
            pago_eliminado = db_pago
            self.db.delete(db_pago)
            self.db.commit()
            return pago_eliminado
            
        except HTTPException:
            self.db.rollback()
            raise