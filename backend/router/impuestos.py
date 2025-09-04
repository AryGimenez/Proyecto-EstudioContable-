from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List

from backend import database, models, schemas
from backend.dependencies import get_db
from backend.schemas import impuesto  # Importación corregida

router = APIRouter(
    prefix="/impuestos",
    tags=["impuestos"],
    dependencies=[Depends(get_db)]
)

@router.post("/", response_model=impuesto.Impuesto)
def create_impuesto(impuesto_data: impuesto.ImpuestoCreate, db: Session = Depends(get_db)):
    db_impuesto = models.Impuesto(**impuesto_data.dict())
    db.add(db_impuesto)
    db.commit()
    db.refresh(db_impuesto)
    return db_impuesto

@router.get("/", response_model=List[impuesto.Impuesto])
def read_impuestos(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    impuestos = db.query(models.Impuesto).offset(skip).limit(limit).all()
    return impuestos

@router.get("/{impuesto_id}", response_model=impuesto.Impuesto)
def read_impuesto(impuesto_id: int, db: Session = Depends(get_db)):
    db_impuesto = db.query(models.Impuesto).filter(models.Impuesto.id == impuesto_id).first()
    if db_impuesto is None:
        raise HTTPException(status_code=404, detail="Impuesto no encontrado")
    return db_impuesto

@router.put("/{impuesto_id}", response_model=impuesto.Impuesto)
def update_impuesto(impuesto_id: int, impuesto_data: impuesto.ImpuestoUpdate, db: Session = Depends(get_db)):
    db_impuesto = db.query(models.Impuesto).filter(models.Impuesto.id == impuesto_id).first()
    if db_impuesto is None:
        raise HTTPException(status_code=404, detail="Impuesto no encontrado")
    for key, value in impuesto_data.dict(exclude_unset=True).items():
        setattr(db_impuesto, key, value)
    db.commit()
    db.refresh(db_impuesto)
    return db_impuesto

@router.delete("/{impuesto_id}", response_model=impuesto.Impuesto)
def delete_impuesto(impuesto_id: int, db: Session = Depends(get_db)):
    db_impuesto = db.query(models.Impuesto).filter(models.Impuesto.id == impuesto_id).first()
    if db_impuesto is None:
        raise HTTPException(status_code=404, detail="Impuesto no encontrado")
    db.delete(db_impuesto)
    db.commit()
    return db_impuesto