# backend/models/deposito.py

from sqlalchemy import Column, Integer, Float, Date, String, ForeignKey
from sqlalchemy.orm import Mapped, mapped_column, relationship
from datetime import date
# Asume que la base viene de tu configuracion de SQLAlchemy
from backend.database import Base


from backend.models.cliente import Cliente

class Deposito(Base):
    __tablename__ = "Depositos"

    Dep_ID: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    Dep_Fecha: Mapped[date] = mapped_column(Date, default=date.today)
    Dep_Monto: Mapped[float] = mapped_column(Float)
    Dep_Moneda: Mapped[str] = mapped_column(String(5), default="USD")
    Dep_Referencia: Mapped[str] = mapped_column(String(100), nullable=True)


    Cli_ID: Mapped[int] = mapped_column(Integer, ForeignKey("Cliente.Cli_ID"))
    cliente: Mapped["Cliente"] = relationship (back_populates="depositos")

    def __repr__(self):
        return f"<Deposito ID: {self.Dep_ID}, Monto: {self.Dep_Monto}, Cliente: {self.Cli_ID}>"