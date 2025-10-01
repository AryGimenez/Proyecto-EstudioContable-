# schemas/auth.py

from pydantic import BaseModel, EmailStr, Field
from typing import Optional


class UserLogin(BaseModel):
    """
    Esquema para la solicitud de inicio de sesión del usuario.
    """
    username: str
    password: str

class Token(BaseModel):
    """
    Esquema para la respuesta del token de autenticación.
    """
    access_token: str
    token_type: str

class TokenData(BaseModel):
    """
    Esquema para los datos del token JWT.
    """
    username: str | None = None # El 'subjectt' del token