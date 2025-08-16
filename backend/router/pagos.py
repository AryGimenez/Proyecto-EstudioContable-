from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List

from backend import database, models, schemas
from backend.dependencies import get_db
from backend.schemas import pago  # Importación corregida

router = APIRouter(
    prefix="/pagos",
    tags=["pagos"],
    dependencies=[Depends(get_db)]
)

@router.post("/", response_model=pago.Pago)
def create_pago(pago_data: pago.PagoCreate, db: Session = Depends(get_db)):
    db_pago = models.Pago(**pago_data.dict())
    db.add(db_pago)
    db.commit()
    db.refresh(db_pago)
    return db_pago

@router.get("/", response_model=List[pago.Pago])
def read_pagos(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    pagos = db.query(models.Pago).offset(skip).limit(limit).all()
    return pagos

@router.get("/{pago_id}", response_model=pago.Pago)
def read_pago(pago_id: int, db: Session = Depends(get_db)):
    db_pago = db.query(models.Pago).filter(models.Pago.id == pago_id).first()
    if db_pago is None:
        raise HTTPException(status_code=404, detail="Pago no encontrado")
    return db_pago

@router.put("/{pago_id}", response_model=pago.Pago)
def update_pago(pago_id: int, pago_data: pago.PagoUpdate, db: Session = Depends(get_db)):
    db_pago = db.query(models.Pago).filter(models.Pago.id == pago_id).first()
    if db_pago is None:
        raise HTTPException(status_code=404, detail="Pago no encontrado")
    for key, value in pago_data.dict(exclude_unset=True).items():
        setattr(db_pago, key, value)
    db.commit()
    db.refresh(db_pago)
    return db_pago

@router.delete("/{pago_id}", response_model=pago.Pago)
def delete_pago(pago_id: int, db: Session = Depends(get_db)):
    db_pago = db.query(models.Pago).filter(models.Pago.id == pago_id).first()
    if db_pago is None:
        raise HTTPException(status_code=404, detail="Pago no encontrado")
    db.delete(db_pago)
    db.commit()
    return db_pago