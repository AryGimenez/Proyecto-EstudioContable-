# Importaciones necesarias para tu API
# APIRouter para crear y organizar tus rutas.
# HTTPException para manejar errores HTTP (como credenciales incorrectas).
# Depends para la inyección de dependencias, lo que permite a FastAPI manejar objetos.

from sqlalchemy.orm import Session
from backend import database, models, schemas

# --ChatGPT Esto no tendira que ir o no entiendo donde va 
from backend.schemas import auth 
# Importa tus utilidades de seguridad (donde está create_access_token y verify_password)
from ..security import create_access_token, verify_password, ACCESS_TOKEN_EXPIRE_MINUTES

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

# ChatGPT esto capas lo saco -- 
# Esta importación es para simular un usuario en memoria.
# No la tienes en tu código original, pero es clave para tu objetivo.
from pydantic import BaseModel

# Importa tus esquemas de usuario y autenticación
from ..schemas import user as user_schema
from ..schemas import auth as auth_schemas # Este es tu schemas/auth.py



from backend.utils import generate_verification_code, send_verification_email  # Import utils
from sqlalchemy.sql import func




# Rutas de autenticación
router = APIRouter(prefix="/auth", tags=["authentication"])

# @router.post("/login") # Define un endpoint HTTP POST en la ruta /auth/login
# async def login(form_data: OAuth2PasswordRequestForm = Depends(), db: Session = Depends(database.get_db)):
#     user = db.query(models.User).filter(models.User.username == form_data.username).first()
#     if not user or not verify_password(form_data.password, user.hashed_password):
#         raise HTTPException(status_code=400, detail="Credenciales incorrectas")
#     access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
#     access_token = create_access_token(data={"sub": user.username}, expires_delta=access_token_expires)
#     return {"access_token": access_token, "token_type": "bearer"}


# --- Base de datos de usuarios simulada en memoria ---
# Usamos un diccionario para simular los datos del usuario.
fake_users_db = {
    "testuser": {
        "username": "testuser",
        "email": "test@example.com",
        "hashed_password": "password123"
    },
    "admin": {
        "username": "admin",
        "email": "admin@example.com",
        "hashed_password": "adminpass"
    }
}


# Función para verificar contraseñas sin un hash, solo para esta prueba
def verify_password_in_memory(plain_password: str, stored_hashed_password: str) -> bool:
    return plain_password == stored_hashed_password


@router.post("/token") #Usamos /token para el endpoint de login, como es la convecion OAuth2
async def login_for_access_token(form_data: OAuth2PasswordRequestForm = Depends()):
    # 1. Busca si el usuario exite en nuestra "base de datos" temporal
    user_data = fake_users_db.get(form_data.username)

    if not user_data:
        # Si el usuario no existe, levanta una excepción de HTTP
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Credenciales inválidas",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    # 2. Verifica la contraseña usando nuestra función de prueba
    if not verify_password_in_memory(form_data.password, user_data["hashed_password"]):
        # Si la contraseña no coincide, levanta una excepción HTTP
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Credenciales inválidas",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    # 3. Si la auutenticación es existosa, crea un token de acceso.
    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(
        data={"sub": user_data["username"]},
        expires_delta=access_token_expires
    )

    # 4. Devuelve el token de acceso al cliente.
    return {"access_token": access_token, "token_type": "bearer"}



@router.post("/password-reset/request")
async def request_password_reset(request_data: schemas.auth.PasswordResetRequestSchema, db: Session = Depends(database.get_db)):
    user = db.query(models.User).filter(models.User.email == request_data.email).first()
    if user:
        verification_code = generate_verification_code()
        # Store the verification code in the database (you might want a separate table for this)
        reset_request = models.PasswordResetRequest(
            email=user.email,
            token=verification_code,  # Using 'token' field for verification code for simplicity
            user_id=user.id
        )
        db.add(reset_request)
        db.commit()
        # Send the verification code to the user's email
        send_verification_email(user.email, verification_code)
        return {"message": "Se ha enviado un código de verificación a tu correo electrónico."}
    raise HTTPException(status_code=404, detail="No se encontró usuario con ese correo electrónico.")

@router.post("/password-reset/verify-code")
async def verify_code(verification_data: schemas.auth.VerifyCodeSchema, db: Session = Depends(database.get_db)):
    reset_request = db.query(models.PasswordResetRequest).filter(
        models.PasswordResetRequest.token == verification_data.verification_code,
        models.PasswordResetRequest.email == verification_data.email,
        models.PasswordResetRequest.created_at > func.now() - timedelta(minutes=15)  # Optional: Code expiration
    ).first()
    if reset_request:
        return {"message": "Código de verificación válido. Puedes restablecer tu contraseña."}
    raise HTTPException(status_code=400, detail="Código de verificación inválido o expirado.")

@router.post("/password-reset/confirm")
async def confirm_password_reset(reset_data: schemas.auth.PasswordResetConfirm, db: Session = Depends(database.get_db)):
    reset_request = db.query(models.PasswordResetRequest).filter(
        models.PasswordResetRequest.token == reset_data.verification_code,
        models.PasswordResetRequest.email == reset_data.email
    ).first()
    if reset_request:
        user = db.query(models.User).filter(models.User.email == reset_request.email).first()
        if user:
            hashed_password = get_password_hash(reset_data.new_password)
            user.hashed_password = hashed_password
            db.delete(reset_request)  # Remove the used reset request
            db.commit()
            return {"message": "Contraseña restablecida exitosamente."}
        raise HTTPException(status_code=404, detail="No se encontró usuario asociado a esta solicitud.")
    raise HTTPException(status_code=400, detail="Solicitud de restablecimiento de contraseña inválida.")