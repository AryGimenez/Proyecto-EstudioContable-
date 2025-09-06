# backend/models/user.py

from sqlalchemy import Column, Integer, String, Boolean
from backend.database import Base

class Usuario(Base): # Cambie el nombre a Usuario para tenerlo como referecia la tabla de MYSQL
    __tablename__="Usuario" # Nombre de la tabla en la base de datos MySQL

    # Mapeo de columnas de la base de datos a atributos del modelo
    usuario_id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    usuario_nombre = Column(String(45), unique=True, index=True)
    usuario_email = Column(String(45), unique=True, index=True)
    usuario_contraseña = Column(String(255))
    usuario_rol = Column(String(45), default="Usuario")
    # ⚠️ Añade esta línea si tu esquema Pydantic la requiere
    is_active = Column(Boolean, default=True)

    # Métodos opcionales para una mejor presentación

    def __repr__(self):
        return f"<Usuario(id={self.usuario_id}, nombre='{self.usuario_nombre}')>"
