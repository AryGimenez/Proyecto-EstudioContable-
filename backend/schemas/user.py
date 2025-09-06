# backend/schemas/user.py

from pydantic import BaseModel, EmailStr
from typing import Optional


# Base para todos los campos del usuario
class UsuarioBase(BaseModel):
    usuario_nombre: str
    usuario_email: EmailStr
    usuario_rol: Optional[str] = "usuario"  # Rol opcional con valor por defecto

# Esquema para la creación de un nuevo usuario (incluye la contraseña sin hash)
class UsuarioCreate(UsuarioBase):
    usuario_contraseña: str  # Contraseña en texto plano para creación
    
# Esquema para actualizar un usuario (todos los campos son opcionales para una alctualización)

class UsuarioUpdate(UsuarioBase):
    usuario_nombre: Optional[str] = None
    usuario_email: Optional[EmailStr] = None
    usuario_contraseña: Optional[str] = None  # Contraseña en texto plano para actualización
    usuario_rol: Optional[str] = None

# Esquema para leer/devolver un usuario (incluye el ID, pero no la contraseña)
 
class Usuario(UsuarioBase):
    usuario_id: int # El ID generado por la base de datos
    is_active: bool = True  # Campo para indicar si el usuario está activo

    class Config:
        orm_mode = True # Esencial para mapear desde el modelo SQLAlchemy