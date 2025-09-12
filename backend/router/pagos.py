from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List

# Importa los esquemas y repositorios
from backend.dependencies import get_db
from backend.schemas import pago
from backend.repositorios.pago_repository import PagosRepository

router = APIRouter(
    prefix= "/pagos",
    tags=["Pagos"]
)

@router.post("/", response_model=pago.Pago, status_code=status.HTTP_201_CREATED)
def create_pago(pago_data: pago.PagoCreate, db: Session = Depends(get_db)):
    repo = PagosRepository(db)
    db_pago = repo.create(pago_data)
    if db_pago is None:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Error al crear el pago"
        )
    return db_pago

@router.get("/", response_model=List[pago.Pago])
def get_all_pagos(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    repo = PagosRepository(db)
    pagos = repo.get_all(skip=skip, limit=limit)
    return pagos

@router.put("/{pago_id}", response_model=pago.Pago)
def update_pagos(pago_id: int, pago_data: pago.PagoUpdate, db: Session = Depends(get_db)):
    repo = PagosRepository(db)
    db_pago = repo.update(pago_id, pago_data)
    if db_pago is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Pago no encontrado"
        )
    return db_pago

@router.delete("/{pago_id}", status_code=status.HTTP_200_OK)
def delete_pago(pago_id: int, db: Session = Depends(get_db)):
    repo = PagosRepository(db)
    deleted_pago = repo.delete(pago_id)
    if deleted_pago is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Pago no encontrado"
        )
    return {"message": f"Pago con ID {pago_id} del eliminado correctamente"}