# backend/router/impuestos.py

# Importaciones de FastAPI y SQLAlchemy
from fastapi import APIRouter, Depends, HTTPException, status # Importaciones necesarias para manejar rutas y excepciones HTTP
from sqlalchemy.orm import Session # Importación para manejar sesiones de base de datos
from typing import List # Para definir que el tipo de respuesta es una lista

# Importaciones de tu proyecto
from ..dependencies import get_db # Dependencia para obtener la sesión de la base de datos (DB)
from ..schemas.impuesto import ImpuestoCreate, ImpuestoUpdate, Impuesto # Esquemas para crear, actualizar y responder con datos de Impuesto
from ..repositorios.impuesto_repository import ImpuestoRepository # Importa el repositorio que contiene la lógica CRUD y de validación
from ..schemas.notificacion import NotificationMessage # Esquema de notificaciones (importación mantenida)

# Define el router para Impuestos
router = APIRouter(
    prefix="/impuestos", # Prefijo de la URL base para todas las rutas de impuestos (ej: /impuestos)
    tags=["Impuestos"] # Etiquetas para la documentación automática (Swagger UI)
)

# Dependencia para obtener el repositorio de impuestos (inyección de dependencias)
def get_impuesto_repo(db: Session = Depends(get_db)) -> ImpuestoRepository:
    """Inyecta la sesión de DB y retorna el repositorio de Impuestos."""
    return ImpuestoRepository(db) # Crea una instancia del repositorio con la sesión de DB

# ----------------------------------------------------------------------
# RUTA DE CREACIÓN (POST)
# ----------------------------------------------------------------------

@router.post("/", response_model=Impuesto, status_code=status.HTTP_201_CREATED) # Responde con el esquema Impuesto y código 201
def create_impuesto(
    impuesto_data: ImpuestoCreate, # Datos del nuevo impuesto a crear
    db: Session = Depends(get_db) # Sesión de DB inyectada
):
    """Crea un nuevo registro de impuesto y afecta el saldo del cliente (aumenta la deuda)."""
    repo = get_impuesto_repo(db) # Obtiene el repositorio
    
    # El repositorio maneja la validación de Cliente y NombreImpuesto, además de ajustar el saldo.
    try:
        db_impuesto = repo.create(impuesto_data) # Intenta crear el impuesto
    except ValueError as e:
        # Captura errores de validación lanzados por el repositorio (Cliente o NomIm_ID no encontrado)
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, # 404 porque el recurso asociado no existe
            detail=str(e)
        )
    
    if db_impuesto is None: # Comprobación de error genérico del repositorio
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Error al crear el impuesto. Revise los datos."
        )
    return db_impuesto # Retorna el impuesto creado
    
# ----------------------------------------------------------------------
# RUTAS DE CONSULTA (GET)
# ----------------------------------------------------------------------

@router.get("/", response_model=List[Impuesto]) # Responde con una lista de impuestos
def get_all_impuestos(
    skip: int = 0, # Parámetro de consulta para paginación: omitir N elementos
    limit: int = 100, # Parámetro de consulta para paginación: límite de elementos
    db: Session = Depends(get_db) # Sesión de DB inyectada
):
    """Obtiene todos los impuestos registrados, con paginación."""
    repo = get_impuesto_repo(db) # Obtiene el repositorio
    impuestos = repo.get_all(skip=skip, limit=limit) # Busca todos los impuestos (usa joinedload en el repo)
    return impuestos # Retorna la lista de impuestos

@router.get("/{impuesto_id}", response_model=Impuesto) # Responde con el esquema Impuesto
def get_impuesto(
    impuesto_id: int, # Parámetro de ruta: ID del impuesto
    db: Session = Depends(get_db) # Sesión de DB inyectada
):
    """Obtiene los detalles de un impuesto por su ID, incluyendo Cliente y NombreImpuesto."""
    repo = get_impuesto_repo(db) # Obtiene el repositorio
    db_impuesto = repo.get_by_id(impuesto_id) # Busca el impuesto (usa joinedload en el repo)
    
    if db_impuesto is None: # Si no se encuentra, lanza un error 404
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Impuesto con la ID {impuesto_id} otorgada no fue encontrada en la base de datos"
        )
    
    return db_impuesto # Retorna el impuesto encontrado

# ----------------------------------------------------------------------
# RUTA DE ACTUALIZACIÓN (PUT)
# ----------------------------------------------------------------------

@router.put("/{impuesto_id}", response_model=Impuesto) # Responde con el esquema Impuesto
def update_impuesto(
    impuesto_id: int, # ID del impuesto a actualizar
    impuesto_data: ImpuestoUpdate, # Datos para actualizar
    db: Session = Depends(get_db) # Sesión de DB inyectada
):
    """Actualiza la información de un impuesto y ajusta el saldo del cliente si el monto cambia."""
    repo = get_impuesto_repo(db) # Obtiene el repositorio
    
    try:
        db_impuesto = repo.update(impuesto_id, impuesto_data) # Intenta actualizar y aplica la lógica diferencial de saldo
    except ValueError as e:
        # Captura errores de validación lanzados por el repositorio (Cliente o NomIm_ID no válido/no encontrado)
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, 
            detail=str(e)
        )
        
    if db_impuesto is None: # Si el ID no existe
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Impuesto no encontrado o error al actualizar."
        )
        
    return db_impuesto # Retorna el impuesto actualizado

# ----------------------------------------------------------------------
# RUTA DE ELIMINACIÓN (DELETE)
# ----------------------------------------------------------------------

@router.delete("/{impuesto_id}", status_code=status.HTTP_200_OK) # Retorna 200 OK y un mensaje de éxito
def delete_impuesto(
    impuesto_id: int, # ID del impuesto a eliminar
    db: Session = Depends(get_db) # Sesión de DB inyectada
):
    """Elimina un impuesto por su ID y revierte el monto del saldo del cliente."""
    repo = get_impuesto_repo(db) # Obtiene el repositorio
    
    try:
        deleted_impuesto = repo.delete(impuesto_id) # Intenta eliminar y revierte el saldo
    except ValueError as e:
        # Captura errores si el cliente asociado no puede ser encontrado para revertir el saldo.
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=str(e))
    except Exception as e:
        # Captura otros errores (ej. IntegrityError si hay dependencias que fallan)
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=f"Error al eliminar el impuesto: {e}")

    if deleted_impuesto is None: # Si el ID no existe
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Impuesto con ID {impuesto_id} no encontrado."
        )
    
    return {
        "status":"success",
        "id_eliminado": impuesto_id,
        "message": f"Impuesto con ID {impuesto_id} eliminado exitosamente y saldo del cliente actualizado."
    } # Retorna el mensaje de éxito