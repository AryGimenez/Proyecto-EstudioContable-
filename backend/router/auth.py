# Importaciones necesarias para tu API
# APIRouter para crear y organizar tus rutas.
# HTTPException para manejar errores HTTP (como credenciales incorrectas).
# Depends para la inyección de dependencias, lo que permite a FastAPI manejar objetos.

import uuid
from sqlalchemy.orm import Session
from backend import database, models, schemas

# --ChatGPT Esto no tendira que ir o no entiendo donde va 
from backend.schemas import auth 
# Importa tus utilidades de seguridad (donde está create_access_token y verify_password)
from ..security import create_access_token, ACCESS_TOKEN_EXPIRE_MINUTES

from backend.config import ACCESS_TOKEN_EXPIRE_MINUTES

# Importaciones para manejar tokens de acceso (JWT)
from datetime import timedelta

# Esta es la parte que causa la confusión.
# OAuth2PasswordRequestForm es una clase especial de FastAPI para manejar
# los datos de un formulario de login (usuario y contraseña).
# Cuando el cliente (tu app de Flutter) envía un formulario, FastAPI lo parsea automáticamente
# en un objeto `form_data` que contiene `username` y `password`.
from fastapi.security import OAuth2PasswordRequestForm
from fastapi import APIRouter, Depends, HTTPException, status
from typing import Optional

# ChatGPT esto capas lo saco -- 
# Esta importación es para simular un usuario en memoria.
# No la tienes en tu código original, pero es clave para tu objetivo.
from pydantic import BaseModel

# Importa tus esquemas de usuario y autenticación
from ..schemas import user as user_schema
from ..schemas import auth as auth_schemas # Este es tu schemas/auth.py
from ..schemas import token
from uuid import UUID
# Asegura importar esquema para la solicitud
from ..schemas.auth import PasswordResetRequestSchema, PasswordResetConfirm, PasswordResetVerifySchema
from ..security import get_password_hash, verify_password


# Importaciones para manejar la verificación de correo electrónico
from backend.utils import generate_verification_code, send_verification_email  # Import utils
from sqlalchemy.sql import func


# Rutas de autenticación
router = APIRouter(prefix="/auth", tags=["authentication"])

# --- Base de datos de usuarios simulada en memoria ---
# Usamos un diccionario para simular los datos del usuario.
fake_users_db = {
    "lorena": {
        "id": 2,
        "username": "lorena",
        "email": "lorena.g@estudio.com",
        "password": get_password_hash("pass123"),
        "is_active": True,
        "verification_code": None # Campo para guardar el código de verificación
    },
    "admin": {
        "id": 1,
        "username": "admin",
        "email": "admin@estudio.com",
        "password": get_password_hash("adminpass"),
        "is_active": True,
        "verification_code": None # Campo para guardar el código de verificación
    }
}

def get_user(db, username: str):
    """"Obtiene un usuario de la base de datos falsa por nombre de usuario."""
    if username in fake_users_db:
        user_dict = fake_users_db[username]
        return user_schema.UserInDB(**user_dict)
    return None

def authenticate_user(username: str, password: str):
    """Verifica si las credenciales de un usuario son correctas."""
    user = get_user(username)
    if not user:
        return False
    if not verify_password(password, user["hashed_password"]):
        return False
    return user

@router.post("/token", response_model=token.Token)
async def login_for_access_token(form_data: OAuth2PasswordRequestForm = Depends()):
    """
    Ruta para iniciar sesión y obtener un token de acceso
    """
    user_data = authenticate_user(form_data.username, form_data.password)

    if not user_data:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Credenciales incorrectas",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    return {"accest_token": "token-falso-de-prueba", "token_type": "bearer"}



# Ruta para resetear contraseña

@router.post("/password-reset/request")
async def request_password_reset(request_data: PasswordResetRequestSchema):
     # Busca el usuario por correo electrónico
     user_found = False
     for username, user_data in fake_users_db.items():
          if user_data["email"] == request_data.email:
            # Genera un código de verificación aleatorio (UUID para la prueba)
            verification_code = str(uuid.uuid4())
            user_data["verification_code"] = verification_code
            user_found = True
            print(f"Código de verificación para {user_data['email']}: {verification_code}")
            break

     if not user_found:
         raise HTTPException(
             status_code=404,
             detail="Usuario no encontrado"
         )
     return {"message": "Código de verificación enviado al correo electrónico (simulado)"}

@router.post("/password-reset/verify-code")
async def verify_password_reset_code(verify_data: PasswordResetVerifySchema):
    # Busca el usuario por el código de verificación
    user_data = None
    for username, data in fake_users_db.items():
        if data["email"] == verify_data.email:
            user_data = data
            print(f"Código de verificación para {data['email']} es válido.")
            break
    if not user_data:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Usuario no encontrado"
        )

    if not user_data["verification_code"] != verify_data.verification_code:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Código de verificación no válido"
        )

    return {"message": "Código de verificado con éxito"}

@router.post("/password-reset/confirm")
async def confirm_password_reset(confirm_data: PasswordResetConfirm):
    if confirm_data.new_password != confirm_data.confirm_new_password:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Las contraseñas no coinciden"
        )

    user_data = None
    for username, data in fake_users_db.items():
        if data["email"] == confirm_data.email:
            user_data = data
            break

    if not user_data:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Usuario no encontrado"
        )
    
    if user_data["verification_code"] != confirm_data.verification_code:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Código de verificación inválido"
        )
    
    # Hash de la nueva contraseña y actualización del diccionario
    user_data["hashed_password"] = get_password_hash(confirm_data.new_password)
    user_data["verification_code"] = None # Invalida el código de verificación
    
    return {"message": "Contraseña actualizada con éxito."}



