# backend/router/users.py

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List

from backend.dependencies import get_db
from backend.schemas import user # Importa el módulo para usar user.Usuario, etc.
from backend.repositorios.usuario_repository import UsuarioRepository
from backend.router.auth import get_current_user # Para proteger las rutas

router = APIRouter(
    prefix="/usuarios",
    tags=["Usuarios"],
    dependencies=[Depends(get_current_user)], # <<-- PROTEGER TODAS LAS RUTAS DE USUARIOS
)

@router.post("/", response_model=user.Usuario, status_code=status.HTTP_201_CREATED)
def create_user(
    user_data: user.UsuarioCreate,
    db: Session = Depends(get_db),
    current_user: user.Usuario = Depends(get_current_user) # Solo usuarios autenticados pueden crear
):
    """
    Crea un nuevo usuario con los datos proporcionados.
    """
    # Opcional: Añadir lógica para verificar si el current_user tiene permisos de administrador
    # if current_user.usuario_rol != "administrador":
    #     raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="No tienes permiso para crear usuarios")

    repo = UsuarioRepository(db)
    db_user = repo.create(user_data) 
    if db_user is None:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="Nombre de usuario o correo electrónico ya registrado"
        )
    return db_user

@router.get("/", response_model=List[user.Usuario])
def read_users(
    skip: int = 0, 
    limit: int = 100, 
    db: Session = Depends(get_db),
    current_user: user.Usuario = Depends(get_current_user) # Solo usuarios autenticados pueden ver todos
):
    """
    Obtiene una lista de todos los usuarios.
    """
    # Opcional: Añadir lógica para verificar si el current_user tiene permisos de administrador
    # if current_user.usuario_rol != "administrador":
    #     raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="No tienes permiso para ver todos los usuarios")

    repo = UsuarioRepository(db)
    return repo.get_all(skip=skip, limit=limit)

@router.get("/{usuario_id}", response_model=user.Usuario)
def read_user(
    usuario_id: int, 
    db: Session = Depends(get_db),
    current_user: user.Usuario = Depends(get_current_user) # Solo usuarios autenticados pueden ver uno
):
    """
    Obtiene los detalles de un usuario por su ID.
    """
    # Opcional: Permitir que un usuario vea su propio perfil, o solo administradores
    # if current_user.usuario_id != usuario_id and current_user.usuario_rol != "administrador":
    #     raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="No tienes permiso para ver este usuario")

    repo = UsuarioRepository(db)
    db_user = repo.get_by_id(usuario_id)
    if db_user is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Usuario no encontrado")
    return db_user

@router.put("/{usuario_id}", response_model=user.Usuario)
def update_user(
    usuario_id: int, 
    user_data: user.UsuarioUpdate, 
    db: Session = Depends(get_db),
    current_user: user.Usuario = Depends(get_current_user) # Solo usuarios autenticados pueden actualizar
):
    """
    Actualiza los datos de un usuario existente.
    """
    # Opcional: Permitir que un usuario actualice su propio perfil, o solo administradores
    # if current_user.usuario_id != usuario_id and current_user.usuario_rol != "administrador":
    #     raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="No tienes permiso para actualizar este usuario")

    repo = UsuarioRepository(db)
    db_user = repo.update(usuario_id, user_data)
    if db_user is None:
        existing_user = repo.get_by_id(usuario_id)
        if existing_user is None:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Usuario con ID {usuario_id} no encontrado para actualizar."
            )
        else: 
            raise HTTPException(
                status_code=status.HTTP_409_CONFLICT,
                detail="No se pudo actualizar. El nombre de usuario o el email ya existen."
            )
    return db_user

@router.delete("/{usuario_id}", status_code=status.HTTP_200_OK)
def delete_user(
    usuario_id: int, 
    db: Session = Depends(get_db),
    current_user: user.Usuario = Depends(get_current_user) # Solo usuarios autenticados pueden borrar
):
    """
    Elimina un usuario por su ID.
    """
    # Opcional: Restringir a solo administradores
    # if current_user.usuario_rol != "administrador":
    #     raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="No tienes permiso para eliminar usuarios")
    
    repo = UsuarioRepository(db)
    deleted_user = repo.delete(usuario_id)
    if deleted_user is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Usuario con ID {usuario_id} no encontrado para eliminar."
        )
    return {"message": f"Usuario con ID {usuario_id} eliminado correctamente."}