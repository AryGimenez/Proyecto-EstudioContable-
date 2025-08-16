# schemas/cliente.py
from pydantic import BaseModel, EmailStr
from typing import Optional

class ClienteBase(BaseModel):
    nombre_completo: str
    email: Optional[EmailStr] = None
    contacto: Optional[str] = None
    whatsapp: Optional[str] = None
    saldo: Optional[float] = None
    direccion: Optional[str] = None

class ClienteCreate(ClienteBase):
    pass

class ClienteUpdate(ClienteBase):
    pass

class Cliente(ClienteBase):
    id: int

    class Config:
        orm_mode = True