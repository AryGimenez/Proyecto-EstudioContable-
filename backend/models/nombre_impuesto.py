# backend/models/nombre_impuesto.py

from sqlalchemy import Integer, String # Importa los tipos de columna básicos de SQLAlchemy
from sqlalchemy.orm import relationship, Mapped, mapped_column # Importa sintaxis ORM moderna y relaciones
from typing import List # Tipo para anotaciones de relaciones uno-a-muchos

from ..database import Base # Importa la clase base declarativa de SQLAlchemy

class NombreImpuesto(Base): # Clase que define el modelo ORM para el catálogo de impuestos
    __tablename__ = "NombreImpuesto" # Nombre exacto de la tabla en tu DB

    # --- Columnas del Catálogo ---
    NomIm_ID: Mapped[int] = mapped_column(Integer, primary_key=True, index=True) # ID único del tipo de impuesto, clave primaria
    NomIm_Txt: Mapped[str] = mapped_column(String(45), index=True, unique=True) # Nombre descriptivo del impuesto (ej: "IVA"), debe ser único

    # --- Relación con Impuestos ---
    # Relación uno a muchos: Un NombreImpuesto puede tener muchos Impuestos
    impuestos_registrados: Mapped[List["Impuesto"]] = relationship( # Define la relación con la tabla 'Impuesto'
        "Impuesto", back_populates="nombre_impuesto", cascade="all, delete-orphan" # Relación inversa y borrado en cascada
    )