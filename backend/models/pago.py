# backend/models/pago.py

from sqlalchemy import Column, Integer, Float, Date, ForeignKey, String, Numeric
from sqlalchemy.orm import Mapped, mapped_column, relationship
from datetime import date
from typing import List

# Asume que Base viene de tu configuración de SQLAlchemy
from backend.database import Base




class Pago(Base):

    __tablename__ = "Pagos"

    Pago_ID: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    Pago_Fecha: Mapped[date] = mapped_column(Date, default=date.today)

    Pago_Monto: Mapped[float] = mapped_column(Numeric(precision=10, scale=2))
    Pago_Moneda: Mapped[str] = mapped_column(String(4))
    Pago_Comprobante: Mapped[str] = mapped_column(String(255), nullable=True)

    Cli_ID: Mapped[int] = mapped_column(Integer, ForeignKey("Cliente.Cli_ID"))
    Imp_ID: Mapped[int] = mapped_column(Integer, ForeignKey("Impuesto.Imp_ID"), nullable=True)
    
    # --- Relacion Foraneas ---
    cliente: Mapped["ClienteModel"] = relationship(
        "ClienteModel",
        back_populates="pagos"
    )

    impuesto: Mapped["Impuesto"] = relationship(
        "Impuesto",
        back_populates="pagos"
    )

    # Relación para las notificaciones
    notificaciones: Mapped[List["Notificacion"]] = relationship(
        "Notificacion",
        back_populates="pago",
        cascade="all, delete-orphan"
    )


    def __repr__(self):
        return f"<Pago_ID: {self.Pago_ID}, Monto: {self.Pago_Monto}, Cliente: {self.Cli_ID}, Impuesto: {self.Imp_ID}>"
