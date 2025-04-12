from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List

from backend import database, models, schemas
from backend.dependencies import get_db
from backend.schemas import deposito  # Importación corregida

router = APIRouter(
    prefix="/depositos",
    tags=["depositos"],
    dependencies=[Depends(get_db)]
)

@router.post("/", response_model=deposito.Deposito)
def create_deposito(deposito_data: deposito.DepositoCreate, db: Session = Depends(get_db)):
    db_deposito = models.Deposito(**deposito_data.dict())
    db.add(db_deposito)
    db.commit()
    db.refresh(db_deposito)
    return db_deposito

@router.get("/", response_model=List[deposito.Deposito])
def read_depositos(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    depositos = db.query(models.Deposito).offset(skip).limit(limit).all()
    return depositos

@router.get("/{deposito_id}", response_model=deposito.Deposito)
def read_deposito(deposito_id: int, db: Session = Depends(get_db)):
    db_deposito = db.query(models.Deposito).filter(models.Deposito.id == deposito_id).first()
    if db_deposito is None:
        raise HTTPException(status_code=404, detail="Deposito no encontrado")
    return db_deposito

@router.put("/{deposito_id}", response_model=deposito.Deposito)
def update_deposito(deposito_id: int, deposito_data: deposito.DepositoUpdate, db: Session = Depends(get_db)):
    db_deposito = db.query(models.Deposito).filter(models.Deposito.id == deposito_id).first()
    if db_deposito is None:
        raise HTTPException(status_code=404, detail="Deposito no encontrado")
    for key, value in deposito_data.dict(exclude_unset=True).items():
        setattr(db_deposito, key, value)
    db.commit()
    db.refresh(db_deposito)
    return db_deposito

@router.delete("/{deposito_id}", response_model=deposito.Deposito)
def delete_deposito(deposito_id: int, db: Session = Depends(get_db)):
    db_deposito = db.query(models.Deposito).filter(models.Deposito.id == deposito_id).first()
    if db_deposito is None:
        raise HTTPException(status_code=404, detail="Deposito no encontrado")
    db.delete(db_deposito)
    db.commit()
    return db_deposito