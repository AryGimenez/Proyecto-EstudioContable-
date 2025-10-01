# backend/models/nombre_impuesto.py

from sqlalchemy import Integer, String
from sqlalchemy.orm import relationship, Mapped, mapped_column
from typing import List

from ..database import Base # Importa Base desde el nivel superior (backend)



class NombreImpuesto(Base):
    __tablename__ = "NombreImpuesto" # Nombre exacto de la tabla en tu DB

    NomIm_ID: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    NomIm_Txt: Mapped[str] = mapped_column(String(45), index=True, unique=True)

    # Relación uno a muchos: Un NombreImpuesto puede tener muchos Impuestos
    impuestos_registrados: Mapped[List["Impuesto"]] = relationship(
        "Impuesto", back_populates="nombre_impuesto", cascade="all, delete-orphan"
    )