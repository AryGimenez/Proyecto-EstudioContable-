from sqlalchemy import Column, Integer, String, DateTime, ForeignKey # Importa los tipos de columna de SQLAlchemy
from sqlalchemy.orm import relationship # Importa la función 'relationship' para definir enlaces entre modelos
from sqlalchemy.sql import func # Importa las funciones SQL (como func.now())
from backend.database import Base # Importa la clase base declarativa de SQLAlchemy

class PasswordResetRequest(Base): # Clase que define la estructura de la tabla en la base de datos
    __tablename__ = "password_reset_requests" # Nombre exacto de la tabla en la base de datos

    # --- Columnas del Modelo ---
    id = Column(Integer, primary_key=True, index=True) # ID único de la solicitud, clave primaria e indexada
    email = Column(String, index=True) # Correo electrónico del usuario que solicitó el restablecimiento, indexado
    token = Column(String, unique=True, index=True) # Token único y secreto para el restablecimiento, debe ser único e indexado
    created_at = Column(DateTime, server_default=func.now()) # Fecha y hora de creación de la solicitud, usa la hora del servidor por defecto
    
    # --- Clave Foránea y Relación ---
    user_id = Column(Integer, ForeignKey("users.id")) # Clave foránea que enlaza con la tabla de usuarios ('users.id')
    user = relationship("User") # Relación ORM que permite acceder al objeto 'User' a partir de esta solicitud