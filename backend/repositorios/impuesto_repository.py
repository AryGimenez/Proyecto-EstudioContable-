# backend/repositorios/impuesto_repository.py

from sqlalchemy.orm import Session
from sqlalchemy.exc import IntegrityError
from backend import models, schemas

class ImpuestoRepository:
    def __init__(self, db: Session):
        self.db = db
# Obtiene un impuesto por ID
    def get_by_id(self, impuesto_id: int):
        return self.db.query(models.Impuesto).filter(models.Impuesto.Imp_ID == impuesto_id).first()
# Obtiene todos los impuestos
    def get_all(self, skip: int = 0, limit: int = 100):
        return self.db.query(models.Impuesto).offset(skip).limit(limit).all()
#  Crea un nuevo impuesto
    def create(self, impuesto_data: schemas.impuesto.ImpuestoCreate):
        db_impuesto = models.Impuesto(
            Imp_Monto=impuesto_data.Imp_Monto,
            Imp_Moneda=impuesto_data.Imp_Moneda,
            Imp_Frecuencia=impuesto_data.Imp_Frecuencia,
            Imp_Dias=impuesto_data.Imp_Dias,
            Imp_Vencimiento=impuesto_data.Imp_Vencimiento,
            Cli_ID=impuesto_data.Cli_ID
        )
        self.db.add(db_impuesto)
        try:
            self.db.commit()
            self.db.refresh(db_impuesto)
            return db_impuesto
        except IntegrityError:
            self.db.rollback()
            return None
#   Actualiza un impuesto existente
    def update(self, impuesto_id: int, impuesto_data: schemas.impuesto.ImpuestoUpdate):
        db_impuesto = self.get_by_id(impuesto_id)
        if db_impuesto is None:
            return None
        
        update_data = impuesto_data.dict(exclude_unset=True)
        for key, value in update_data.items():
            setattr(db_impuesto, key, value)
        
        try:
            self.db.commit()
            self.db.refresh(db_impuesto)
            return db_impuesto
        except IntegrityError:
            self.db.rollback()
            return None
#   Elimina un impuesto existente
    def delete(self, impuesto_id: int):
        db_impuesto = self.get_by_id(impuesto_id)
        if db_impuesto is None:
            return None
        self.db.delete(db_impuesto)
        self.db.commit()
        return db_impuesto