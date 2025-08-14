from pydantic import BaseModel

class AppConfig(BaseModel):
    ip_address: str
    port: int