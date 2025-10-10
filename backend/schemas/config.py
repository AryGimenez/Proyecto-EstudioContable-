# backend/schemas/config.py

#Importacion del Pydantic
from pydantic import BaseModel

class AppConfig(BaseModel): # Clase para la configuracion de la app
    ip_address: str
    port: int