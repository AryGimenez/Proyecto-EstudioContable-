# backend/models/cliente.py

from sqlalchemy import Column, Integer, String, Float, Date
from sqlalchemy.orm import relationship, Mapped, mapped_column
from typing import List

from backend.database import Base # Asegúrate de importar Base

class Cliente(Base):
    __tablename__ = "Cliente" # El nombre de la tabla debe ser en minúsculas

    Cli_ID: Mapped[int] = mapped_column(Integer, primary_key=True, index=True) 
    Cli_Nom: Mapped[str] = mapped_column(String(45))
    Cli_Dir: Mapped[str] = mapped_column(String(45))
    Cli_Email: Mapped[str] = mapped_column(String(45))
    Cli_Whatsapp: Mapped[str] = mapped_column(String(45))
    Cli_Contacto: Mapped[str] = mapped_column(String(45)) # El nombre de la columna debe ser Cli_DatoContacto
    Cli_FechaNac: Mapped[Date] = mapped_column(Date) # El nombre de la columna debe ser Cli_FechNas
    Cli_Saldo: Mapped[float] = mapped_column(Float)

#   Relationship para que funcione solo con buscar el id del cliente
#   sirve para no tener que buscar de 1 en 1.

    # impuestos: Mapped[List["Impuesto"]] = relationship(back_populates="Cliente")
    # pagos: Mapped[List["Pago"]] = relationship(back_populates="cliente")
    # depositos: Mapped[List["Deposito"]] = relationship(back_populates="cliente")