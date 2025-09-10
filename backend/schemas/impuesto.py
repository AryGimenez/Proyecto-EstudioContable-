# backend/schemas/impuesto.py

from pydantic import BaseModel
from typing import Optional
import enum

# Define el mismo Enum que usaste en tu modelo
class FrecuenciaImpuesto(str, enum.Enum):
    mensual = "mensual"
    bimestral = "bimestral"
    trimestral = "trimestral"
    anual = "anual"

# Esquema para los campos básicos
class ImpuestoBase(BaseModel):
    Imp_Monto: float
    Imp_Moneda: str  # Ej: USD, EUR, ARS
    Imp_Frecuencia: FrecuenciaImpuesto
    Imp_Dias: str  # Ej: "Lunes, Miércoles"
    Imp_Vencimiento: str  # Ej: "2023-12-31"
    Cli_ID: int  # ID del cliente asociado

# Esquema para la creación (POST)
class ImpuestoCreate(ImpuestoBase):
    pass

# Esquema para la actualización (PUT)
class ImpuestoUpdate(BaseModel):
    Imp_Monto: Optional[float] = None
    Imp_Moneda: Optional[str] = None  # Ej: USD, EUR, ARS
    Imp_Frecuencia: Optional[FrecuenciaImpuesto] = None
    Imp_Dias: Optional[str] = None  # Ej: "Lunes, Miércoles"
    Imp_Vencimiento: Optional[str] = None  # Ej: "2023-12-31"

# Esquema para la respuesta (GET)
class Impuesto(ImpuestoBase):
    Imp_ID: int

    class Config:
        orm_mode = True

