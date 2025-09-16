# backend/router/auth.py

from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from sqlalchemy.orm import Session
from datetime import timedelta
from typing import Optional

# Importaciones de tu proyecto
from backend.dependencies import get_db
from backend.repositorios.usuario_repository import UsuarioRepository
from backend.schemas.user import UsuarioCreate, Usuario as UsuarioSchema
from backend.schemas.auth import Token
from backend.security import ( # Tus funciones de seguridad
    create_access_token,
    verify_access_token,
    verify_password
)
from backend.config import ACCESS_TOKEN_EXPIRE_MINUTES

# Define el esquema de autenticación para obtener el token
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/auth/token")

router = APIRouter(prefix="/auth", tags=["Autenticación"])

# Dependencia para obtener el usuario actuenticado
async def get_current_user(
    db: Session = Depends(get_db),
    token: str = Depends(oauth2_scheme)
) -> UsuarioSchema:
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="No se pudieron validar las credenciales",
        headers={"WWW-Authenticate": "Bearer"},
    )

    # 1. Verificar el token JWT usando la función de seguridad
    username = verify_access_token(token)
    if not username:
        raise credentials_exception

    # 2. Buscar el usuario en la base de datos
    user_repo = UsuarioRepository(db)
    user = user_repo.get_by_username(username)
    if user is None:
        raise credentials_exception

    # 3. Retornar el usuario (asegurándonos de que sea un objeto de esquema Pydantic)
    # Pydantic v2 maneja automáticamente la conversión de modelos SQLAlchemy a esquemas con from_attributes=True
    return user

# Endpoint para registrar un nuevo usuario
@router.post("/register", response_model=UsuarioSchema, status_code=status.HTTP_201_CREATED)
def register_user(
    usuario_data: UsuarioCreate,
    db: Session = Depends(get_db)
):
    """
    Registra un nuevo usuario en el sistema.
    """
    repo = UsuarioRepository(db)
    db_usuario = repo.create(usuario_data)
    
    if db_usuario is None:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="El nombre de usuario o email ya están registrados."
        )
    # FastAPI/Pydantic convierte automáticamente el modelo de SQLAlchemy a UsuarioSchema
    return db_usuario

# Endpoint para iniciar sesión y obtener un token JWT
@router.post("/token", response_model=Token)
async def login_for_access_token(
    form_data: OAuth2PasswordRequestForm = Depends(), # FastAPI espera form-data para este endpoint
    db: Session = Depends(get_db)
):
    """
    **Obtiene un token de acceso JWT para la autenticación.**
    
    Requiere `username` y `password` en el cuerpo de la solicitud (form-data).
    """
    user_repo = UsuarioRepository(db)
    
    # 1. Autenticar al usuario
    user_in_db = user_repo.get_by_username(form_data.username)
    
    if not user_in_db or not verify_password(form_data.password, user_in_db.usuario_contraseña):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Credenciales incorrectas",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    # 2. Crear el token de acceso
    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(
        subject=user_in_db.usuario_nombre, # 'sub' (subject) es el nombre de usuario
        expires_delta=access_token_expires
    )
    return {"access_token": access_token, "token_type": "bearer"}

# Ejemplo de un endpoint protegido: Obtener información del usuario actual
@router.get("/users/me", response_model=UsuarioSchema)
async def read_users_me(current_user: UsuarioSchema = Depends(get_current_user)):
    """
    **Obtiene la información del usuario actualmente autenticado.**
    
    Requiere un token JWT válido en el encabezado `Authorization: Bearer <token>`.
    """
    return current_user