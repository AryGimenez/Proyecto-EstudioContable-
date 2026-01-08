# backend/schemas/cliente_schem.py

# Importaciones para la funcionalidad del archivo

from pydantic import BaseModel, EmailStr, Field # Importaciones Pydantic
from typing import Optional # Importaciones para el typing del ClienteUpdate
from datetime import date # Importacion para el Cli_FechaNac



class ClienteBase(BaseModel): # Clase BaseModel para las clase Create y Update

    Cli_Nom: str = Field(..., min_length=1, description="Nombre del cliente.") # Linea encargada de listar los clientes por nombre.
    Cli_Dir: str = Field(..., min_length=1, description="Dirección del cliente.") # Linea encargada de listar los clientes por direccion.
    Cli_Email: str = Field(..., min_length=1, description="Correo electrónico del cliente.") # Linea encargada de listar el correo electronico de los clientes.
    Cli_Whatsapp: str = Field(..., min_length=1, description="Número de WhatsApp del cliente.") # Linea encargada de listar los whatsapp de los clientes.
    Cli_DatoContacto: str = Field(..., min_length=1, description="Nombre de contacto.") # Linea encargada de listar contactos externos a parte del whatsapp.
    Cli_FechaNac: date = Field(..., description="Fecha de nacimiento del cliente (YYYY-MM-DD).") # Linea para guardar la fecha de nacimiento del cliente.


class ClienteCreate(ClienteBase): # Clase para la creacion de un cliente
    pass # Al usar el "pass" en esta parte toma todo lo que se especifico en el ClienteBase(BaseModel).



class ClienteUpdate(ClienteBase): # Clase para la actualizacion de un cliente
    Cli_Nom: Optional[str] = Field(None, min_length=1) # Linea encargada de actualizar el nombre del cliente, Opcional porque no requiere del campo para actualizar.
    Cli_Dir: Optional[str] = Field(None, min_length=1) # Linea encargada de actualizar la direccion del cliente, Opcional porque no requiere del campo para actualizar.
    Cli_Email: Optional[str] = Field(None, min_length=1) # Linea encargada de actualizar el correo electronico del cliente, Opcional porque no requiere del campo para actualizar.
    Cli_Whatsapp: Optional[str] = Field(None, min_length=1) # Linea encargada de actualizar el whatsapp del cliente,  Opcional porque no requiere del campo para actualizar.
    Cli_DatoContacto: Optional[str] = Field(None, min_length=1) # Linea encargada de actualizar el contacto externo al whatsapp del cliente,  Opcional porque no requiere del campo para actualizar.
    Cli_FechaNac: Optional[date] = Field(None, min_length=1) # Linea encargada de actualizar la fecha de nacimiento del cliente,  Opcional porque no requiere del campo para actualizar.




class ClienteSchema(ClienteBase): # Clase encarga de lo que retorna al usar lo de el BaseModel
    Cli_ID: int = Field(..., gt=0, description="ID único del cliente.") # Retorna una ID única para el cliente que fue agregado
    Cli_Saldo: float = Field(..., description="Saldo actual del cliente(calculado)") # Retorna un saldo con "default = 0" para le cliente que fue agregado
    class Config: # Clase para la config de la clase "Cliente(ClienteBase)"
        orm_mode = True
        # Esto le dice a Pydantic cómo serializar objetos date a JSON (string ISO 8601)
        json_encoders = {
            date: lambda v: v.isoformat()
        }