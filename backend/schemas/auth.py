# schemas/auth.py

# Importaciones para la funcionalidad del archivo

from pydantic import BaseModel, EmailStr, Field # Importaciones para el Pydantic
from typing import Optional # Importaciones para los Optional


class UserLogin(BaseModel): # Esquema para la solicitud de inicio de sesión del usuario.
    """
    Esquema para la solicitud de inicio de sesión del usuario.
    """
    username: str # Puede ser el nombre de usuario o el correo electrónico
    password: str # La contraseña del usuario

class Token(BaseModel):    # Esquema para la respuesta del token de autenticación.
    """
    Esquema para la respuesta del token de autenticación.
    """
    access_token: str # El token JWT
    token_type: str # Tipo de token, típicamente "bearer"
 

class TokenData(BaseModel): # Esquema para los datos del token JWT.
    """
    Esquema para los datos del token JWT.
    """
    username: str | None = None # El 'subject' del token