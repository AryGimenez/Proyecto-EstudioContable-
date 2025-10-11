# app/cheques/router.py

# Importaciones de FastAPI y SQLAlchemy
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List

# Importaciones de tu proyecto (ajustar rutas si es necesario)
from ..schemas.cheques import ChequeCreate, ChequeUpdate, Cheque # Importa todo de schemas/cheque.py
from ..repositorios.cheques_repository import ChequeRepository # Importa el repositorio de cheques
from ..dependencies import get_db # Dependencia para obtener la sesión de la base de datos

# Opcional: Si deseas usar notificaciones por WebSocket como en el ejemplo de Depósitos:
# from ..services.websocket_manager import manager 
# from ..schemas.notificacion import NotificationMessage
# import asyncio 

# Define el router para Cheques
router = APIRouter(
    prefix="/cheques", # Prefijo para todas las rutas de cheques
    tags=["Cheques"]
)

# Dependencia para obtener el repositorio de cheques
def get_cheque_repo(db: Session = Depends(get_db)) -> ChequeRepository:
    """Inyecta la sesión de DB y retorna el repositorio de Cheques."""
    return ChequeRepository(db)


# ----------------------------------------------------------------------
# RUTAS DE CONSULTA (GET)
# ----------------------------------------------------------------------

# Obtener un cheque por ID
@router.get("/{cheque_id}", response_model=Cheque, summary="Obtener un cheque por ID")
def read_cheque(
    cheque_id: int, 
    repo: ChequeRepository = Depends(get_cheque_repo)
):
    """Obtiene los detalles de un cheque por su ID."""
    db_cheque = repo.get_by_id(cheque_id)
    if db_cheque is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Cheque con ID {cheque_id} no encontrado."
        )
    return db_cheque

# Obtener todos los cheques de un cliente específico
@router.get("/cliente/{client_id}", response_model=List[Cheque], summary="Obtener todos los cheques de un cliente")
def read_cheques_by_client(
    client_id: int,
    repo: ChequeRepository = Depends(get_cheque_repo)
):
    """Obtiene todos los cheques asociados a un Cliente ID específico."""
    cheques = repo.get_all_by_client(client_id)
    # Si no hay cheques, devuelve una lista vacía, no un 404
    return cheques 


# ----------------------------------------------------------------------
# RUTAS DE CREACIÓN (POST)
# ----------------------------------------------------------------------

@router.post("/", response_model=Cheque, status_code=status.HTTP_201_CREATED, summary="Crear un nuevo cheque")
async def create_cheque(
    cheque_data: ChequeCreate, # Datos del nuevo cheque
    repo: ChequeRepository = Depends(get_cheque_repo)
):
    """Crea un nuevo registro de cheque, validando Cliente y NomIm_ID."""
    try:
        db_cheque = repo.create(cheque_data)
        
        # --- Lógica Opcional de Notificación Web (Si la necesitas) ---
        # notification_message = {
        #     "type": "cheque_recibido",
        #     "message": f"Cheque N° {db_cheque.Cheq_Numero} por {db_cheque.Cheq_Monto} registrado.",
        #     "client_id": db_cheque.Cli_ID,
        #     "cheque_id": db_cheque.Cheq_ID,
        # }
        # asyncio.create_task(manager.broadcast(notification_message)) 
        # -----------------------------------------------------------

        return db_cheque
        
    except ValueError as e:
        # Captura el error de validación (Cliente o NomIm_ID no encontrado)
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, 
            detail=str(e)
        )


# ----------------------------------------------------------------------
# RUTAS DE ACTUALIZACIÓN (PUT)
# ----------------------------------------------------------------------

@router.put("/{cheque_id}", response_model=Cheque, summary="Actualizar un cheque existente")
def update_cheque(
    cheque_id: int, 
    cheque_update: ChequeUpdate,
    repo: ChequeRepository = Depends(get_cheque_repo)
):
    """Actualiza la información de un cheque existente."""
    try:
        db_cheque = repo.update(cheque_id, cheque_update)
        
        if not db_cheque:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=f"Cheque con ID {cheque_id} no encontrado.")
            
        return db_cheque
        
    except ValueError as e:
        # Captura errores de validación interna (ej. nuevo Cliente ID no existe)
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, 
            detail=str(e)
        )


# ----------------------------------------------------------------------
# RUTAS DE ELIMINACIÓN (DELETE)
# ----------------------------------------------------------------------

@router.delete("/{cheque_id}", status_code=status.HTTP_204_NO_CONTENT, summary="Eliminar un cheque")
def delete_cheque(
    cheque_id: int, 
    repo: ChequeRepository = Depends(get_cheque_repo)
):
    """Elimina un cheque por su ID."""
    try:
        if not repo.delete(cheque_id):
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=f"Cheque con ID {cheque_id} no encontrado.")
            
        return
        
    except Exception as e:
        # Captura cualquier error de integridad u otro al eliminar
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=f"Error al eliminar el cheque: {e}")