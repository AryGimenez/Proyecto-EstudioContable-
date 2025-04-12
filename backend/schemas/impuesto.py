# schemas/impuesto.py
from pydantic import BaseModel
from typing import Optional

class ImpuestoBase(BaseModel):
    tipo: str
    monto: float
    monto_pago: Optional[float] = None
    honorario: Optional[float] = None
    cliente_id: int

class ImpuestoCreate(ImpuestoBase):
    pass

class ImpuestoUpdate(ImpuestoBase):
    pass

class Impuesto(ImpuestoBase):
    id: int

    class Config:
        orm_mode = True