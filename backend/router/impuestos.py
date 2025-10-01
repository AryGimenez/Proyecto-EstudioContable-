# backend/router/impuestos.py

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List

# Importa los esquemas y el repositorio
from ..dependencies import get_db
from ..schemas.impuesto import ImpuestoCreate, ImpuestoUpdate, Impuesto
from ..repositorios.impuesto_repository import ImpuestoRepository
from ..schemas.notificacion import NotificationMessage

router = APIRouter(
    prefix="/impuestos",
   tags=["Impuestos"]
)

@router.post("/", response_model=Impuesto, status_code=status.HTTP_201_CREATED)
def create_impuesto(impuesto_data: ImpuestoCreate, db: Session = Depends(get_db)):
    repo = ImpuestoRepository(db)
    db_impuesto = repo.create(impuesto_data)
    if db_impuesto is None:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Error al crear el impuesto "
        )
    return db_impuesto

@router.get("/", response_model=List[Impuesto])
def get_all_impuestos(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    repo = ImpuestoRepository(db)
    impuestos = repo.get_all(skip=skip, limit=limit)
    return impuestos


@router.get("/{impuesto_id}", response_model=Impuesto)
def get_impuesto_by_id(impuesto_id: int, db: Session = Depends(get_db)):
    repo = ImpuestoRepository(db)
    db_impuesto = repo.get_by_id(impuesto_id)
    if db_impuesto is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Impuesto con la ID {impuesto_id} otorgada no fue encontrada en la base de datos"
        )
    
    return db_impuesto



@router.put("/{impuesto_id}", response_model=Impuesto)
def update_impuesto(impuesto_id: int, impuesto_data: ImpuestoUpdate, db: Session = Depends(get_db)):
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
            detail=f"Impuesto con ID {impuesto_id} no encontrado."
        )
    
    return {
        "status":"success",
        "id_eliminado": impuesto_id,
        "message": f"Impuesto con ID {impuesto_id} eliminado exitosamente y saldo del cliente actualizado."
    }