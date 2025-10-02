from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List

from ..schemas.cliente import ClienteCreate, Cliente, ClienteUpdate # Asegúrate de importar ClienteUpdate
from ..repositorios.clientes_repository import ClienteRepository
from ..dependencies import get_db

router = APIRouter(
    prefix="/clientes",
    tags=["clientes"],
)

def get_cliente_repo(db: Session = Depends(get_db)) -> ClienteRepository:
    return ClienteRepository(db)

@router.post("/", response_model=Cliente, status_code=status.HTTP_201_CREATED)
def create_cliente(cliente_data: ClienteCreate, db: Session = Depends(get_db)):
    repo = get_cliente_repo(db)
    db_cliente = repo.create(cliente_data)
    if db_cliente is None:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Error al crear el cliente. Revisa los datos."
        )
    return db_cliente

@router.get("/", response_model=List[Cliente], summary="Obtener todos los clientes")
def get_all_clientes(repo: ClienteRepository = Depends(get_cliente_repo)):
    return repo.get_all()

@router.get("/{cliente_id}", response_model=Cliente)
def get_cliente(cliente_id: int, db: Session = Depends(get_db)):
    repo = ClienteRepository(db)
    db_cliente = repo.get_by_id(cliente_id)
    if db_cliente is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Cliente con la ID {cliente_id} otorgada no fue encontrada en la base de datos"
        )
    return db_cliente

@router.put("/{cliente_id}", response_model=Cliente, summary="Actualizar un cliente existente")
def update_cliente(
    cliente_id: int,
    cliente_update: ClienteUpdate,
    repo: ClienteRepository = Depends(get_cliente_repo)
):
    cliente = repo.update(cliente_id, cliente_update)
    if not cliente:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Cliente con la ID {cliente_id} otorgada no fue encontrado en la base de datos"
        )
    return cliente

@router.delete("/{cliente_id}", response_model=Cliente, status_code=status.HTTP_200_OK)
def delete_cliente(
    cliente_id: int,
    repo: ClienteRepository = Depends(get_cliente_repo)
):
    if not repo.delete(cliente_id):
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, 
            detail=f"Cliente con la ID {cliente_id} otorgada no fue encontrada en la base de datos")
    return {
        "status":"success",
        "id_eliminado": cliente_id,
        "message": f"Cliente con ID {cliente_id} eliminado exitosamente."
    }
# Puedes añadir una ruta de bienvenida para probar que todo funciona.
@router.get("/")
def read_root():
    return {"mensaje": "¡Bienvenido a la API de Estudio Contable!"}