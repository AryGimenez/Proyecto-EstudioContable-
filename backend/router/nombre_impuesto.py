# backend/router/nombre_impuestos.py

# Importaciones de FastAPI y SQLAlchemy
from fastapi import APIRouter, Depends, HTTPException, status # Importaciones necesarias para manejar rutas y excepciones HTTP
from sqlalchemy.orm import Session # Importación para manejar sesiones de base de datos
from typing import List # Para definir que el tipo de respuesta es una lista

# Importaciones de tu proyecto
from ..schemas.nombre_impuesto import NombreImpuestoCreate, NombreImpuesto # Esquemas para crear, actualizar y responder
from ..repositorios.nombre_impuesto_repository import NombreImpuestoRepository # Importa el repositorio con la lógica CRUD
from ..dependencies import get_db # Dependencia para obtener la sesión de la base de datos (DB)

# Define el router para Nombres de Impuestos
router = APIRouter(
    prefix="/nombre_impuestos", # Prefijo de la URL base para todas las rutas
    tags=["NombreImpuestos"] # Etiquetas para la documentación automática (Swagger UI)
)

# Dependencia para inyectar el repositorio (inyección de dependencias)
def get_nombre_impuesto_repo(db: Session = Depends(get_db)) -> NombreImpuestoRepository:
    """Inyecta la sesión de DB y retorna el repositorio de Nombres de Impuestos."""
    return NombreImpuestoRepository(db) # Crea una instancia del repositorio con la sesión de DB

# ----------------------------------------------------------------------
# RUTA DE CONSULTA (GET ALL)
# ----------------------------------------------------------------------

@router.get("/", response_model=List[NombreImpuesto]) # Responde con una lista de nombres de impuestos
def get_all_nombre_impuestos(
    repo: NombreImpuestoRepository = Depends(get_nombre_impuesto_repo) # Inyección del repositorio
):
    """Obtiene todos los tipos de nombres de impuestos registrados."""
    return repo.get_all() # Retorna la lista completa

# ----------------------------------------------------------------------
# RUTA DE CONSULTA POR ID (GET BY ID)
# ----------------------------------------------------------------------

@router.get("/{nombre_impuesto_id}", response_model=NombreImpuesto) # Responde con el esquema NombreImpuesto
def get_nombre_impuesto_by_id(
    nombre_impuesto_id: int, # Parámetro de ruta: ID del nombre de impuesto
    repo: NombreImpuestoRepository = Depends(get_nombre_impuesto_repo) # Inyección del repositorio
):
    """Obtiene un nombre de impuesto específico por su ID."""
    nombre_impuesto = repo.get_by_id(nombre_impuesto_id) # Busca el nombre de impuesto por ID
    if not nombre_impuesto:
        # Si no se encuentra, lanza un error 404
        raise HTTPException(status_code=404, detail="Nombre de Impuesto no encontrado") 
    return nombre_impuesto # Retorna el objeto encontrado

# ----------------------------------------------------------------------
# RUTA DE CREACIÓN (POST)
# ----------------------------------------------------------------------

@router.post("/", response_model=NombreImpuesto, status_code=status.HTTP_201_CREATED) # Responde con el esquema NombreImpuesto y código 201
def create_nombre_impuesto(
    nombre_impuesto: NombreImpuestoCreate, # Datos del nuevo nombre de impuesto a crear
    repo: NombreImpuestoRepository = Depends(get_nombre_impuesto_repo) # Inyección del repositorio
):
    """Crea un nuevo tipo de nombre de impuesto en la base de datos."""
    # Nota: El repositorio maneja la lógica de creación y el commit
    return repo.create(nombre_impuesto) 

# ----------------------------------------------------------------------
# RUTA DE ACTUALIZACIÓN (PUT)
# ----------------------------------------------------------------------

@router.put("/{nombre_impuesto_id}", response_model=NombreImpuesto) # Responde con el esquema NombreImpuesto
def update_nombre_impuesto(
    nombre_impuesto_id: int, # ID del nombre de impuesto a actualizar
    nombre_impuesto_update: NombreImpuestoCreate, # Datos para la actualización
    repo: NombreImpuestoRepository = Depends(get_nombre_impuesto_repo) # Inyección del repositorio
):
    """Actualiza la información de un nombre de impuesto existente."""
    nombre_impuesto = repo.update(nombre_impuesto_id, nombre_impuesto_update) # Intenta actualizar
    if not nombre_impuesto:
        # Si no se encuentra, lanza un error 404
        raise HTTPException(status_code=404, detail="Nombre de Impuesto no encontrado")
    return nombre_impuesto # Retorna el objeto actualizado

# ----------------------------------------------------------------------
# RUTA DE ELIMINACIÓN (DELETE)
# ----------------------------------------------------------------------

@router.delete("/{nombre_impuesto_id}", status_code=status.HTTP_204_NO_CONTENT) # Código 204 indica éxito sin contenido de respuesta
def delete_nombre_impuesto(
    nombre_impuesto_id: int, # ID del nombre de impuesto a eliminar
    repo: NombreImpuestoRepository = Depends(get_nombre_impuesto_repo) # Inyección del repositorio
):
    """Elimina un nombre de impuesto por su ID."""
    # El repositorio devolverá None si no se encuentra el ID
    if not repo.delete(nombre_impuesto_id): 
        # Si no se elimina (no encontrado), lanza un error 404
        raise HTTPException(status_code=404, detail="Nombre de Impuesto no encontrado")
    # Retorna un diccionario vacío con el código 204 (No Content)
    return {}