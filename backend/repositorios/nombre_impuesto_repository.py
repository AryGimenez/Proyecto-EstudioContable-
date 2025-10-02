# backend/repositorios/nombre_impuesto_repository.py

from sqlalchemy.orm import Session
from typing import List, Optional

from ..models.nombre_impuesto import NombreImpuesto
from ..schemas.nombre_impuesto import NombreImpuestoCreate

class NombreImpuestoRepository:
    def __init__(self, db: Session):
        self.db = db

    def get_all(self) -> List[NombreImpuesto]:
        return self.db.query(NombreImpuesto).all()

    def get_by_id(self, nombre_impuesto_id: int) -> Optional[NombreImpuesto]:
        return self.db.query(NombreImpuesto).filter(NombreImpuesto.NomIm_Id == nombre_impuesto_id).first()

    def create(self, nombre_impuesto: NombreImpuestoCreate) -> NombreImpuesto:
        db_nombre_impuesto = NombreImpuesto(NomIm_Txt=nombre_impuesto.NomIm_Txt)
        self.db.add(db_nombre_impuesto)
        self.db.commit()
        self.db.refresh(db_nombre_impuesto)
        return db_nombre_impuesto

    def update(self, nombre_impuesto_id: int, nombre_impuesto_update: NombreImpuestoCreate) -> Optional[NombreImpuesto]:
        db_nombre_impuesto = self.get_by_id(nombre_impuesto_id)
        if db_nombre_impuesto:
            db_nombre_impuesto.NomIm_Txt = nombre_impuesto_update.NomIm_Txt
            self.db.commit()
            self.db.refresh(db_nombre_impuesto)
        return db_nombre_impuesto

    def delete(self, nombre_impuesto_id: int) -> Optional[NombreImpuesto]:
        db_nombre_impuesto = self.get_by_id(nombre_impuesto_id)
        if db_nombre_impuesto:
            self.db.delete(db_nombre_impuesto)
            self.db.commit()
        return db_nombre_impuesto