# backend/schemas/deposito.py

# Importaciones para la funcionalidad del archivo

from pydantic import BaseModel, Field # Importaciones para el Pydantic
from datetime import date # Importaciones para el "Dep_Fecha"
from typing import Optional # Importaciones para los Optional


class DepositoBase(BaseModel):
    Dep_Monto: float = Field(..., gt=0, description="Monto del depósito. Debe ser mayor que cero.") # Linea encargada de listar los "Dep_Monto", debe ser mayor a 0
    Dep_Moneda: str = Field("USD", max_length=5, description="Moneda del depósito (ej. USD, EUR, etc).") # Linea encargada para especificar el tipo de Moneda que fue usada en el deposito, Depende mucho de que Pais o que usara la gestion contable
    Dep_Referencia: Optional[str] = Field(None, min_length=1, description="Número de referencia o transacción del depósito.") # Linea Opcional encargada para dar dato como referencia al deposito realizado
    Dep_Fecha: Optional[date] = Field(None, description="Fecha del depósito. Por defecto es la fecha actual.") # Linea para la fecha del deposito
    Cli_ID: int = Field(..., gt=0, description="ID del cliente asociado al depósito.") # Linea necesaria para especificar la ID del cliente que hizo el deposito

class DepositoCreate(DepositoBase): # Clase encargada de la creacion de un deposito usa todo lo del BaseModel
    pass

class DepositoUpdate(DepositoBase): # Clase encargada de la update de un deposito
    Dep_Monto: Optional[float] = Field(None, gt=0) # Linea para actualizar un monto de deposito, Opctional ya que no requiere del campo para actualizar.
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