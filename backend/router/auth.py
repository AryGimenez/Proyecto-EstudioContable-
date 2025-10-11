# backend/router/auth.py

# Importaciones de FastAPI y SQLAlchemy

from fastapi import APIRouter, Depends, HTTPException, status # Importaciones necesarias para funciones de FastAPI
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm # Importaciones para seguridad y autenticación
from sqlalchemy.orm import Session # Importación para manejar sesiones de base de datos
from datetime import timedelta # Para manejar expiración de tokens
from typing import Optional # Para tipos opcionales

# Importaciones de tu proyecto
from backend.dependencies import get_db # Dependencia para obtener la sesión de la base de datos
from backend.repositorios.usuario_repository import UsuarioRepository # Repositorio de usuarios
from backend.schemas.user import UsuarioCreate, Usuario as UsuarioSchema # Esquemas de usuario
from backend.schemas.auth import Token # Esquema de token
from backend.security import ( # Exporta las funciones de seguridad, creadas en security.py
    create_access_token,
    verify_access_token,
    verify_password
)
from backend.config import ACCESS_TOKEN_EXPIRE_MINUTES # Configuración del tiempo de expiración del token

# Define el esquema de autenticación para obtener el token
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/auth/token") # La URL donde los usuarios obtienen el token

router = APIRouter(prefix="/auth", tags=["Autenticación"]) # Prefijo y etiquetas para el router

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
@router.post("/register", response_model=UsuarioSchema, status_code=status.HTTP_201_CREATED) # Responde con el esquema de usuario y código 201
def register_user( 
    usuario_data: UsuarioCreate, # Datos del nuevo usuario (nombre, email, contraseña)
    db: Session = Depends(get_db) # Sesión de base de datos inyectada (dependencia)
):
    """
    Registra un nuevo usuario en el sistema.
    """
    repo = UsuarioRepository(db) # Crea una instancia del repositorio de usuarios
    db_usuario = repo.create(usuario_data) # Intenta crear el usuario en la base de datos
    
    if db_usuario is None: # Si el usuario ya existe, lanza un error 409
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="El nombre de usuario o email ya están registrados."
        )
    # FastAPI/Pydantic convierte automáticamente el modelo de SQLAlchemy a UsuarioSchema
    return db_usuario # Retorna el usuario creado, si salta el orden correcto con el post y codigo 201

# Endpoint para iniciar sesión y obtener un token JWT
@router.post("/token", response_model=Token) # Responde con el esquema de token
async def login_for_access_token(
    form_data: OAuth2PasswordRequestForm = Depends(), # Datos del formulario (username y password)
    db: Session = Depends(get_db) # Sesión de base de datos inyectada (dependencia)
):
    """
    **Obtiene un token de acceso JWT para la autenticación.**
    
    Requiere `username` y `password` en el cuerpo de la solicitud (form-data).
    """
    user_repo = UsuarioRepository(db) # Crea una instancia del repositorio de usuarios
    
    # 1. Autenticar al usuario
    user_in_db = user_repo.get_by_username(form_data.username) # Busca el usuario por nombre de usuario
    
    if not user_in_db or not verify_password(form_data.password, user_in_db.usuario_contraseña): # Verifica la contraseña
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED, # Si falla la autenticación, lanza un error 401
            detail="Credenciales incorrectas",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    # 2. Crear el token de acceso
    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES) # Define el tiempo de expiración del token
    access_token = create_access_token(
        subject=user_in_db.usuario_nombre, # 'sub' (subject) es el nombre de usuario, manera de identificar al usuario
        expires_delta=access_token_expires # Tiempo de expiración
    )
    return {"access_token": access_token, "token_type": "bearer"} # Retorna el token y el tipo

# Ejemplo de un endpoint protegido: Obtener información del usuario actual
@router.get("/users/me", response_model=UsuarioSchema) # Responde con el esquema de usuario
async def read_users_me(current_user: UsuarioSchema = Depends(get_current_user)): # Dependencia para obtener el usuario autenticado
    """
    **Obtiene la información del usuario actualmente autenticado.**
    
    Requiere un token JWT válido en el encabezado `Authorization: Bearer <token>`.
    """
    return current_user # Retorna el usuario autenticado