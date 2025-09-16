# backend/models/user.py

from sqlalchemy import Column, Integer, String, Boolean, DateTime, ForeignKey
from sqlalchemy.orm import relationship, Mapped, mapped_column
from sqlalchemy.sql import func
from datetime import datetime
from typing import List, Optional

from backend.database import Base # Asegúrate de que la ruta sea correcta

class Usuario(Base):
    __tablename__ = "Usuario" # Nombre de la tabla en la base de datos MySQL

    usuario_id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True, autoincrement=True)
    usuario_nombre: Mapped[str] = mapped_column(String(45), unique=True, index=True, nullable=False)
    usuario_email: Mapped[str] = mapped_column(String(45), unique=True, index=True, nullable=False)
    usuario_contraseña: Mapped[str] = mapped_column(String(255), nullable=False)
    usuario_rol: Mapped[str] = mapped_column(String(45), default="usuario", nullable=False)
    is_active: Mapped[bool] = mapped_column(Boolean, default=True, nullable=False)
    created_at: Mapped[datetime] = mapped_column(DateTime, server_default=func.now(), nullable=False)

    # Relación con PasswordResetRequest
    # El 'back_populates' en PasswordResetRequest es 'usuario_asociado'
    password_reset_requests: Mapped[List["PasswordResetRequest"]] = relationship(
        "PasswordResetRequest", 
        back_populates="usuario_asociado", # Asegura que este nombre coincida
        cascade="all, delete-orphan"
    )

    def __repr__(self):
        return f"<Usuario(id={self.usuario_id}, nombre='{self.usuario_nombre}')>"

# --- Nuevo modelo para las solicitudes de reseteo de contraseña ---
class PasswordResetRequest(Base):
    __tablename__ = "PasswordResetRequest" # Nombre de la tabla en la base de datos MySQL

    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True, autoincrement=True)
    # Referencia la columna 'usuario_email' de tu tabla 'Usuario'
    email: Mapped[str] = mapped_column(String(45), ForeignKey("Usuario.usuario_email"), nullable=False)
    token: Mapped[str] = mapped_column(String(255), unique=True, index=True, nullable=False)
    created_at: Mapped[datetime] = mapped_column(DateTime, server_default=func.now())
    expires_at: Mapped[datetime] = mapped_column(DateTime, nullable=False) # Para la expiración del token

    # Relación con Usuario. El 'back_populates' en Usuario es 'password_reset_requests'
    usuario_asociado: Mapped["Usuario"] = relationship(
        "Usuario", 
        back_populates="password_reset_requests",
        foreign_keys=[email], # Especificamos la clave externa
        primaryjoin="PasswordResetRequest.email == Usuario.usuario_email" # Para evitar ambigüedades
    )

    def __repr__(self):
        return f"<PasswordResetRequest(id={self.id}, email='{self.email}', token='{self.token[:10]}...')>"