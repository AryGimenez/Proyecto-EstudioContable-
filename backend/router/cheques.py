# backend/router/cheques.py

# Importaciones de FastAPI y SQLAlchemy
from fastapi import APIRouter, Depends, HTTPException, status # Importaciones necesarias para manejar rutas y excepciones HTTP
from sqlalchemy.orm import Session # Importación para manejar sesiones de base de datos
from typing import List # Para tipos de listas

# Importaciones de tu proyecto (ajustar rutas si es necesario)
from ..schemas.cheques import ChequeCreate, ChequeUpdate, Cheque # Importa los esquemas de Pydantic para la data y la respuesta
from ..repositorios.cheques_repository import ChequeRepository # Importa el repositorio que contiene la lógica de negocio y saldo
from ..dependencies import get_db # Dependencia para obtener la sesión de la base de datos

# Define el router para Cheques
router = APIRouter(
    prefix="/cheques", # Prefijo de la URL base para todas las rutas de cheques (ej: /cheques)
    tags=["Cheques"] # Etiquetas para la documentación automática (Swagger UI)
)

# Dependencia para obtener el repositorio de cheques (inyección de dependencias)
def get_cheque_repo(db: Session = Depends(get_db)) -> ChequeRepository: 
    """Inyecta la sesión de DB y retorna el repositorio de Cheques."""
    return ChequeRepository(db) # Crea una instancia del repositorio con la sesión de DB


# ----------------------------------------------------------------------
# RUTAS DE CONSULTA (GET)
# ----------------------------------------------------------------------

# Obtener un cheque por ID
@router.get("/{cheque_id}", response_model=Cheque, summary="Obtener un cheque por ID") # Responde con el esquema Cheque
def read_cheque(
    cheque_id: int, # Parámetro de ruta: ID del cheque
    repo: ChequeRepository = Depends(get_cheque_repo) # Inyección del repositorio
):
    """Obtiene los detalles de un cheque por su ID, incluyendo el impuesto asociado si existe."""
    db_cheque = repo.get_by_id(cheque_id) # Busca el cheque (usa joinedload en el repositorio)
    if db_cheque is None: # Si no se encuentra, lanza un error 404
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Cheque con ID {cheque_id} no encontrado."
        )
    return db_cheque # Retorna el cheque encontrado

# Obtener todos los cheques de un cliente específico
@router.get("/cliente/{client_id}", response_model=List[Cheque], summary="Obtener todos los cheques de un cliente") # Responde con una lista de cheques
def read_cheques_by_client(
    client_id: int, # Parámetro de ruta: ID del cliente
    repo: ChequeRepository = Depends(get_cheque_repo) # Inyección del repositorio
):
    """Obtiene todos los cheques asociados a un Cliente ID específico."""
    cheques = repo.get_all_by_client(client_id) # Usa la nueva función del repositorio
    # Si no hay cheques, devuelve una lista vacía (código 200), no un 404
    return cheques 


# ----------------------------------------------------------------------
# RUTAS DE CREACIÓN (POST)
# ----------------------------------------------------------------------

@router.post("/", response_model=Cheque, status_code=status.HTTP_201_CREATED, summary="Crear un nuevo cheque") # Responde con el esquema Cheque y código 201
async def create_cheque(
    cheque_data: ChequeCreate, # Datos del nuevo cheque (NomIm_ID es opcional aquí)
    repo: ChequeRepository = Depends(get_cheque_repo) # Inyección del repositorio
):
    """Crea un nuevo registro de cheque, validando Cliente/Impuesto y ajustando el saldo del cliente."""
    try:
        db_cheque = repo.create(cheque_data) # Intenta crear el cheque y ajusta el saldo del cliente
        
        # Lógica Opcional de Notificación Web (Comentada)
        # asyncio.create_task(manager.broadcast(...)) 
        
        return db_cheque
        
    except ValueError as e:
        # Captura el error de validación del repositorio (Cliente o NomIm_ID no válido/no encontrado)
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, # 404 porque el recurso asociado (Cliente/Impuesto) no existe
            detail=str(e) # Muestra el mensaje de error detallado del repositorio
        )


# ----------------------------------------------------------------------
# RUTAS DE ACTUALIZACIÓN (PUT)
# ----------------------------------------------------------------------

@router.put("/{cheque_id}", response_model=Cheque, summary="Actualizar un cheque existente") # Responde con el esquema Cheque
def update_cheque(
    cheque_id: int, # ID del cheque a actualizar
    cheque_update: ChequeUpdate, # Datos para actualizar
    repo: ChequeRepository = Depends(get_cheque_repo) # Inyección del repositorio
):
    """Actualiza la información de un cheque existente y ajusta el saldo del cliente por la diferencia de monto o cliente."""
    try:
        db_cheque = repo.update(cheque_id, cheque_update) # Intenta actualizar y aplica la lógica diferencial de saldo
        
        if not db_cheque:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=f"Cheque con ID {cheque_id} no encontrado.")
            
        return db_cheque
        
    except ValueError as e:
        # Captura errores de validación interna (ej. NomIm_ID o nuevo Cli_ID no existe)
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, 
            detail=str(e)
        )


# ----------------------------------------------------------------------
# RUTAS DE ELIMINACIÓN (DELETE)
# ----------------------------------------------------------------------

@router.delete("/{cheque_id}", status_code=status.HTTP_204_NO_CONTENT, summary="Eliminar un cheque") # Código 204 indica éxito sin contenido de respuesta
def delete_cheque(
    cheque_id: int, # ID del cheque a eliminar
    repo: ChequeRepository = Depends(get_cheque_repo) # Inyección del repositorio
):
    """Elimina un cheque por su ID y revierte el monto del cheque del saldo del cliente."""
    try:
        if not repo.delete(cheque_id): # Intenta eliminar el cheque y revierte el saldo
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=f"Cheque con ID {cheque_id} no encontrado.")
            
        return {"message": f"Cheque con ID {cheque_id} eliminado exitosamente y saldo revertido."} # Mensaje opcional (si se cambia el status_code a 200)
        
    except ValueError as e:
        # Captura errores si el cliente asociado no puede ser encontrado para revertir el saldo.
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=str(e))
    except Exception as e:
        # Captura cualquier error inesperado (ej. IntegrityError si hay dependencias)
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=f"Error al eliminar el cheque: {e}")