# backend/router/users.py

# Importaciones de FastAPI y SQLAlchemy
from fastapi import APIRouter, Depends, HTTPException, status # Manejo de rutas, inyección de dependencias y excepciones HTTP
from sqlalchemy.orm import Session # Manejo de sesiones de base de datos
from typing import List # Para definir el tipo de respuesta de lista

# Importaciones de tu proyecto
from backend.dependencies import get_db # Dependencia para obtener la sesión de la base de datos (DB)
from backend.schemas import user # Importa el módulo de esquemas para acceder a Usuario, UsuarioCreate, etc.
from backend.repositorios.usuario_repository import UsuarioRepository # Importa el repositorio con la lógica CRUD de usuarios
from backend.router.auth import get_current_user # Dependencia crucial para verificar la autenticación del usuario actual

# Define el router para Usuarios
router = APIRouter(
    prefix="/usuarios", # Prefijo de la URL base para todas las rutas (ej: /usuarios)
    tags=["Usuarios"], # Etiquetas para la documentación automática (Swagger UI)
    # 🚨 PROTECCIÓN GLOBAL: Aplica la dependencia get_current_user a TODAS las rutas en este router.
    dependencies=[Depends(get_current_user)], 
)

# ----------------------------------------------------------------------
# RUTA DE CREACIÓN (POST)
# ----------------------------------------------------------------------

@router.post("/", response_model=user.Usuario, status_code=status.HTTP_201_CREATED) # Responde con el esquema Usuario y código 201
def create_user(
    user_data: user.UsuarioCreate, # Datos del nuevo usuario a crear
    db: Session = Depends(get_db), # Sesión de DB inyectada
    current_user: user.Usuario = Depends(get_current_user) # Verifica que haya un usuario autenticado (ya cubierto por el router, pero explícito es mejor)
):
    """
    Crea un nuevo usuario con los datos proporcionados. Requiere autenticación.
    """
    # Lógica Opcional: El comentario sugiere añadir verificación de roles (ej. si solo el administrador puede crear usuarios)
    
    repo = UsuarioRepository(db) # Inicializa el repositorio
    db_user = repo.create(user_data) # Intenta crear el usuario
    
    if db_user is None:
        # El repositorio retorna None si el nombre de usuario o email ya están registrados (Conflicto 409)
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="Nombre de usuario o correo electrónico ya registrado"
        )
    return db_user # Retorna el usuario creado

# ----------------------------------------------------------------------
# RUTA DE CONSULTA (GET ALL)
# ----------------------------------------------------------------------

@router.get("/", response_model=List[user.Usuario]) # Responde con una lista de usuarios
def read_users(
    skip: int = 0, # Parámetro de consulta para paginación (omitir N elementos)
    limit: int = 100, # Parámetro de consulta para paginación (límite de elementos)
    db: Session = Depends(get_db), # Sesión de DB inyectada
    current_user: user.Usuario = Depends(get_current_user) # Verifica que haya un usuario autenticado
):
    """
    Obtiene una lista de todos los usuarios. Requiere autenticación.
    """
    # Lógica Opcional: El comentario sugiere añadir verificación de roles (ej. solo administradores ven todos los usuarios)
    
    repo = UsuarioRepository(db) # Inicializa el repositorio
    return repo.get_all(skip=skip, limit=limit) # Retorna la lista de usuarios con paginación

# ----------------------------------------------------------------------
# RUTA DE CONSULTA POR ID (GET BY ID)
# ----------------------------------------------------------------------

@router.get("/{usuario_id}", response_model=user.Usuario) # Responde con el esquema Usuario
def read_user(
    usuario_id: int, # Parámetro de ruta: ID del usuario a buscar
    db: Session = Depends(get_db), # Sesión de DB inyectada
    current_user: user.Usuario = Depends(get_current_user) # Verifica que haya un usuario autenticado
):
    """
    Obtiene los detalles de un usuario por su ID. Requiere autenticación.
    """
    # Lógica Opcional: El comentario sugiere restringir el acceso (ej. solo el usuario o el admin pueden ver este ID)
    
    repo = UsuarioRepository(db) # Inicializa el repositorio
    db_user = repo.get_by_id(usuario_id) # Busca el usuario por ID
    
    if db_user is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Usuario no encontrado")
        
    return db_user # Retorna el usuario encontrado

# ----------------------------------------------------------------------
# RUTA DE ACTUALIZACIÓN (PUT)
# ----------------------------------------------------------------------

@router.put("/{usuario_id}", response_model=user.Usuario) # Responde con el esquema Usuario
def update_user(
    usuario_id: int, # ID del usuario a actualizar
    user_data: user.UsuarioUpdate, # Datos para actualizar (puede contener nuevos username/email/contraseña)
    db: Session = Depends(get_db), # Sesión de DB inyectada
    current_user: user.Usuario = Depends(get_current_user) # Verifica que haya un usuario autenticado
):
    """
    Actualiza los datos de un usuario existente. Requiere autenticación.
    """
    # Lógica Opcional: El comentario sugiere restringir el acceso (ej. solo el usuario o el admin pueden actualizar este ID)
    
    repo = UsuarioRepository(db) # Inicializa el repositorio
    db_user = repo.update(usuario_id, user_data) # Intenta actualizar
    
    if db_user is None:
        # Si el update falla, debemos verificar si el ID existía o si fue un conflicto
        existing_user = repo.get_by_id(usuario_id)
        if existing_user is None:
            # Caso 1: ID no existe
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Usuario con ID {usuario_id} no encontrado para actualizar."
            )
        else: 
            # Caso 2: Conflicto (username/email ya existen, asumido por el retorno None del repo)
            raise HTTPException(
                status_code=status.HTTP_409_CONFLICT,
                detail="No se pudo actualizar. El nombre de usuario o el email ya existen."
            )
    return db_user # Retorna el usuario actualizado

# ----------------------------------------------------------------------
# RUTA DE ELIMINACIÓN (DELETE)
# ----------------------------------------------------------------------

@router.delete("/{usuario_id}", status_code=status.HTTP_200_OK) # Retorna 200 OK y un mensaje de éxito
def delete_user(
    usuario_id: int, # ID del usuario a eliminar
    db: Session = Depends(get_db), # Sesión de DB inyectada
    current_user: user.Usuario = Depends(get_current_user) # Verifica que haya un usuario autenticado
):
    """
    Elimina un usuario por su ID. Requiere autenticación.
    """
    # Lógica Opcional: El comentario sugiere restringir el acceso (ej. solo administradores pueden borrar)
    
    repo = UsuarioRepository(db) # Inicializa el repositorio
    deleted_user = repo.delete(usuario_id) # Intenta eliminar
    
    if deleted_user is None:
        # Si el repositorio devuelve None, el usuario no fue encontrado
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Usuario con ID {usuario_id} no encontrado para eliminar."
        )
        
    return {"message": f"Usuario con ID {usuario_id} eliminado correctamente."} # Mensaje de éxito