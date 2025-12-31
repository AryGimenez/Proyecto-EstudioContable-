# backend/schemas/impuesto.py

# Importaciones para la funcionalidad del archivo

from pydantic import BaseModel, Field, field_validator # Importaciones Pydantic
from typing import Optional # Importaciones para el typing del ImpuestoUpdate
import enum # Importacion para el Enum
from datetime import date # Importacion para el Imp_Vencimiento

from .nombre_impuesto import NombreImpuesto # Importa el esquema de NombreImpuesto
# from .cliente import ClienteOut # Importa el esquema de Cliente si necesitas anidarlo
from ..models.impuesto import FrecuenciaImpuesto # Importa el Enum de SQLAlchemy

# Define el mismo Enum que usaste en tu modelo
class FrecuenciaImpuesto(str, enum.Enum): # Define el Enum para la frecuencia del impuesto
    mensual = "mensual" # Define el enum mensual
    bimestral = "bimestral" # Define el enum bimestral
    trimestral = "trimestral" # Define el enum trimestral
    anual = "anual" # Define el enum anual

# Esquema para los campos básicos
class ImpuestoBase(BaseModel): # Clase BaseModel para las clase Create y Update
    Imp_Monto: float = Field(..., gt=0) # Linea encargada de listar los impuestos por monto. Sirve para ingresar el monto del impuesto
    Imp_Moneda: str = Field(..., min_length=3, max_length=4) # Linea encargada de listar los impuestos por moneda. Sirve para ingresar la moneda del impuesto
    Imp_Frecuencia: FrecuenciaImpuesto # Linea encargada de listar los impuestos por frecuencia. Sirve para ingresar la frecuencia del impuesto
    Imp_Dias: str # Linea encargada de listar los impuestos por dias. Sirve para ingresar los dias que el impuesto sera pagado
    Imp_Vencimiento: str # Linea encargada de listar los impuestos por vencimiento. Sirve para ingresar la fecha de vencimiento del impuesto
    NomIm_ID: int = Field(..., gt=0) # ForeignKey al NombreImpuesto, une el impuesto con su nombre a partir de su ID
    Cli_ID: int = Field(..., gt=0) # ForeignKey al Cliente, une el impuesto con su cliente a partir de su ID

class Config: # Configuracion para que tome los atributos del modelo de SQLAlchemy
    from_attributes = True # Permite que Pydantic use los atributos del modelo de SQLAlchemy
    populate_by_name = True # Esto permite que Pydantic lea directamente de un modelo SQLAlchemy

# Esquema para la creación (POST)
class ImpuestoCreate(ImpuestoBase):  # Esquema para la creación de un impuesto
    pass # Al usar el "pass" en esta parte toma todo lo que se especifico en el ImpuestoBase(BaseModel).

# Esquema para la actualización (PUT)
class ImpuestoUpdate(BaseModel): # Esquema para la actualización de un impuesto
    Imp_Monto: Optional[float] = Field(None, gt=0) # Linea encargada de actualizar el monto del impuesto, Opcional porque no requiere del campo para actualizar.
    Imp_Moneda: Optional[str] = Field(None, min_length=3, max_length=4) # Linea encargada de actualizar la moneda del impuesto, Opcional porque no requiere del campo para actualizar.
    Imp_Frecuencia: Optional[FrecuenciaImpuesto] = None # Linea encargada de actualizar la frecuencia del impuesto, Opcional porque no requiere del campo para actualizar.
    Imp_Dias: Optional[str] = None # Linea encargada de actualizar los dias del impuesto, Opcional porque no requiere del campo para actualizar.
    Imp_Vencimiento: Optional[str] = None  # Linea encargada de actualizar la fecha de vencimiento del impuesto, Opcional porque no requiere del campo para actualizar.
    NomIm_ID: Optional[int] = Field(None, gt=0) # ForeignKey al NombreImpuesto, une el impuesto con su nombre a partir de su ID, Opcional porque no requiere del campo para actualizar.
    Cli_ID: Optional[int] = Field(None, gt=0) # ForeignKey al Cliente, une el impuesto con su cliente a partir de su ID, Opcional porque no requiere del campo para actualizar.

# Esquema para la respuesta (GET)
class Impuesto(ImpuestoBase): # Esquema para la respuesta de un impuesto
    Imp_ID: int # Retorna una ID única para el impuesto que fue agregado con la base del ImpuestoBase
    Imp_Honorario: float = Field(..., description="Monto de honorario calculado (%20 del Imp_Monto).")  # Retorna el monto del honorario calculado (20% del Imp_Monto)
    nombre_impuesto: NombreImpuesto # Anida el esquema de NombreImpuesto para incluir detalles del nombre del impuesto, a su vez sirve para poder unir el NomIm_Txt con el frontend
    
    
    class Config: # Clase para la config de la clase "Impuesto(ImpuestoBase)"
        from_attributes = True # Permite que Pydantic use los atributos del modelo de SQLAlchemy
        populate_by_name = True  # Esto permite que Pydantic lea directamente de un modelo SQLAlchemy
