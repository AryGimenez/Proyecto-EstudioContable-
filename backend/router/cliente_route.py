# backend/router/cliente_route.py

# Importaciones de FastAPI y SQLAlchemy
from fastapi import APIRouter, Depends, HTTPException, status # Importaciones necesarias para funciones de FastAPI
from sqlalchemy.orm import Session # Importación para manejar sesiones de base de datos
from typing import List # Para tipos de listas

# Importaciones de tu proyecto
from ..schemas.cliente_schem import ClienteCreate, ClienteSchema, ClienteUpdate # Asegura la importaciones de los esquemas de cliente
from ..repositorios.clientes_repository import ClienteRepository # Importa el repositorio de clientes
from ..dependencies import get_db # Dependencia para obtener la sesión de la base de datos


# Define el router para clientes
router = APIRouter(
    prefix="/clientes", # Prefijo para todas las rutas de clientes, "/" es la url que se usa como camino acceder a estas rutas
    tags=["clientes"], # Etiquetas para la documentación automática (Swagger UI)
)

# Dependencia para obtener el repositorio de clientes (inyección de dependencias)
def get_cliente_repo(db: Session = Depends(get_db)) -> ClienteRepository: # Inyecta la sesión de DB y retorna el repositorio
    return ClienteRepository(db) # Crea una instancia del repositorio de clientes


# Rutas CRUD para clientes (POST, GET, PUT, DELETE)

# Crear un nuevo cliente
@router.post("/", response_model=ClienteSchema, status_code=status.HTTP_201_CREATED) # Responde con el esquema de cliente y código 201
def create_cliente(cliente_data: ClienteCreate, db: Session = Depends(get_db)): # Datos del nuevo cliente y sesión de DB inyectada (dependencia)
    repo = get_cliente_repo(db) # Obtiene el repositorio de clientes
    db_cliente = repo.create(cliente_data) # Intenta crear el cliente en la base de datos
    if db_cliente is None: # Si el cliente ya existe, lanza un error 400
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Error al crear el cliente. Revisa los datos."
        )
    return db_cliente # Retorna el cliente creado, si salta el orden correcto con el post y codigo 201


# Obtener todos los clientes
@router.get("/", response_model=List[ClienteSchema]) # Responde con una lista de clientes
def get_all_clientes(repo: ClienteRepository = Depends(get_cliente_repo)): # Inyecta el repositorio de clientes (dependencia)
    return repo.get_all() # Retorna todos los clientes


# Obtener un cliente por ID
@router.get("/{cliente_id}", response_model=ClienteSchema) # Responde con el esquema de cliente
def get_cliente(cliente_id: int, db: Session = Depends(get_db)): # ID del cliente y sesión de DB inyectada (dependencia)
    repo = ClienteRepository(db) # Crea una instancia del repositorio de clientes
    db_cliente = repo.get_by_id(cliente_id) # Busca el cliente por ID
    if db_cliente is None: # Si no se encuentra, lanza un error 404
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Cliente con la ID {cliente_id} otorgada no fue encontrada en la base de datos"
        )
    return db_cliente # Retorna el cliente encontrado con la id proporcionada si esta en la base de datos


# Actualizar un cliente existente
@router.put("/{cliente_id}", response_model=ClienteSchema) # Responde con el esquema de cliente
def update_cliente(
    cliente_id: int, # ID del cliente a actualizar
    cliente_update: ClienteUpdate, # Datos para actualizar el cliente
    repo: ClienteRepository = Depends(get_cliente_repo) # Inyecta el repositorio de clientes (dependencia)
):
    cliente = repo.update(cliente_id, cliente_update) # Intenta actualizar el cliente
    if not cliente: # Si no se encuentra, lanza un error 404
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Cliente con la ID {cliente_id} otorgada no fue encontrado en la base de datos"
        )
    return cliente # Retorna el cliente actualizado, con los datos modificados


# Eliminar un cliente por ID
@router.delete("/{cliente_id}", response_model=ClienteSchema, status_code=status.HTTP_200_OK) # Responde con el esquema de cliente y código 200
def delete_cliente(
    cliente_id: int, # ID del cliente a eliminar
    repo: ClienteRepository = Depends(get_cliente_repo) # Inyecta el repositorio de clientes (dependencia)
):
    if not repo.delete(cliente_id): # Intenta eliminar el cliente, si no se encuentra lanza un error 404
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, 
            detail=f"Cliente con la ID {cliente_id} otorgada no fue encontrada en la base de datos"
        ) 
    return {"message": f"Cliente con ID {cliente_id} eliminado exitosamente."} # Retorna un mensaje de éxito si se elimina correctamente


# Puedes añadir una ruta de bienvenida para probar que todo funciona.
@router.get("/")
def read_root():
    return {"mensaje": "¡Bienvenido a la API de Estudio Contable!"}