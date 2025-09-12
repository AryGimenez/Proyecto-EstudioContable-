from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List

from backend.dependencies import get_db
from backend.schemas import deposito
from backend.repositorios.deposito_repository import DepositosRepository

router = APIRouter(
    prefix="/depositos",
    tags=["Depositos"]
)

@router.post("/", response_model=deposito.Deposito, status_code=status.HTTP_201_CREATED)
def create_deposito(deposito_data: deposito.DepositoCreate, db: Session = Depends(get_db)):
    repo = DepositosRepository(db)
    db_deposito = repo.create(deposito_data)
    if db_deposito is None:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail= "Error al crear el deposito. Verifique que el Cli_ID exista y se valido"
        )
    return db_deposito

@router.get("/", response_model=List[deposito.Deposito])
def get_all_depositos(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    repo = DepositosRepository(db)
    depositos = repo.get_all(skip=skip, limit=limit)
    return depositos

@router.put("/{dep_id}", response_model=deposito.Deposito)
def update_deposito(dep_id: int, deposito_data: deposito.DepositoUpdate, db: Session = Depends(get_db)):
    repo = DepositosRepository(db)
    db_deposito = repo.update(dep_id, deposito_data)
    if db_deposito is None:
        existing_deposito = repo.get_by_id(dep_id)
        if existing_deposito is None:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Depósito con ID {dep_id} no encontrado."
            )
        else:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Error al actualizar el depósito. Verifique que el Cli_ID exista y sea válido"
            )
    return db_deposito

@router.delete("/{dep_id}", status_code=status.HTTP_200_OK)
def delete_deposito(dep_id: int, db: Session = Depends(get_db)):
    repo = DepositosRepository(db)
    deleted_deposito = repo.delete(dep_id)
    if delete_deposito is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Depósito con ID {dep_id} no encontrado para eliminar."
        )
    return {"message": f"Depósito con ID {dep_id} eliminado correctamente."}

