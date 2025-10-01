#backend/repositorios/pago_repository.py

from sqlalchemy.orm import Session, joinedload
from fastapi import HTTPException, status
from ..models.pago import Pago
from ..models.cliente import Cliente
from ..models.impuesto import Impuesto
from ..schemas.pago import PagoCreate, PagoUpdate
from typing import List, Optional


class PagoRepository:
    def __init__(self, db: Session):
        self.db = db

# Obtiene un pago por ID
    def get_by_id(self, pago_id: int) -> Optional[Pago]:
        return self.db.query(Pago).filter(Pago.Pago_ID == pago_id).first()
    
# Obtiene todos los pagos
    def get_all(self, skip: int = 0, limit: int = 100) -> List[Pago]:
        return self.db.query(Pago).options(joinedload(Pago.cliente), joinedload(Pago.impuesto)).offset(skip).limit(limit).all()

# Crea un nuevo pago
    def create(self, pago_data: PagoCreate) -> Pago:
        # 1. Verificar existencia del cliente
        cliente = self.db.query(Cliente).filter(Cliente.Cli_ID == pago_data.Cli_ID).first()
        if not cliente:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Cliente no encontrado para el pago.")

        # 2. Verificar existencia del impuesto si se especificó
        impuesto = None
        monto_adeudado_impuesto = 0.0

        if pago_data.Imp_ID:
            impuesto = self.db.query(Impuesto).filter(Impuesto.Imp_ID == pago_data.Imp_ID).first() # <--- ¡CORRECCIÓN AQUÍ!
            if not impuesto:
                raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=f"Impuesto con ID {pago_data.Imp_ID} no encontrado.")
            
            monto_adeudado_impuesto = impuesto.Imp_Monto + impuesto.Imp_Honorario
        
        # 3. Crear el objeto Pago
        db_pago = Pago(**pago_data.model_dump())


        # 4. Lógica de aplicación del pago y actualización de saldos
        monto_del_pago = pago_data.Pago_Monto
        
        if impuesto:
            if monto_del_pago >= monto_adeudado_impuesto:
                saldo_restante_del_pago = monto_del_pago - monto_adeudado_impuesto
                print(f"Pago {db_pago.Pago_ID} cubre impuesto {impuesto.Imp_ID}. Sobrante para saldo general: {saldo_restante_del_pago:.2f}")
            else:
                print(f"Pago {db_pago.Pago_ID} cubre parcialmente impuesto {impuesto.Imp_ID}.")

        # 5. Actualizar el saldo general del cliente (Cli_Saldo)
        # Los pagos siempre AUMENTAN el saldo del cliente (o reducen la deuda).
        cliente.Cli_Saldo += monto_del_pago 
        
        self.db.add(db_pago)
        self.db.commit()
        return db_pago
    
# Actualiza un pago existente
    def update(self, pago_id: int, pago_update: PagoUpdate) -> Optional[Pago]:
        db_pago = self.get_by_id(pago_id).filter(Pago.Pago_ID == pago_id).first()
        if not db_pago:
            return None
        
        # Lógica de saldo para actualización:
        # Si el monto o el cliente cambian, necesitamos ajustar el saldo anterior y el nuevo.
        if db_pago.Pago_Monto != pago_update.Pago_Monto or db_pago.Cli_ID != pago_update.Cli_ID:
            
            # 1. Revertir el impacto del pago viejo en el cliente viejo
            old_cliente = self.db.query(Cliente).filter(Cliente.Cli_ID == db_pago.Cli_ID).first()
            if old_cliente:
                old_cliente.Cli_Saldo -= db_pago.Pago_Monto # Restar de nuevo el monto viejo
                self.db.add(old_cliente)
            
            # 2. Aplicar el impacto del pago nuevo en el cliente nuevo
            new_cliente = self.db.query(Cliente).filter(Cliente.Cli_ID == pago_update.Cli_ID).first()
            if new_cliente:
                new_cliente.Cli_Saldo += pago_update.Pago_Monto # Sumar el monto nuevo
                self.db.add(new_cliente)
            else:
                raise ValueError("Nuevo cliente no encontrado para actualizar saldo.")

        for key, value in pago_update.dict().items():
            setattr(db_pago, key, value)
        
        self.db.commit()
        self.db.refresh(db_pago)
        self.db.refresh(old_cliente)
        if old_cliente and old_cliente.Cli_ID != pago_update.Cli_ID:
             self.db.refresh(new_cliente)
        
        return db_pago
  
# Elimina un pago existente
    def delete(self, pago_id: int) -> Optional[Pago]:
        db_pago = self.get_by_id(pago_id)
        if not db_pago:
            return None
        
        # --- Lógica de saldo: Restar el monto del pago del saldo del cliente al eliminar ---
        cliente = self.db.query(Cliente).filter(Cliente.Cli_ID == db_pago.Cli_ID).first()
        if cliente:
            cliente.Cli_Saldo -= db_pago.Pago_Monto
            self.db.add(cliente)
        # --- Fin lógica de saldo ---

        self.db.delete(db_pago)
        self.db.commit()
        self.db.refresh(cliente) # Refrescar cliente para ver el saldo actualizado
        return db_pago