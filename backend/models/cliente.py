# backend/models/cliente.py

from sqlalchemy import Column, Integer, String, Float, Date
from sqlalchemy.orm import relationship, Mapped, mapped_column
from typing import List
from datetime import date

from backend.database import Base # Asegúrate de importar Base

class Cliente(Base):
    __tablename__ = "Cliente" # El nombre de la tabla debe ser en minúsculas

    Cli_ID: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    Cli_Nom: Mapped[str] = mapped_column(String(255))
    Cli_Dir: Mapped[str] = mapped_column(String(255))
    Cli_Email: Mapped[str] = mapped_column(String(255))
    Cli_Whatsapp: Mapped[str] = mapped_column(String(20))
    Cli_Contacto: Mapped[str] = mapped_column(String(255))
    Cli_FechaNac: Mapped[date] = mapped_column(Date) # <--- ¡CAMBIADO A Date!
    Cli_Saldo: Mapped[float] = mapped_column(Float, default=0.0)

#   Relationship para que funcione solo con buscar el id del cliente
#   sirve para no tener que buscar de 1 en 1.

    impuestos: Mapped[List["Impuesto"]] = relationship("Impuesto", back_populates="cliente", cascade="all, delete-orphan")
    pagos: Mapped[List["Pago"]] = relationship("Pago", back_populates="cliente", cascade="all, delete-orphan")
    depositos: Mapped[List["Deposito"]] = relationship("Deposito", back_populates="cliente", cascade="all, delete-orphan")

    # --- ¡CORRECCIÓN AQUÍ! ---
    notificaciones: Mapped[List["Notificacion"]] = relationship("Notificacion", back_populates="cliente", cascade="all, delete-orphan")
    # -------------------------

    def __repr__(self):
        return f"<Cliente ID: {self.Cli_ID}, Nombre: {self.Cli_Nom}>"