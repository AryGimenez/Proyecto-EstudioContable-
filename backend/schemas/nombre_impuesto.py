# app/schemas.py (o donde tengas tus esquemas Pydantic)

from pydantic import BaseModel
from typing import Optional

# Esquemas para NombreImpuesto

# Esquema base para los datos de entrada
class NombreImpuestoBase(BaseModel):
    NomIm_Txt: str

# Esquema para crear un NombreImpuesto (igual que el base por ahora)
class NombreImpuestoCreate(NombreImpuestoBase):
    pass

# Esquema para la respuesta de un NombreImpuesto (incluye el ID generado por la DB)
class NombreImpuesto(NombreImpuestoBase):
    NomIm_ID: int

    class Config:
        orm_mode = True # Esto permite que Pydantic lea directamente de un modelo SQLAlchemy