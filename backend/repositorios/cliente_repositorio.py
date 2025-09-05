# backend/repositorios/cliente_repository.py

from sqlalchemy.orm import Session, joinedload
from backend import models, schemas

class ClienteRepository:
    def __init__(self, db: Session):
        self.db = db

    def get_by_id(self, cliente_id: int):
        return self.db.query(models.Cliente).filter_by(id=cliente_id).first()
        
    def get_all(self, skip: int = 0, limit: int = 100):
        return self.db.query(models.Cliente).offset(skip).limit(limit).all()

    def create(self, cliente_data: schemas.cliente.ClienteCreate):
        db_cliente = models.Cliente(**cliente_data.dict())
        self.db.add(db_cliente)
        self.db.commit()
        self.db.refresh(db_cliente)
        return db_cliente
        
    def update(self, cliente_id: int, cliente_data: schemas.cliente.ClienteUpdate):
        db_cliente = self.get_by_id(cliente_id)
        if db_cliente is None:
            return None
        for key, value in cliente_data.dict(exclude_unset=True).items():
            setattr(db_cliente, key, value)
        self.db.commit()
        self.db.refresh(db_cliente)
        return db_cliente

    def delete(self, cliente_id: int):
        db_cliente = self.get_by_id(cliente_id)
        if db_cliente is None:
            return None
        self.db.delete(db_cliente)
        self.db.commit()
        return db_cliente