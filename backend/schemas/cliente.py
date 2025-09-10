# backend/schemas/cliente.py

from pydantic import BaseModel, EmailStr
from typing import Optional
from datetime import date

class ClienteBase(BaseModel):
    Cli_Nom: Optional[str] = None
    Cli_Dir: Optional[str] = None
    Cli_Email: Optional[EmailStr] = None
    Cli_Whatsapp: Optional[str] = None
    Cli_Contacto: Optional[str] = None
    Cli_FechaNac: Optional[date] = None
    Cli_Saldo: Optional[float] = 0.0

class ClienteCreate(ClienteBase):
    pass

class ClienteUpdate(ClienteBase):
    Cli_Nom: Optional[str] = None
    Cli_Dir: Optional[str] = None
    Cli_Email: Optional[EmailStr] = None
    Cli_Whatsapp: Optional[str] = None
    Cli_DatoContacto: Optional[str] = None
    Cli_FechNas: Optional[date] = None
    Cli_Saldo: Optional[float] = None
class Cliente(ClienteBase):
    Cli_ID: int

    class Config:
        orm_mode = True