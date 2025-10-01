# backend/security.py

from passlib.context import CryptContext #Importacion para la encriptadora de contraseña
from datetime import datetime, timedelta
from typing import Union, Any, Optional
from jose import jwt, JWTError
from fastapi import HTTPException, status

# Aquí la importación, con la variable exacta.
from backend.config import SECRET_KEY, ALGORITHM, ACCESS_TOKEN_EXPIRE_MINUTES


# Parte encargada de la encripactión de la contraseña del usuario

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

def get_password_hash(password: str) -> str:
    """Cifra una contraseña de texto plano."""
    return pwd_context.hash(password)

def verify_password(plain_password: str, hashed_password: str) -> bool:
    """Verifica si una contraseña de texto plano coincide con una encriptada."""
    return pwd_context.verify(plain_password, hashed_password)


# Creador del token para resetear la contraseña

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

# Parte que verifica que el codigo este correcto para pasar a la siguiente parte de resetar la contraseña
 
def verify_access_token(token: str) -> Optional[str]:
    """Verifica un token JWT y devuelve el 'subject' (nombre de usuario) si es válido."""
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        username: str = payload.get("sub")
        if username is None:
            return None # No hay 'subject' en el token
        return username
    except JWTError:
        return None # El token es inválido



# ... (Otras funciones relacionadas con la seguridad como la creación de tokens JWT)