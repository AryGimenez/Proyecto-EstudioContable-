# backend/schemas/user.py

from pydantic import BaseModel, EmailStr, Field
from typing import Optional
from datetime import datetime

# Base para todos los campos del usuario
class UsuarioBase(BaseModel):
    # Campo para el nombre de usuario. Usamos alias para que la API lo entienda
    # como 'username' pero Pydantic lo mapee a 'usuario_nombre'.
    username: str = Field(..., alias="usuario_nombre", min_length=3)
    
    # Campo para el email. EmailStr ya valida el formato.
    email: EmailStr = Field(..., alias="usuario_email")
    
    # Rol del usuario, con valor por defecto
    usuario_rol: Optional[str] = "usuario"

    is_active: Optional[bool] = True

    class Config:
        from_attributes = True
        populate_by_name = True

# Esquema para la creación de un nuevo usuario
class UsuarioCreate(UsuarioBase):
    # Contraseña en texto plano para la creación, con una validación de longitud
    password: str = Field(..., alias="usuario_contraseña", min_length=6, description="Contraseña en texto plano para creación")
    
    # Configuración para permitir el mapeo con el nombre de los campos del modelo ORM
    class Config(UsuarioBase.Config):   # Permite usar 'username' y 'password' en el request body
        pass

# Esquema para actualizar un usuario
class UsuarioUpdate(BaseModel):
    # Todos los campos son opcionales
    username: Optional[str] = Field(None, alias="usuario_nombre", min_length=3)
    email: Optional[EmailStr] = Field(None, alias="usuario_email")
    password: Optional[str] = Field(None, alias="usuario_contraseña", min_length=6)
    usuario_rol: Optional[str] = None
    is_active: Optional[bool] = None
    created_at: datetime

    class Config:
        from_attributes = True
        populate_by_name = True

# Esquema para leer/devolver un usuario (No incluye la contraseña)
class Usuario(UsuarioBase):
    usuario_id: int


    class Config(UsuarioBase.Config):
        pass