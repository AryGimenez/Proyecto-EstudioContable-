#backend/schemas/pago.py

# Importaciones para la funcionalidad del esquema de Pago
from pydantic import BaseModel, Field
from typing import Optional
from datetime import date



class PagoBase(BaseModel): # Clase Esquema para la base de pago
    Pago_Monto: float = Field(..., gt=0, description="Monto del pago. Debe ser mayor que cero.") # Linea para el valor del monto del pago que se realizo
    Pago_Moneda: str = Field(..., min_length=3, max_length=4, description="Moneda del pago (ej: UYU, ARS). Longitud entre 3 y 4 caracteres.") # Linea para especificar la Moneda que se realizo el pago
    
    Cli_ID: int = Field(..., gt=0, description="ID del cliente al que se asocia el pago. Debe ser un entero positivo.") # Linea necesaria y obligatoria para clasificar con la ID del cliente que realizo el pago
    
    Imp_ID: Optional[int] = Field(None, gt=0, description="ID del impuesto que este pago cubre, si aplica. Debe ser un entero positivo o nulo.") # Linea Opcional para especificar la ID del Impuesto del pago
    
    Pago_Fecha: Optional[date] = Field(None, description="Fecha en que se realizó el pago. Opcional. Formato YYYY-MM-DD.") # La fecha que se realizo el Pago



class PagoCreate(PagoBase): # Clase para la creación de un pago
    pass # Al usar el "pass" en esta parte toma todo lo que se especificó en el PagoBase(BaseModel).


class PagoUpdate(PagoBase): # Clase para la actualizacion de un pago
    Pago_Monto: Optional[float] = Field(..., gt=0, description="Monto del pago, debe ser mayo que cero.") # Linea Opcional para la actualizacion de un pago, No es requerido el campo de realizar la actualizacion del monto
    Pago_Moneda: Optional[str] = Field(..., min_length=3, max_length=4, description="Moneda del pago(ej:UYU, ARS, USD). Longitud entre 3 y 4 caracteres.") # Linea Opcional para la actualizacion de un pago, No es requerido el campo para realizar la actualizacion de la Moneda del Pago


class Pago(PagoBase):
    Pago_ID: int = Field(..., gt=0, description="ID único del pago.") # Linea de retorno al realizar el Create, Regresa una ID Unica para el pago que se realizo
    class Config: # Class Config para la Clase Pago(PagoBase)
        orm_mode = True
        # Esto permite que Pydantic maneje objetos de tipo datetime.date
        json_encoders = {
            date: lambda v: v.isoformat()
        }
