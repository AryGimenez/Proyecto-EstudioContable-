# backend/models/user.py
import enum
from sqlalchemy import Column, Integer, String, Boolean, DateTime, ForeignKey, Enum # Importa los tipos de columna de SQLAlchemy
from sqlalchemy.orm import relationship, Mapped, mapped_column # Importa sintaxis ORM moderna (Mapped) y relaciones
from sqlalchemy.sql import func # Importa las funciones SQL (como func.now())
from datetime import datetime # Importa el tipo datetime de Python
from typing import List, Optional # Tipos para anotaciones y relaciones uno-a-muchos

from backend.database import Base # Importa la clase base declarativa de SQLAlchemy (Base)

class rolEnum(str, enum.Enum):
    admin = "admin"
    user = "user"


class Usuario(Base): # Clase que define el modelo ORM para la tabla de usuarios
    __tablename__ = "Usuario" # Nombre de la tabla en la base de datos MySQL

    # --- Columnas del Usuario ---
    Usu_id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True, autoincrement=True) # ID único, clave primaria y autoincremental
    Usu_nombre: Mapped[str] = mapped_column(String(45), unique=True, index=True, nullable=False) # Nombre de usuario, único, indexado y obligatorio
    Usu_email: Mapped[str] = mapped_column(String(45), unique=True, index=True, nullable=False) # Email, clave de negocio única, indexada y obligatoria
    Usu_password: Mapped[str] = mapped_column(String(255), nullable=False) # Contraseña hasheada (campo largo), obligatoria
    Usu_rol: Mapped[rolEnum] = mapped_column(Enum(rolEnum), nullable=False) # Rol de acceso (ej: 'admin', 'operador'), por defecto "usuario"
  #  <!> Esto croe queno va poruqe no la tengo en la base de datos 
  #  is_active: Mapped[bool] = mapped_column(Boolean, default=True, nullable=False) # Estado de la cuenta, booleano, por defecto True
    

    # # --- Relación con Solicitudes de Reseteo ---
    # password_reset_requests: Mapped[List["PasswordResetRequest"]] = relationship( # Relación uno-a-muchos (un usuario tiene muchas solicitudes)
    #     "PasswordResetRequest", 
    #     back_populates="usuario_asociado", # Define el campo de relación inversa en el otro modelo
    #     cascade="all, delete-orphan" # Asegura que las solicitudes se eliminen si se borra el usuario
    # )

    # def __repr__(self): # Método para representación legible del objeto
    #     return f"<Usuario(id={self.usuario_id}, nombre='{self.usuario_nombre}')>"

# ------------------ls----------------------------------------------------------------------------------------------------------------

# class PasswordResetRequest(Base): # Clase que define el modelo ORM para las solicitudes de reseteo de contraseña
#     __tablename__ = "PasswordResetRequest" # Nombre de la tabla en la base de datos MySQL

#     # --- Columnas del Reseteo ---
#     id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True, autoincrement=True) # ID único de la solicitud
#     # Referencia la columna 'usuario_email' de tu tabla 'Usuario' (NO el ID, lo cual requiere primaryjoin)
#     email: Mapped[str] = mapped_column(String(45), ForeignKey("Usuario.usuario_email"), nullable=False) # Email del usuario, clave foránea al email del Usuario
#     token: Mapped[str] = mapped_column(String(255), unique=True, index=True, nullable=False) # Token secreto único y obligatorio
#     created_at: Mapped[datetime] = mapped_column(DateTime, server_default=func.now()) # Fecha y hora de creación del token
#     expires_at: Mapped[datetime] = mapped_column(DateTime, nullable=False) # Fecha y hora en que el token dejará de ser válido

#     # --- Relación con Usuario ---
#     usuario_asociado: Mapped["Usuario"] = relationship( # Relación muchos-a-uno (muchas solicitudes a un solo usuario)
#         "Usuario", 
#         back_populates="password_reset_requests", # Define el campo de relación inversa en el modelo Usuario
#         foreign_keys=[email], # Indica a SQLAlchemy que use la columna 'email' como la clave externa
#         primaryjoin="PasswordResetRequest.email == Usuario.usuario_email" # Establece la condición de unión (JOIN) usando el email
#     )

#     def __repr__(self): # Método para representación legible del objeto
#         return f"<PasswordResetRequest(id={self.id}, email='{self.email}', token='{self.token[:10]}...')>"