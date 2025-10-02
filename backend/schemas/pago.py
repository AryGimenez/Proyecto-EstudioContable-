#backend/schemas/pago.py

from pydantic import BaseModel, Field
from typing import Optional
from datetime import date

class PagoBase(BaseModel):
    Pago_Monto: float = Field(..., gt=0, description="Monto del pago. Debe ser mayor que cero.")
    Pago_Moneda: str = Field(..., min_length=3, max_length=4, description="Moneda del pago (ej: UYU, ARS). Longitud entre 3 y 4 caracteres.") 
    
    Cli_ID: int = Field(..., gt=0, description="ID del cliente al que se asocia el pago. Debe ser un entero positivo.")
    
    # Imp_ID: int = Field(..., gt=0) <--- CONSIDERACIÓN IMPORTANTE AQUÍ
    # Si un pago puede NO estar asociado a un impuesto específico (ej. un adelanto, un pago global)
    # entonces Imp_ID debería ser Optional[int]. Si SIEMPRE DEBE estar asociado, entonces está bien como lo tenías.
    Imp_ID: Optional[int] = Field(None, gt=0, description="ID del impuesto que este pago cubre, si aplica. Debe ser un entero positivo o nulo.")
    
    Pago_Fecha: Optional[date] = Field(None, description="Fecha en que se realizó el pago. Opcional. Formato YYYY-MM-DD.")


class PagoCreate(PagoBase):
    pass

class PagoUpdate(PagoBase):
    Pago_Monto: Optional[float] = Field(..., gt=0, description="Monto del pago, debe ser mayo que cero.")
    Pago_Moneda: Optional[str] = Field(..., min_length=3, max_length=4, description="Moneda del pago(ej:UYU, ARS, USD). Longitud entre 3 y 4 caracteres.")


class Pago(PagoBase):
    Pago_ID: int = Field(..., gt=0, description="ID único del pago.")
    class Config:
        orm_mode = True
        # Esto permite que Pydantic maneje objetos de tipo datetime.date
        json_encoders = {
            date: lambda v: v.isoformat()
        }
