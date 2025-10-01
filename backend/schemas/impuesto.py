# backend/schemas/impuesto.py

from pydantic import BaseModel, Field
from typing import Optional
import enum

from .nombre_impuesto import NombreImpuesto # Importa el esquema de NombreImpuesto
# from .cliente import ClienteOut # Importa el esquema de Cliente si necesitas anidarlo
from ..models.impuesto import FrecuenciaImpuesto # Importa el Enum de SQLAlchemy

# Define el mismo Enum que usaste en tu modelo
class FrecuenciaImpuesto(str, enum.Enum):
    mensual = "mensual"
    bimestral = "bimestral"
    trimestral = "trimestral"
    anual = "anual"

# Esquema para los campos básicos
class ImpuestoBase(BaseModel):
    Imp_Monto: float = Field(..., gt=0)
    Imp_Moneda: str = Field(..., min_length=3, max_length=4)
    Imp_Frecuencia: FrecuenciaImpuesto
    Imp_Dias: str
    Imp_Vencimiento: str # Usa date si lo tienes en el modelo
    NomIm_ID: int = Field(..., gt=0)
    Cli_ID: int = Field(..., gt=0)

# Esquema para la creación (POST)
class ImpuestoCreate(ImpuestoBase):    
    pass

# Esquema para la actualización (PUT)
class ImpuestoUpdate(BaseModel):
    Imp_Monto: Optional[float] = Field(None, gt=0)
    Imp_Moneda: Optional[str] = Field(None, min_length=3, max_length=4)
    Imp_Frecuencia: Optional[FrecuenciaImpuesto] = None
    Imp_Dias: Optional[str] = None
    Imp_Vencimiento: Optional[str] = None
    NomIm_ID: Optional[int] = Field(None, gt=0)
    Cli_ID: Optional[int] = Field(None, gt=0)
# Esquema para la respuesta (GET)
class Impuesto(ImpuestoBase):
    Imp_ID: int
    Imp_Honorario: float = Field(..., description="Monto de honorario calculado (20% del Imp_Monto).") # <--- ¡NUEVO CAMPO!
    # ... (Si tienes schemas anidados para nombre_impuesto_obj)
    
    class Config:
        orm_mode = True
