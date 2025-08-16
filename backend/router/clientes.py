from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List

from backend import database, models, schemas
from backend.dependencies import get_db
from backend.schemas import cliente  # Importa el módulo cliente.py

router = APIRouter(
    prefix="/clientes",
    tags=["clientes"],
    dependencies=[Depends(get_db)]
)

@router.post("/", response_model=cliente.Cliente)  # Usa cliente.Cliente
def create_cliente(cliente_data: cliente.ClienteCreate, db: Session = Depends(get_db)):
    db_cliente = models.Cliente(**cliente_data.dict())
    db.add(db_cliente)
    db.commit()
    db.refresh(db_cliente)
    return db_cliente

@router.get("/", response_model=List[cliente.Cliente])  # Usa cliente.Cliente
def read_clientes(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    clientes = db.query(models.Cliente).offset(skip).limit(limit).all()
    return clientes

@router.get("/{cliente_id}", response_model=cliente.Cliente)  # Usa cliente.Cliente
def read_cliente(cliente_id: int, db: Session = Depends(get_db)):
    db_cliente = db.query(models.Cliente).filter(models.Cliente.id == cliente_id).first()
    if db_cliente is None:
        raise HTTPException(status_code=404, detail="Cliente no encontrado")
    return db_cliente

@router.put("/{cliente_id}", response_model=cliente.Cliente)  # Usa cliente.Cliente
def update_cliente(cliente_id: int, cliente_data: cliente.ClienteUpdate, db: Session = Depends(get_db)):
    db_cliente = db.query(models.Cliente).filter(models.Cliente.id == cliente_id).first()
    if db_cliente is None:
        raise HTTPException(status_code=404, detail="Cliente no encontrado")
    for key, value in cliente_data.dict(exclude_unset=True).items():
        setattr(db_cliente, key, value)
    db.commit()
    db.refresh(db_cliente)
    return db_cliente

@router.delete("/{cliente_id}", response_model=cliente.Cliente)  # Usa cliente.Cliente
def delete_cliente(cliente_id: int, db: Session = Depends(get_db)):
    db_cliente = db.query(models.Cliente).filter(models.Cliente.id == cliente_id).first()
    if db_cliente is None:
        raise HTTPException(status_code=404, detail="Cliente no encontrado")
    db.delete(db_cliente)
    db.commit()
    return db_cliente