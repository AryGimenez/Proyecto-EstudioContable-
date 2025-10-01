# backend/repositorios/deposito_repository.py

from sqlalchemy.orm import Session
from sqlalchemy.exc import IntegrityError
from datetime import date
from typing import List, Optional

# Importaciones de modelos y esquemas

from ..models.deposito import Deposito
from ..models.cliente import Cliente # Importa el modelo Cliente
from ..schemas.deposito import DepositoCreate, DepositoUpdate

class DepositoRepository:
    def __init__(self, db: Session):
        self.db = db

# Obtiene un Deposito por ID        

    def get_by_id(self, deposito_id: int) -> Optional[Deposito]:

        return self.db.query(Deposito).filter(Deposito.Dep_ID == deposito_id).first()

# Obtiene todos los Depositos    

    def get_all(self, skip: int = 0, limit: int = 100) -> List[Deposito]:

        return self.db.query(Deposito).offset(skip).limit(limit).all()

# Crea un nuevo Deposito

    def create(self, deposito_data: DepositoCreate) -> Deposito:
        # Recuperar el cliente para actualizar su saldo
        cliente = self.db.query(Cliente).filter(Cliente.Cli_ID == deposito_data.Cli_ID).first()
        if not cliente:
            raise ValueError(f"Cliente con ID {deposito_data.Cli_ID} no encontrado para procesar el depósito.")

        db_deposito = Deposito(**deposito_data.dict())
        self.db.add(db_deposito)
        
        # --- Lógica de saldo: Sumar el monto del depósito al saldo del cliente ---
        cliente.Cli_Saldo += deposito_data.Dep_Monto
        self.db.add(cliente) # Marca el cliente como modificado
        # --- Fin lógica de saldo ---

        self.db.commit()
        self.db.refresh(db_deposito)
        self.db.refresh(cliente) # Refrescar cliente para ver el saldo actualizado
        return db_deposito
    
# Actualiza un Deposito existente        
    
    def update(self, deposito_id: int, deposito_update: DepositoUpdate) -> Optional[Deposito]:

        db_deposito = self.get_by_id(deposito_id)
        if not db_deposito:
            return None
        
        # Guardar valores antiguos para la lógica de saldo
        old_monto = db_deposito.Dep_Monto
        old_cli_id = db_deposito.Cli_ID

        # Actualizar los campos del depósito
        update_data = deposito_update.dict(exclude_unset=True) 
        for key, value in update_data.items():
            setattr(db_deposito, key, value)
        
        # Lógica de saldo para actualización:
        # Solo ajustar si el monto o el cliente cambiaron
        if old_monto != db_deposito.Dep_Monto or old_cli_id != db_deposito.Cli_ID:
            
            # 1. Revertir el impacto del depósito viejo en el cliente viejo
            old_cliente = self.db.query(Cliente).filter(Cliente.Cli_ID == old_cli_id).first()
            if old_cliente:
                old_cliente.Cli_Saldo -= old_monto # Restar el monto viejo
                self.db.add(old_cliente)
            
            # 2. Aplicar el impacto del depósito nuevo en el cliente nuevo
            new_cliente = self.db.query(Cliente).filter(Cliente.Cli_ID == db_deposito.Cli_ID).first()
            if new_cliente:
                new_cliente.Cli_Saldo += db_deposito.Dep_Monto # Sumar el monto nuevo
                self.db.add(new_cliente)
            else:
                raise ValueError(f"Nuevo cliente con ID {db_deposito.Cli_ID} no encontrado para actualizar saldo.")

        self.db.commit()
        self.db.refresh(db_deposito)
        if old_cliente: # Refrescar clientes afectados
            self.db.refresh(old_cliente)
        if new_cliente and (old_cli_id != db_deposito.Cli_ID): # Si el cliente cambió o el monto, refrescar el nuevo cliente
             self.db.refresh(new_cliente)

        return db_deposito

        
# Elimina un Deposito
 
    def delete(self, deposito_id: int) -> Optional[Deposito]:

        db_deposito = self.get_by_id(deposito_id)
        if not db_deposito:
            return None
        
        # --- Lógica de saldo: Restar el monto del depósito del saldo del cliente al eliminar ---
        cliente = self.db.query(Cliente).filter(Cliente.Cli_ID == db_deposito.Cli_ID).first()
        if cliente:
            cliente.Cli_Saldo -= db_deposito.Dep_Monto
            self.db.add(cliente)
        # --- Fin lógica de saldo ---

        self.db.delete(db_deposito)
        self.db.commit()
        self.db.refresh(cliente) # Refrescar cliente para ver el saldo actualizado
        return db_deposito