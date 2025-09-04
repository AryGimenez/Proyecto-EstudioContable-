# schemas/pago.py
from pydantic import BaseModel, EmailStr
from typing import Optional
from datetime import date

class PagoBase(BaseModel):
    monto_pago: float
    fecha_pago: Optional[date] = None
    red_cobranza: Optional[str] = None
    concepto: Optional[str] = None
    cliente_id: int
    impuesto_id: int

class PagoCreate(PagoBase):
    pass

class PagoUpdate(PagoBase):
    pass

class Pago(PagoBase):
    id: int

    class Config:
        orm_mode = True