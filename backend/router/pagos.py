# backend/router/pagos.py

# Importaciones de FastAPI y SQLAlchemy
from fastapi import APIRouter, Depends, HTTPException, status # Manejo de rutas, inyección de dependencias y excepciones HTTP
from sqlalchemy.orm import Session # Manejo de sesiones de base de datos
from typing import List # Para definir el tipo de respuesta de lista
import asyncio # Necesario para ejecutar el broadcast de WebSocket en segundo plano

# Importaciones de tu proyecto
from ..dependencies import get_db # Dependencia para obtener la sesión de la base de datos (DB)
from ..schemas.pago import Pago, PagoCreate, PagoUpdate # Esquemas Pydantic para la data y la respuesta
from ..repositorios.pago_repository import PagoRepository # Importa el repositorio con la lógica de negocio y saldo
from ..services.websocket_manager import manager # Gestor de conexiones WebSocket para notificaciones
from ..schemas.notificacion import NotificationMessage # Esquema de notificación (importación mantenida)


# Define el router para Pagos
router = APIRouter(
    prefix= "/pagos", # Prefijo de la URL base para todas las rutas (ej: /pagos)
    tags=["Pagos"] # Etiquetas para la documentación automática (Swagger UI)
)


# ----------------------------------------------------------------------
# DEPENDENCIA (Inyección de Repositorio)
# ----------------------------------------------------------------------

def get_pagos_repo(db: Session = Depends(get_db)) -> PagoRepository:
    """Inyecta la sesión de DB y retorna el repositorio de Pagos."""
    return PagoRepository(db)


# ----------------------------------------------------------------------
# RUTA DE CREACIÓN (POST)
# ----------------------------------------------------------------------

@router.post("/", response_model=Pago, status_code=status.HTTP_201_CREATED, summary="Crear un nuevo pago")
async def create_pago( # Convertido a 'async' para el uso de asyncio.create_task
    pago_data: PagoCreate, # Datos del nuevo pago a crear
    repo: PagoRepository = Depends(get_pagos_repo), # Inyección del repositorio (usando la dependencia)
):
    """Crea un nuevo registro de pago, ajusta el saldo del cliente (aumenta) y emite una notificación WebSocket."""
    try:
        # 1. Crear el pago y aplicar lógica de saldo (manejo dentro del repositorio)
        db_pago = repo.create(pago_data)

        # 2. Lógica de Notificación Web
        notification_message = {
            "type": "pago_recibido",
            "message": f"Pago de {db_pago.Pago_Monto} {db_pago.Pago_Moneda} recibido.",
            "client_id": db_pago.Cli_ID,
            "payment_id": db_pago.Pago_ID,
            "date": db_pago.Pago_Fecha.isoformat() # Convertir date a string para JSON
        }
        
        # Ejecutar el broadcast en segundo plano para no bloquear la respuesta HTTP
        asyncio.create_task(manager.broadcast(notification_message))

        return db_pago
        
    except HTTPException as e:
        # Captura errores de validación de cliente/impuesto (404) lanzados por el repositorio
        raise e
    except Exception as e:
        # Captura errores inesperados (ej. DB IntegrityError)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Error al crear el pago: {str(e)}"
        )
    
# ----------------------------------------------------------------------
# RUTAS DE CONSULTA (GET)
# ----------------------------------------------------------------------

@router.get("/", response_model=List[Pago]) # Responde con una lista de pagos
def get_all_pago(
    skip: int = 0, # Parámetro de consulta para paginación: omitir N elementos
    limit: int = 100, # Parámetro de consulta para paginación: límite de elementos
    repo: PagoRepository = Depends(get_pagos_repo) # Inyección del repositorio
):
    """Obtiene todos los pagos registrados, con paginación."""
    pagos = repo.get_all(skip=skip, limit=limit) # Usa el método del repositorio (con joinedload)
    return pagos

@router.get("/{pago_id}", response_model=Pago) # Responde con el esquema Pago
def get_pago(
    pago_id: int, # Parámetro de ruta: ID del pago
    repo: PagoRepository = Depends(get_pagos_repo) # Inyección del repositorio
):
    """Obtiene los detalles de un pago específico por su ID."""
    db_pago = repo.get_by_id(pago_id) # Usa el método del repositorio (con joinedload)
    if db_pago is None:
        # Si no se encuentra, lanza un error 404
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Pago con la ID {pago_id} otorgada no fue encontrada en la base de datos"
        )
    return db_pago

# ----------------------------------------------------------------------
# RUTA DE ACTUALIZACIÓN (PUT)
# ----------------------------------------------------------------------

@router.put("/{pago_id}", response_model=Pago) # Responde con el esquema Pago
def update_pagos(
    pago_id: int, # ID del pago a actualizar
    pago_data: PagoUpdate, # Datos para actualizar
    repo: PagoRepository = Depends(get_pagos_repo) # Inyección del repositorio
):
    """Actualiza la información de un pago y ajusta el saldo del cliente por la diferencia de monto o cliente."""
    try:
        db_pago = repo.update(pago_id, pago_data) # Usa el método del repositorio (con lógica diferencial de saldo)
    except HTTPException as e:
        # Captura errores de validación (ej. nuevo Cliente/Impuesto no encontrado)
        raise e
        
    if db_pago is None:
        # Si el ID del pago no existe
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Pago no encontrado"
        )
    return db_pago

# ----------------------------------------------------------------------
# RUTA DE ELIMINACIÓN (DELETE)
# ----------------------------------------------------------------------

@router.delete("/{pago_id}", status_code=status.HTTP_200_OK) # Retorna 200 OK y un mensaje de éxito
def delete_pago(
    pago_id: int, # ID del pago a eliminar
    repo: PagoRepository = Depends(get_pagos_repo) # Inyección del repositorio
):
    """Elimina un pago por su ID y revierte el monto del pago del saldo del cliente."""
    try:
        deleted_pago = repo.delete(pago_id) # Usa el método del repositorio (con lógica de reversión de saldo)
    except HTTPException as e:
        # Captura errores si el cliente asociado no puede ser encontrado para revertir el saldo.
        raise e
    except Exception as e:
        # Captura cualquier error inesperado
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=f"Error al eliminar el pago: {e}")
        
    if deleted_pago is None:
        # Si el ID no existe
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Pago no encontrado"
        )
    return {"message": f"Pago con ID {pago_id} eliminado correctamente y saldo revertido."}