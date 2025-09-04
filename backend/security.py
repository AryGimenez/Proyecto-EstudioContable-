# backend/security.py

from passlib.context import CryptContext #Importacion para la encriptadora de contraseña
from datetime import datetime, timedelta
from typing import Union, Any, Optional
from jose import jwt, JWTError

# Aquí la importación, con la variable exacta.
from backend.config import SECRET_KEY, ALGORITHM, ACCESS_TOKEN_EXPIRE_MINUTES

def create_access_token(
    subject: Union[str, Any], expires_delta: timedelta = None
) -> str:
    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)  # Default expiration time
    to_encode = {"exp": expire, "sub": str(subject)}
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt




pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

def get_password_hash(password: str) -> str:
    """Cifra una contraseña de texto plano."""
    return pwd_context.hash(password)

def verify_password(plain_password: str, hashed_password: str) -> bool:
    """Verifica si una contraseña de texto plano coincide con una encriptada."""
    return pwd_context.verify(plain_password, hashed_password)

# ... (Otras funciones relacionadas con la seguridad como la creación de tokens JWT)