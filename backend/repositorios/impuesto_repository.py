# backend/repositorios/impuesto_repository.py

from sqlalchemy.orm import Session, joinedload
from sqlalchemy.exc import IntegrityError
from typing import List, Optional

from ..models.impuesto import Impuesto
from ..models.cliente import Cliente
from ..schemas.impuesto import ImpuestoCreate, ImpuestoUpdate
from ..models.nombre_impuesto import NombreImpuesto

class ImpuestoRepository:
    def __init__(self, db: Session):
        self.db = db

# Obtiene un impuesto por ID
    def get_by_id(self, impuesto_id: int) -> Optional[Impuesto]:
        return self.db.query(Impuesto).options(joinedload(Impuesto.nombre_impuesto)).filter(Impuesto.Imp_ID == impuesto_id).first()

# Obtiene todos los impuestos
    def get_all(self, skip: int = 0, limit: int = 100) -> List[Impuesto]:
        return self.db.query(Impuesto).options(joinedload(Impuesto.nombre_impuesto)).all()

#  Crea un nuevo impuesto
    def create(self, impuesto_data:ImpuestoCreate) -> Impuesto:

        cliente = self.db.query(Cliente).filter(Cliente.Cli_ID == impuesto_data.Cli_ID).first()
        if not cliente:
            raise ValueError("Cliente no encontrado para actualizar saldo")

        db_impuesto = Impuesto(**impuesto_data.dict())

        # --- Lógica de CÁLCULO DE HONORARIO (20%) ---
        HONORARIO_RATE = 0.20
        imp_honorario = impuesto_data.Imp_Monto * HONORARIO_RATE
        total_adeudado = impuesto_data.Imp_Monto + imp_honorario
        # ---------------------------------------------
        
        # Crear el objeto Impuesto
        db_impuesto = Impuesto(**impuesto_data.dict(), Imp_Honorario=imp_honorario)
        self.db.add(db_impuesto)
        
        # --- Lógica de saldo: Restar el TOTAL ADEUDADO al saldo del cliente ---
        cliente.Cli_Saldo -= total_adeudado
        self.db.add(cliente)
        # --- Fin lógica de saldo ---

        self.db.commit()
        self.db.refresh(db_impuesto)
        self.db.refresh(cliente)
        return self.get_by_id(db_impuesto.Imp_ID)
    

#   Actualiza un impuesto existente
    def update(self, impuesto_id: int, impuesto_update: ImpuestoUpdate) -> Optional[Impuesto]:
        db_impuesto = self.get_by_id(impuesto_id)
        if not db_impuesto:
            return None
        
        # Lógica de saldo para actualización:
        # Si el monto o el cliente cambian, necesitamos ajustar el saldo anterior y el nuevo.
        if impuesto_update.Imp_Monto is not None or impuesto_update.Cli_ID is not None or impuesto_update.Imp_Monto != db_impuesto.Imp_Monto:

            # CÁLCULOS ANTIGUOS
            old_total_adeudado = db_impuesto.Imp_Monto + db_impuesto.Imp_Honorario
            old_cli_id = db_impuesto.Cli_ID
            
            # 1. Revertir el impacto del total adeudado viejo en el cliente viejo
            old_cliente = self.db.query(Cliente).filter(Cliente.Cli_ID == old_cli_id).first()
            if old_cliente:
                old_cliente.Cli_Saldo += old_total_adeudado # Sumar de nuevo el total viejo
                self.db.add(old_cliente)
            
            # Aplicar la actualización al objeto DB antes de recalcular
            update_data = impuesto_update.dict(exclude_unset=True) 
            for key, value in update_data.items():
                setattr(db_impuesto, key, value)
            
            # CÁLCULOS NUEVOS
            HONORARIO_RATE = 0.20
            # Recalcular el honorario basado en el nuevo Imp_Monto
            new_imp_honorario = db_impuesto.Imp_Monto * HONORARIO_RATE
            db_impuesto.Imp_Honorario = new_imp_honorario
            new_total_adeudado = db_impuesto.Imp_Monto + new_imp_honorario

            # 2. Aplicar el impacto del nuevo total adeudado en el cliente nuevo
            new_cliente = self.db.query(Cliente).filter(Cliente.Cli_ID == db_impuesto.Cli_ID).first()
            if new_cliente:
                new_cliente.Cli_Saldo -= new_total_adeudado # Restar el nuevo total
                self.db.add(new_cliente)
            else:
                raise ValueError("Nuevo cliente no encontrado para actualizar saldo.")

        # Si solo se actualizaron campos que no afectan el monto (ej. Imp_Dias), solo se hace el commit
        else: 
             update_data = impuesto_update.dict(exclude_unset=True) 
             for key, value in update_data.items():
                setattr(db_impuesto, key, value)

        self.db.commit()
        # ... (refrescar clientes)
        return self.get_by_id(db_impuesto.Imp_ID)
        
#   Elimina un impuesto existente
    def delete(self, impuesto_id: int) -> Optional[Impuesto]:
        db_impuesto = self.get_by_id(impuesto_id)
        if not db_impuesto:
            return None
        
        # --- Lógica de saldo: Devolver el TOTAL ADEUDADO al saldo del cliente al eliminar ---
        total_adeudado = db_impuesto.Imp_Monto + db_impuesto.Imp_Honorario
        
        cliente = self.db.query(Cliente).filter(Cliente.Cli_ID == db_impuesto.Cli_ID).first()
        if cliente:
            cliente.Cli_Saldo += total_adeudado # Sumar el total (monto + honorario)
            self.db.add(cliente)
        # --- Fin lógica de saldo ---

        self.db.delete(db_impuesto)
        self.db.commit()
        return db_impuesto