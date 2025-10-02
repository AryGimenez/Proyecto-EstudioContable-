# backend/router/nombre_impuestos.py

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List

from ..schemas.nombre_impuesto import NombreImpuestoCreate, NombreImpuesto
from ..repositorios.nombre_impuesto_repository import NombreImpuestoRepository
from ..dependencies import get_db

router = APIRouter(
    prefix="/nombre_impuestos",
    tags=["NombreImpuestos"]
)

# Dependency para inyectar el repositorio
def get_nombre_impuesto_repo(db: Session = Depends(get_db)) -> NombreImpuestoRepository:
    return NombreImpuestoRepository(db)

@router.get("/", response_model=List[NombreImpuesto])
def get_all_nombre_impuestos(
    repo: NombreImpuestoRepository = Depends(get_nombre_impuesto_repo)
):
    return repo.get_all()

@router.get("/{nombre_impuesto_id}", response_model=NombreImpuesto)
def get_nombre_impuesto_by_id(
    nombre_impuesto_id: int,
    repo: NombreImpuestoRepository = Depends(get_nombre_impuesto_repo)
):
    nombre_impuesto = repo.get_by_id(nombre_impuesto_id)
    if not nombre_impuesto:
        raise HTTPException(status_code=404, detail="Nombre de Impuesto no encontrado")
    return nombre_impuesto

@router.post("/", response_model=NombreImpuesto, status_code=status.HTTP_201_CREATED)
def create_nombre_impuesto(
    nombre_impuesto: NombreImpuestoCreate,
    repo: NombreImpuestoRepository = Depends(get_nombre_impuesto_repo)
):
    return repo.create(nombre_impuesto)

@router.put("/{nombre_impuesto_id}", response_model=NombreImpuesto)
def update_nombre_impuesto(
    nombre_impuesto_id: int,
    nombre_impuesto_update: NombreImpuestoCreate,
    repo: NombreImpuestoRepository = Depends(get_nombre_impuesto_repo)
):
    nombre_impuesto = repo.update(nombre_impuesto_id, nombre_impuesto_update)
    if not nombre_impuesto:
        raise HTTPException(status_code=404, detail="Nombre de Impuesto no encontrado")
    return nombre_impuesto

@router.delete("/{nombre_impuesto_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_nombre_impuesto(
    nombre_impuesto_id: int,
    repo: NombreImpuestoRepository = Depends(get_nombre_impuesto_repo)
):
    if not repo.delete(nombre_impuesto_id):
        raise HTTPException(status_code=404, detail="Nombre de Impuesto no encontrado")
    return {} # No content