#backend/repositorios/pagos_repository.py

from sqlalchemy.orm import Session
from sqlalchemy.exc import IntegrityError
from datetime import date
from backend import models, schemas



class PagosRepository:
    def __init__(self, db: Session):
        self.db = db
# Obtiene un pago por ID
    def get_by_id(self, pago_id: int):
        return self.db.query(models.Pago).filter(models.Pago.Pago_ID == pago_id).first()
    
# Obtiene todos los pagos
    def get_all(self, skip: int = 0, limit: int = 100):
        return self.db.query(models.Pago).offset(skip).limit(limit).all()
    
# Crea un nuevo pago
    def create(self, pago_data: schemas.pago.PagoCreate):
        db_pago = models.Pago(
            Pago_Monto=pago_data.Pago_Monto,
            Cli_ID=pago_data.Cli_ID,
            Imp_ID=pago_data.Imp_ID,
            Pago_Fecha=pago_data.Pago_Fecha if pago_data.Pago_Fecha else date.today()
        )
        self.db.add(db_pago)
        try:
            self.db.commit()
            self.db.refresh(db_pago)
            return db_pago
        except IntegrityError:
            self.db.rollback()

            return None
        except Exception:
            self.db.rollback()
            return None
        
# Actualiza un pago existente
    def update(self, pago_id: int, pago_data: schemas.pago.PagoUpdate):
        db_pago = self.get_by_id(pago_id)
        if db_pago is None:
            return None
        
        update_data = pago_data.model_dump(exclude_unset=True)
        for key, value in update_data.items():
            setattr(db_pago, key, value)

        try:
            self.db.commit()
            self.db.refresh(db_pago)
            return db_pago
        
        except IntegrityError:
            self.db.rollback()
            return None
        
        except Exception:
            self.db.rollback()
            return None
        
# Elimina un pago existente
    def delete(self, pago_id: int):
        db_pago = self.get_by_id(pago_id)
        if db_pago is None:
            return None
        
        self.db.delete(db_pago)
        try:
            self.db.commit()
            return db_pago
        except Exception:
            self.db.rollback()
            return None