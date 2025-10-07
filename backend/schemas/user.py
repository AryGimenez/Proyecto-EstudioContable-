# backend/schemas/user.py

# Importaciones para la funcionalidad del archivo
from pydantic import BaseModel, EmailStr, Field # Importaciones Pydantic
from typing import Optional # Importaciones para campos opcionales
from datetime import datetime # Importación para manejar fechas y horas

# Base para todos los campos del usuario
class UsuarioBase(BaseModel): # Clase BaseModel para las clases Create y Update
    # Campo para el nombre de usuario. Usamos alias para que la API lo entienda
    # como 'username' pero Pydantic lo mapee a 'usuario_nombre'.
    username: str = Field(..., alias="usuario_nombre", min_length=3) # Línea encargada de definir el nombre de usuario.
    
    # Campo para el email. EmailStr ya valida el formato.
    email: EmailStr = Field(..., alias="usuario_email") # Línea encargada de definir el correo electrónico del usuario.
    
    # Rol del usuario, con valor por defecto
    usuario_rol: Optional[str] = "usuario" # Línea encargada de definir el rol del usuario, por defecto es "usuario".

    is_active: Optional[bool] = True # Línea que indica si el usuario está activo, por defecto es True.

    class Config: # Clase para la configuración de UsuarioBase
        from_attributes = True # Permite la conversión de objetos ORM a este modelo
        populate_by_name = True # Permite usar tanto el nombre del campo como el alias

# Esquema para la creación de un nuevo usuario
class UsuarioCreate(UsuarioBase): # Clase para la creación de un usuario
    # Contraseña en texto plano para la creación, con una validación de longitud
    password: str = Field(..., alias="usuario_contraseña", min_length=6, description="Contraseña en texto plano para creación") # Línea encargada de definir la contraseña del usuario.
    
    # Configuración para permitir el mapeo con el nombre de los campos del modelo ORM
    class Config(UsuarioBase.Config): # Hereda la configuración de UsuarioBase
        pass # Al usar "pass" mantiene la configuración heredada

# Esquema para actualizar un usuario
class UsuarioUpdate(BaseModel): # Clase para la actualización de un usuario
    # Todos los campos son opcionales
    username: Optional[str] = Field(None, alias="usuario_nombre", min_length=3) # Línea encargada de actualizar el nombre de usuario, Opcional porque no requiere del campo para actualizar.
    email: Optional[EmailStr] = Field(None, alias="usuario_email") # Línea encargada de actualizar el correo electrónico, Opcional porque no requiere del campo para actualizar.
    password: Optional[str] = Field(None, alias="usuario_contraseña", min_length=6) # Línea encargada de actualizar la contraseña, Opcional porque no requiere del campo para actualizar.
    usuario_rol: Optional[str] = None # Línea encargada de actualizar el rol del usuario, Opcional porque no requiere del campo para actualizar.
    is_active: Optional[bool] = None # Línea encargada de actualizar el estado activo del usuario, Opcional porque no requiere del campo para actualizar.
    created_at: datetime # Línea que registra la fecha de creación del usuario.

    class Config: # Clase para la configuración de UsuarioUpdate
        from_attributes = True # Permite la conversión de objetos ORM a este modelo
        populate_by_name = True # Permite usar tanto el nombre del campo como el alias

# Esquema para leer/devolver un usuario (No incluye la contraseña)
class Usuario(UsuarioBase): # Clase encargada de lo que retorna al usar lo del BaseModel
    usuario_id: int # Retorna una ID única para el usuario que fue agregado