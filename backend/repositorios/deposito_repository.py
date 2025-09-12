# backend/repositorios/depositos_repository.py

from sqlalchemy.orm import Session
from sqlalchemy.exc import IntegrityError
from datetime import date
from backend import models, schemas # Asegúrate de que esto importa models.Deposito y schemas.deposito

class DepositosRepository:
    def __init__(self, db: Session):
        self.db = db

    def get_by_id(self, dep_id: int):
        return self.db.query(models.Deposito).filter(models.Deposito.Dep_ID == dep_id).first()
    
    def get_all(self, skip: int = 0, limit: int = 100):
        return self.db.query(models.Deposito).offset(skip).limit(limit).all()
    
    def create(self, dep_data: schemas.deposito.DepositoCreate):
        db_deposito = models.Deposito(
            Dep_Monto=dep_data.Dep_Monto,
            Dep_Moneda=dep_data.Dep_Moneda,
            Dep_Referencia=dep_data.Dep_Referencia,
            Dep_Fecha=dep_data.Dep_Fecha if dep_data.Dep_Fecha else date.today(),
            Cli_ID=dep_data.Cli_ID
        )
        self.db.add(db_deposito)
        try:
            self.db.commit()
            self.db.refresh(db_deposito)
            return db_deposito
        except IntegrityError:
            self.db.rollback()
            return None
        except Exception:
            self.db.rollback()
            return None
        
    def update(self, dep_id: int, dep_data: schemas.deposito.DepositoUpdate):
        db_deposito = self.get_by_id(dep_id)
        if db_deposito is None:
            return None

        update_data = dep_data.model_dump(exclude_unset=True)
        for key, value in update_data.items():
            setattr(db_deposito, key, value)

        try:
            self.db.commit()
            self.db.refresh(db_deposito)
            return db_deposito
        except IntegrityError:
            self.db.rollback()
            return None
        except Exception:
            self.db.rollback()
            return None
        
# Elimina un Deposito
 
    def delete(self, dep_id: int):
        db_deposito = self.get_by_id(dep_id)
        if db_deposito is None:
            return None
        
        self.db.delete(db_deposito)
        try:
            self.db.commit()
            return db_deposito
        except Exception:
            self.db.rollback()
            return None