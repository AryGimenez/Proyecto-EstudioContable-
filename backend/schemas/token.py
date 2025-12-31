# schemas/token.py

# Importaciones para la funcionalidad del archivo

from pydantic import BaseModel # Importaciones para el Pydantic
from typing import Optional # Importaciones para los Optional

class Token(BaseModel): # Esquema para la respuesta del token de autenticación.
    access_token: str # El token JWT
    token_type: str # Tipo de token, típicamente "bearer"

class TokenData(BaseModel): # Esquema para los datos del token JWT.
    username: Optional[str] = None # El 'subject' del token