from sqlalchemy import Column, Integer, String, Float, ForeignKey, Enum as SQLAlchemyEnum
from sqlalchemy.orm import relationship, Mapped, mapped_column
from typing import List
import enum

from ..database import Base # Importa Base desde el nivel superior (backend)
from .nombre_impuesto import NombreImpuesto # Importa el modelo NombreImpuesto
from .cliente import Cliente # Importa el modelo Cliente
from .pago import Pago



# Definimos una class Enum para la columna 'Imp_Frecuencia'
# Debes ajustar los valores según los tipos de frecuencia que manejes (ej: mensual, bimestral, anual)
class FrecuenciaImpuesto(enum.Enum):
    mensual = "mensual"
    bimestral = "bimestral"
    trimestral = "trimestral"
    anual = "anual"


class Impuesto(Base):
    __tablename__ = "Impuesto" # Nombre exacto de la tabla en tu DB

    Imp_ID: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    Imp_Monto: Mapped[float] = mapped_column(Float)
    Imp_Moneda: Mapped[str] = mapped_column(String(4))
    Imp_Frecuencia: Mapped[FrecuenciaImpuesto] = mapped_column(SQLAlchemyEnum(FrecuenciaImpuesto))
    Imp_Dias: Mapped[str] = mapped_column(String(45))
    Imp_Vencimiento: Mapped[str] = mapped_column(String(45))
    Imp_Honorario: Mapped[float] = mapped_column(Float, default=0.0)

    # Clave foránea para la relación con el cliente
    Cli_ID: Mapped[int] = mapped_column(Integer, ForeignKey("Cliente.Cli_ID"))
    cliente: Mapped["Cliente"] = relationship("Cliente", back_populates="impuestos")

    # Clave foránea para la relación con NombreImpuesto
    NomIm_ID: Mapped[int] = mapped_column(Integer, ForeignKey("NombreImpuesto.NomIm_ID"))
    nombre_impuesto: Mapped["NombreImpuesto"] = relationship(
        "NombreImpuesto", back_populates="impuestos_registrados"
    )
     # --- ¡CORRECCIÓN AQUÍ! ---
    notificaciones: Mapped[List["Notificacion"]] = relationship("Notificacion", back_populates="impuesto", cascade="all, delete-orphan")
    # -------------------------
    pagos: Mapped[List["Pago"]] = relationship(back_populates="impuesto")
    # Relación con el modelo Cliente
    # back_populates crea una conexión bidireccional, permitiendo acceder a los impuestos desde el cliente y viceversa

  