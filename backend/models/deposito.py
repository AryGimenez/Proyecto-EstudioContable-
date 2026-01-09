# backend/models/deposito.py

from sqlalchemy import Column, Integer, Float, Date, String, ForeignKey # Importa los tipos de columna de SQLAlchemy
from sqlalchemy.orm import Mapped, mapped_column, relationship # Importa sintaxis ORM moderna y relaciones
from typing import Optional # Tipo para campos que pueden ser nulos
from datetime import date # Importa el tipo date de Python
from typing import List # Tipo para anotaciones de relaciones uno-a-muchos

from ..database import Base # Importa la clase base declarativa de SQLAlchemy
from .cliente_model import ClienteModel # Importa el modelo Cliente para la relación

class Deposito(Base): # Clase que define el modelo ORM para la tabla de depósitos
    __tablename__ = "Depositos" # Nombre exacto de la tabla en la base de datos

    # --- Columnas del Depósito ---
    Dep_ID: Mapped[int] = mapped_column(Integer, primary_key=True, index=True) # ID único del depósito, clave primaria
    Dep_Fecha: Mapped[date] = mapped_column(Date, default=date.today) # Fecha en que se realizó el depósito, por defecto hoy
    Dep_Monto: Mapped[float] = mapped_column(Float) # Monto del depósito (usa Float, aunque se recomienda Numeric para dinero)
    Dep_Moneda: Mapped[str] = mapped_column(String(5), default="USD") # Tipo de moneda del depósito, por defecto "USD"
    Dep_Referencia: Mapped[Optional[str]] = mapped_column(String(255), nullable=True) # Número o código de referencia de la transacción, puede ser nulo

    # --- Clave Foránea a Cliente y Relación ---
    Cli_ID: Mapped[int] = mapped_column(Integer, ForeignKey("Cliente.Cli_ID")) # Clave foránea que enlaza con la tabla Cliente
    cliente: Mapped["ClienteModel"] = relationship (back_populates="depositos") # Relación muchos-a-uno: muchos depósitos a un cliente
    
    # --- Relación con Notificaciones ---
    notificaciones: Mapped[List["Notificacion"]] = relationship("Notificacion", back_populates="deposito", cascade="all, delete-orphan") # Relación uno-a-muchos, permitiendo borrar notificaciones en cascada
    
    def __repr__(self): # Método para representación legible del objeto
        return f"<Deposito ID: {self.Dep_ID}, Monto: {self.Dep_Monto}, Cliente: {self.Cli_ID}>"