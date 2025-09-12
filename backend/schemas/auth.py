# schemas/auth.py

from pydantic import BaseModel

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
    username: str | None = None