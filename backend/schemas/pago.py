#backend/schemas/pago.py

from pydantic import BaseModel, Field
from typing import Optional
from datetime import date

class PagoBase(BaseModel):
    Pago_Monto: float = Field(..., gt=0)
    Cli_ID: int = Field(..., gt=0)
    Imp_ID: int = Field(..., gt=0)
    Pago_Fecha: Optional[date] = Field(None)

class PagoCreate(PagoBase):
    pass

class PagoUpdate(PagoBase):
    Pago_Monto: Optional[float] = Field(None, gt=0)
    Cli_ID: Optional[int] = Field(None, gt=0)
    Imp_ID: Optional[int] = Field(None, gt=0)
    Pago_Fecha: Optional[date] = Field(None)

class Pago(PagoBase):
    Pago_ID: int

    class Config:
        from_attributes=True