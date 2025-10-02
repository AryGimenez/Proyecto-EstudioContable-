# backend/schemas/cliente.py

from pydantic import BaseModel, EmailStr, Field
from typing import Optional
from datetime import date

class ClienteBase(BaseModel):
    Cli_Nom: str = Field(..., min_length=1, description="Nombre del cliente.")
    Cli_Dir: str = Field(..., min_length=1, description="Dirección del cliente.")
    Cli_Email: str = Field(..., min_length=1, description="Correo electrónico del cliente.")
    Cli_Whatsapp: str = Field(..., min_length=1, description="Número de WhatsApp del cliente.")
    Cli_Contacto: str = Field(..., min_length=1, description="Nombre de contacto.")
    Cli_FechaNac: date = Field(..., description="Fecha de nacimiento del cliente (YYYY-MM-DD).")
class ClienteCreate(ClienteBase):
    pass

class ClienteUpdate(ClienteBase):
    Cli_Nom: Optional[str] = Field(None, min_length=1)
    Cli_Dir: Optional[str] = Field(None, min_length=1)
    Cli_Email: Optional[str] = Field(None, min_length=1)
    Cli_Whatsapp: Optional[str] = Field(None, min_length=1)
    Cli_Contacto: Optional[str] = Field(None, min_length=1)
    Cli_FechaNac: Optional[date] = Field(None, min_length=1)

    
class Cliente(ClienteBase):
    Cli_ID: int = Field(..., gt=0, description="ID único del cliente.")
    Cli_Saldo: float = Field(..., description="Saldo actual del cliente(calculado)")
    class Config:
        orm_mode = True
        # Esto le dice a Pydantic cómo serializar objetos date a JSON (string ISO 8601)
        json_encoders = {
            date: lambda v: v.isoformat()
        }