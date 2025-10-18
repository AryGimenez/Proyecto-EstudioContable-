# app/schemas.py (o donde tengas tus esquemas Pydantic)

from pydantic import BaseModel
from typing import Optional

# Esquemas para NombreImpuesto

# Esquema base para los datos de entrada
class NombreImpuestoBase(BaseModel): # <-- Clase Base para el esquema
    NomIm_Txt: str # <-- Linea que define el campo para el nombre del impuesto

# Esquema para crear un NombreImpuesto (igual que el base por ahora)
class NombreImpuestoCreate(NombreImpuestoBase): 
    pass

# Esquema para la respuesta de un NombreImpuesto (incluye el ID generado por la DB)
class NombreImpuesto(NombreImpuestoBase):
    NomIm_ID: int

    class Config: # Clase para la config de la clase "NombreImpuesto(NombreImpuestoBase)"
        from_attributes = True # Permite que Pydantic use los atributos del modelo de SQLAlchemy
        populate_by_name = True  # Esto permite que Pydantic lea directamente de un modelo SQLAlchemy