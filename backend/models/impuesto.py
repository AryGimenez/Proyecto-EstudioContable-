from sqlalchemy import Column, Integer, String, Float, ForeignKey, Enum as SQLAlchemyEnum, Numeric # Importa los tipos de columna de SQLAlchemy
from sqlalchemy.orm import relationship, Mapped, mapped_column # Importa sintaxis ORM moderna y relaciones
from typing import List # Tipo para anotaciones de relaciones uno-a-muchos
import enum # Módulo estándar de Python para definir enumeraciones
from decimal import Decimal # Tipo para manejo preciso de valores monetarios

from ..database import Base # Importa la clase base declarativa de SQLAlchemy
from .nombre_impuesto import NombreImpuesto # Importa el modelo NombreImpuesto (para la relación)
from .cliente import Cliente # Importa el modelo Cliente (para la relación)
from .pago import Pago # Importa el modelo Pago (para la relación)


# Definimos una class Enum para la columna 'Imp_Frecuencia'
# Debes ajustar los valores según los tipos de frecuencia que manejes (ej: mensual, bimestral, anual)
class FrecuenciaImpuesto(enum.Enum): # Define una enumeración para los valores permitidos de frecuencia
    mensual = "mensual" # Valor para frecuencia mensual
    bimestral = "bimestral" # Valor para frecuencia bimestral
    trimestral = "trimestral" # Valor para frecuencia trimestral
    anual = "anual" # Valor para frecuencia anual


class Impuesto(Base): # Clase que define el modelo ORM para el registro de impuestos
    __tablename__ = "Impuesto" # Nombre exacto de la tabla en tu DB

    # --- Columnas Primarias y de Valor ---
    Imp_ID: Mapped[int] = mapped_column(Integer, primary_key=True, index=True) # ID único del impuesto, clave primaria
    
    Imp_Monto: Mapped[float] = mapped_column(Numeric(precision=10, scale=2)) # Monto base del impuesto, usa Numeric para precisión de 2 decimales
    Imp_Moneda: Mapped[str] = mapped_column(String(4)) # Código de la moneda (ej: 'UYU', 'USD')
    Imp_Frecuencia: Mapped[FrecuenciaImpuesto] = mapped_column(SQLAlchemyEnum(FrecuenciaImpuesto)) # Frecuencia de pago, utiliza el Enum definido
    Imp_Dias: Mapped[str] = mapped_column(String(45)) # Días específicos de vencimiento (ej: "5, 15, 25")
    Imp_Vencimiento: Mapped[str] = mapped_column(String(45)) # Descripción o valor de vencimiento (ej: "Día 10 del mes")
    Imp_Honorario: Mapped[float] = mapped_column(Numeric(precision=10, scale=2), default=0.0) # Honorario asociado al impuesto, por defecto 0.0

    # --- Relaciones con Cliente ---
    Cli_ID: Mapped[int] = mapped_column(Integer, ForeignKey("Cliente.Cli_ID")) # Clave foránea que enlaza con la tabla Cliente
    cliente: Mapped["Cliente"] = relationship( # Relación muchos-a-uno: muchos impuestos pertenecen a un cliente
        "Cliente",
        back_populates="impuestos" # Define el campo de relación inversa en el modelo Cliente
    )

    # --- Relaciones con NombreImpuesto (Catálogo) ---
    NomIm_ID: Mapped[int] = mapped_column(Integer, ForeignKey("NombreImpuesto.NomIm_ID")) # Clave foránea que enlaza con el catálogo NombreImpuesto
    nombre_impuesto: Mapped["NombreImpuesto"] = relationship( # Relación muchos-a-uno: muchos impuestos usan un tipo de nombre
        "NombreImpuesto",
        back_populates="impuestos_registrados", # Define el campo de relación inversa en el modelo NombreImpuesto
    )
    
    # --- Relaciones con Notificaciones ---
    notificaciones: Mapped[List["Notificacion"]] = relationship( # Relación uno-a-muchos: un impuesto puede generar varias notificaciones
        "Notificacion", back_populates="impuesto", cascade="all, delete-orphan" # Relación inversa y borrado en cascada
    )
    
    # --- Relaciones con Pagos ---
    pagos: Mapped[List["Pago"]] = relationship( # Relación uno-a-muchos: un impuesto puede ser cubierto por varios pagos
        "Pago", back_populates="impuesto", cascade="all, delete-orphan" # Relación inversa y borrado en cascada
    )
    
    # Relación con el modelo Cliente
    # back_populates crea una conexión bidireccional, permitiendo acceder a los impuestos desde el cliente y viceversa (Comentario descriptivo de la lógica ORM)