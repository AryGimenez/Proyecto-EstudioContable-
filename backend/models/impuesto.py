from sqlalchemy import Column, Integer, String, Float, ForeignKey, Enum as SQLAlchemyEnum
from sqlalchemy.orm import relationship, Mapped, mapped_column
import enum

from backend.database import Base

# Definimos una clas Enum para la columna 'Imp_Frecuencia'
# Debes ajustar los valores según los tipos de frecuencia que manejes (ej: mensual, bimestral, anual)
class FrecuenciaImpuesto(enum.Enum):
    mensual = "mensual"
    bimestral = "bimestral"
    trimestral = "trimestral"
    anual = "anual"


class Impuesto(Base):
    __tablename__ = "Impuesto"

    Imp_ID: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    Imp_Monto: Mapped[float] = mapped_column(Float)
    Imp_Moneda: Mapped[str] = mapped_column(String(4))  # Ej: USD, EUR, ARS
    # Usamos la clase Enum que definimos para garantizar valores válidos
    Imp_Frecuencia: Mapped[FrecuenciaImpuesto] = mapped_column(SQLAlchemyEnum(FrecuenciaImpuesto))
    Imp_Dias: Mapped[str] = mapped_column(String(45))  # Ej: "Lunes, Miércoles"
    Imp_Vencimiento: Mapped[str] = mapped_column(String(45))  # Ej: "2023-12-31"

    # Clave foránea para la relación con el cliente
    # La clave foránea se define como un campo de tipo Integer que hace referencia a la tabla 'cliente' y su campo 'Cli_ID'
    Cli_ID: Mapped[int] = mapped_column(Integer, ForeignKey("Cliente.Cli_ID"))

    # Relación con el modelo Cliente
    # back_populates crea una conexión bidireccional, permitiendo acceder a los impuestos desde el cliente y viceversa

    # cliente: Mapped["Cliente"] = relationship(back_populates="Impuesto")
