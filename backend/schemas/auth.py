# schemas/auth.py

from pydantic import BaseModel, EmailStr, Field
from typing import Optional


class UserLogin(BaseModel):
    """
    Esquema para la solicitud de inicio de sesión del usuario.
    """
    username: str # Puede ser el nombre de usuario o el correo electrónico
    password: str # La contraseña del usuario

class Token(BaseModel):
    """
    Esquema para la respuesta del token de autenticación.
    """
    access_token: str # El token JWT
    token_type: str # Tipo de token, típicamente "bearer"

class TokenData(BaseModel):
    """
    Esquema para los datos del token JWT.
    """
    username: str | None = None # El 'subject' del token