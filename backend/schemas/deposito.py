# schemas/deposito.py
from pydantic import BaseModel, EmailStr
from typing import Optional
from datetime import date

class DepositoBase(BaseModel):
    monto: float
    fecha: Optional[date] = None
    concepto: Optional[str] = None
    cliente_id: int

class DepositoCreate(DepositoBase):
    pass

class DepositoUpdate(DepositoBase):
    pass

class Deposito(DepositoBase):
    id: int

    class Config:
        orm_mode = True