# backend/router/impuestos.py

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List

# Importa los esquemas y el repositorio
from backend.dependencies import get_db
from backend.schemas import impuesto
from backend.repositorios.impuesto_repository import ImpuestoRepository

router = APIRouter(
    prefix="/impuestos",
   tags=["Impuestos"]
)

@router.post("/", response_model=impuesto.Impuesto, status_code=status.HTTP_201_CREATED)
def create_impuesto(impuesto_data: impuesto.ImpuestoCreate, db: Session = Depends(get_db)):
    repo = ImpuestoRepository(db)
    db_impuesto = repo.create(impuesto_data)
    if db_impuesto is None:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Error al crear el impuesto."
        )
    return db_impuesto

@router.get("/", response_model=List[impuesto.Impuesto])
def get_all_impuestos(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    repo = ImpuestoRepository(db)
    impuestos = repo.get_all(skip=skip, limit=limit)
    return impuestos

@router.put("/{impuesto_id}", response_model=impuesto.Impuesto)
def update_impuesto(impuesto_id: int, impuesto_data: impuesto.ImpuestoUpdate, db: Session = Depends(get_db)):
    repo = ImpuestoRepository(db)
    db_impuesto = repo.update(impuesto_id, impuesto_data)
    if db_impuesto is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Impuesto no encontrado o error al actualizar."
        )
    return db_impuesto

@router.delete("/{impuesto_id}", status_code=status.HTTP_200_OK)
def delete_impuesto(impuesto_id: int, db: Session = Depends(get_db)):
    repo = ImpuestoRepository(db)
    deleted_impuesto = repo.delete(impuesto_id)
    if deleted_impuesto is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Impuesto no encontrado."
        )
    return {"message": f"Impuesto con ID {impuesto_id} eliminado correctamente."}