# backend/router/users.py

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List

from backend.dependencies import get_db
from backend.schemas import user
from backend.repositorios.usuario_repository import UsuarioRepository

router = APIRouter(
    prefix="/usuarios",
    tags=["Usuarios"],
    # dependencies=[Depends(get_current_active_user)], # Protect these routes
)

@router.post("/", response_model=user.Usuario, status_code=status.HTTP_201_CREATED)
def create_user(user_data: user.UsuarioCreate, db: Session = Depends(get_db)):
    repo = UsuarioRepository(db)
    db_user = repo.create(user_data) # Llama al método del repositorio
    if db_user is None:
        # 🆕 Si el repositorio retorna None, significa que ya existe el usuario o correo
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="Nombre de usuario o correo electrónico ya registrado"
        )
    return db_user

@router.get("/", response_model=List[user.Usuario])
def read_users(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    repo = UsuarioRepository(db)
    return repo.get_all(skip=skip, limit=limit)

@router.get("/{usuario_id}", response_model=user.Usuario)
def read_user(usuario_id: int, db: Session = Depends(get_db)):
    repo = UsuarioRepository(db)
    db_user = repo.get_by_id(usuario_id)
    if db_user is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Usuario no encontrado"
        )
    return db_user

@router.put("/{usuario_id}", response_model=user.Usuario)
def update_user(usuario_id: int, user_data: user.UsuarioUpdate, db: Session = Depends(get_db)):
    """
    Actualiza los datos de un usuario existente.
    """
    repo = UsuarioRepository(db)
    db_user = repo.update(usuario_id, user_data)
    if db_user is None:
        # Mejora en el manejo de errores para distinguir entre 404 y 409
        # Primero verificamos si el usuario existe para dar un mensaje más preciso
        existing_user = repo.get_by_id(usuario_id)
        if existing_user is None:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Usuario con ID {usuario_id} no encontrado para actualizar."
            )
        else: # El usuario existe, pero la actualización falló por un conflicto de datos
            raise HTTPException(
                status_code=status.HTTP_409_CONFLICT,
                detail="No se pudo actualizar. El nombre de usuario o el email ya existen."
            )
    return db_user

@router.delete("/{usuario_id}", status_code=status.HTTP_200_OK)
def delete_user(usuario_id: int, db: Session = Depends(get_db)):
    """
    Elimina un usuario por su ID.
    """
    repo = UsuarioRepository(db)
    deleted_user = repo.delete(usuario_id)
    if deleted_user is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Usuario con ID {usuario_id} no encontrado para eliminar."
        )
    return {"message": f"Usuario con ID {usuario_id} eliminado correctamente."}