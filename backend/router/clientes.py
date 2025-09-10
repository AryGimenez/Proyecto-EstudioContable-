from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List

from backend import database, models, schemas
from backend.dependencies import get_db
from backend.schemas import cliente  # Importa el módulo cliente.py
from backend.repositorios.clientes_repository import ClienteRepository  


router = APIRouter(
    prefix="/clientes",
    tags=["clientes"],
    dependencies=[Depends(get_db)]
)

@router.post("/", response_model=cliente.Cliente, status_code=status.HTTP_201_CREATED)
def create_cliente(cliente_data: cliente.ClienteCreate, db: Session = Depends(get_db)):
    repo = ClienteRepository(db)
    db_cliente = repo.create(cliente_data)
    if db_cliente is None:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Error al crear el cliente. Revisa los datos."
        )
    return db_cliente

@router.get("/{cliente_id}", response_model=cliente.Cliente)
def get_cliente(cliente_id: int, db: Session = Depends(get_db)):
    repo = ClienteRepository(db)
    db_cliente = repo.get_by_id(cliente_id)
    if db_cliente is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Cliente no encontrado."
        )
    return db_cliente

@router.get("/", response_model=List[cliente.Cliente])
def get_all_clientes(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    repo = ClienteRepository(db)
    clientes = repo.get_all(skip=skip, limit=limit)
    return clientes

@router.put("/{cliente_id}", response_model=cliente.Cliente)
def update_cliente(cliente_id: int, cliente_data: cliente.ClienteUpdate, db: Session = Depends(get_db)):
    repo = ClienteRepository(db)
    db_cliente = repo.update(cliente_id, cliente_data)
    if db_cliente is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Cliente no encontrado."
        )
    return db_cliente

@router.delete("/{cliente_id}", status_code=status.HTTP_200_OK)
def delete_cliente(cliente_id: int, db: Session = Depends(get_db)):
    repo = ClienteRepository(db)
    deleted_cliente = repo.delete(cliente_id)
    if deleted_cliente is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Cliente no encontrado."
        )
    return {"message": f"Cliente con ID {cliente_id} eliminado correctamente."}

# Puedes añadir una ruta de bienvenida para probar que todo funciona.
@router.get("/")
def read_root():
    return {"mensaje": "¡Bienvenido a la API de Estudio Contable!"}