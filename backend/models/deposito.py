# backend/models/deposito.py

from sqlalchemy import Column, Integer, Float, Date, String, ForeignKey
from sqlalchemy.orm import Mapped, mapped_column, relationship
from typing import Optional
from datetime import date
from typing import List
# Asume que la base viene de tu configuracion de SQLAlchemy

from ..database import Base
from .cliente import Cliente # Importar el modelo Cliente

class Deposito(Base):
    __tablename__ = "Depositos"

    Dep_ID: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    Dep_Fecha: Mapped[date] = mapped_column(Date, default=date.today)
    Dep_Monto: Mapped[float] = mapped_column(Float)
    Dep_Moneda: Mapped[str] = mapped_column(String(5), default="USD")
    Dep_Referencia: Mapped[Optional[str]] = mapped_column(String(255), nullable=True)


    Cli_ID: Mapped[int] = mapped_column(Integer, ForeignKey("Cliente.Cli_ID"))
    cliente: Mapped["Cliente"] = relationship (back_populates="depositos")

     # --- ¡CORRECCIÓN AQUÍ! ---
    notificaciones: Mapped[List["Notificacion"]] = relationship("Notificacion", back_populates="deposito", cascade="all, delete-orphan")
    # -------------------------
    def __repr__(self):
        return f"<Deposito ID: {self.Dep_ID}, Monto: {self.Dep_Monto}, Cliente: {self.Cli_ID}>"