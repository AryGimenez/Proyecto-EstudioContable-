from pydantic import BaseModel, Field
from datetime import date
from typing import Optional

class DepositoBase(BaseModel):
    Dep_Monto: float = Field(..., gt=0, description="Monto del depósito. Debe ser mayor que cero.")
    Dep_Moneda: str = Field("USD", max_length=5, description="Moneda del depósito (ej. USD, EUR, etc).")
    Dep_Referencia: Optional[str] = Field(None, min_length=1, description="Número de referencia o transacción del depósito.")
    Dep_Fecha: Optional[date] = Field(None, description="Fecha del depósito. Por defecto es la fecha actual.")
    Cli_ID: int = Field(..., gt=0, description="ID del cliente asociado al depósito.")

class DepositoCreate(DepositoBase):
    pass

class DepositoUpdate(DepositoBase):
    Dep_Monto: Optional[float] = Field(None, gt=0)
    Dep_Moneda: Optional[str] = Field(None, min_length=3, max_length=5)
    Dep_Referencia: Optional[str] = Field(None, min_length=1)
    Dep_Fecha: Optional[date] = Field(None)
    Cli_ID: Optional[int] = Field(None, gt=0)

class Deposito(DepositoBase):
    Dep_ID: int = Field(..., gt=0, description="ID único del depósito.")

    class Config:
        orm_mode = True
        json_encoders = {
            date: lambda v: v.isoformat()
        }