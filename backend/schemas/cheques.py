# app/cheques/schemas.py

from pydantic import BaseModel, Field, condecimal
from datetime import date
from typing import Optional, List

# --- Esquemas Anidados para Relaciones ---
# Usamos esto para incluir el NomIm_Txt en la respuesta del cheque.
class NombreImpuestoBase(BaseModel):
    """Esquema base para el nombre de impuesto relacionado"""
    NomIm_ID: int
    NomIm_Txt: str
    
    class Config:
        orm_mode = True

# --- Esquemas de Cheque ---

class ChequeBase(BaseModel):
    """Campos comunes para la creación y actualización"""
    Cli_ID: int = Field(..., description="ID del cliente asociado.")
    NomIm_ID: int = Field(..., description="ID del nombre del impuesto (ej: 1 para IVA).")
    Cheq_Numero: str = Field(..., max_length=50, description="Número de referencia del cheque.")
    Cheq_Monto: condecimal(max_digits=10, decimal_places=2) = Field(..., description="Monto del cheque.")
    Cheq_FechaEmision: date = Field(..., description="Fecha de emisión del cheque.")
    Cheq_FechaVencimiento: date = Field(..., description="Fecha de vencimiento del cheque.")
    Cheq_Estado: Optional[str] = Field("Pendiente", max_length=50, description="Estado actual del cheque.")
    
    class Config:
        orm_mode = True # Permite leer desde el modelo ORM

class ChequeCreate(ChequeBase):
    """Esquema usado para crear un nuevo cheque (POST)"""
    pass

class ChequeUpdate(BaseModel):
    """Esquema usado para actualizar un cheque (PUT) - Campos opcionales"""
    Cli_ID: Optional[int] = None
    NomIm_ID: Optional[int] = None
    Cheq_Numero: Optional[str] = Field(None, max_length=50)
    Cheq_Monto: Optional[condecimal(max_digits=10, decimal_places=2)] = None
    Cheq_FechaEmision: Optional[date] = None
    Cheq_FechaVencimiento: Optional[date] = None
    Cheq_Estado: Optional[str] = Field(None, max_length=50)

    class Config:
        orm_mode = True

class Cheque(ChequeBase):
    """Esquema de respuesta (incluye ID y campo computado)"""
    Cheq_ID: int
    
    # Campo computado del modelo (Propiedad @property)
    Cheq_NomImpuesto: Optional[str] 
    
    # Opcional: Incluir la relación completa
    nombre_impuesto: Optional[NombreImpuestoBase] = None