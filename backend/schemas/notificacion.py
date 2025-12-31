# backend/schemas/notificacion.py

# Imporataciones para la funcionalidad del esquema de notificacion
from pydantic import BaseModel, Field
from typing import Optional
from datetime import datetime



class NotificationMessage(BaseModel): # Clase para generar el mensaje con los archivos del la carpeta services
    """
    Esquema Pydantic para un mensaje de notificacion general.
    se usa tanto para WebSockets como para la logica de mensajes como whatsapp
    """

    id: Optional[int] = Field(default=None, description="ID de la notificación(Opcional para notificaciones persistentes)") # ID de la notificación, para notificaciones persistentes
    type: str = Field(..., description="Tipo de notificación (e.g., 'pago_recibido', 'recordatorio_impuesto')") # Tipo de notificación, puede ser pago_recibido, recordatorio_impuesto, etc
    message: str = Field(..., description="Contenido del mensaje de la notificación") # Contenido del mensaje de la notificación, retorna un string con el mensaje predefinido en el backend/services
    # Campos opcionales para IDs relacionados
    client_id: Optional[int] = Field(default=None, description="ID del cliente asociado (si aplica)") # ID del cliente asociado (si aplica), encargado de enviar la notificación, al whatsapp o al frontend, con la id registrada en la base de datos
    payment_id: Optional[int] = Field(default=None, description="ID del pago asociado (si aplica)") # ID del pago asociado (si aplica)
    user_id: Optional[int] = Field(default=None, description="ID del usuario que generó la notificación (si aplica)") # ID del usuario que generó la notificación (si aplica)

    # Campos específicos para el contexto

    tax_id: Optional[int] = Field(default=None, description="ID del impuesto asociado (si aplica)") # ID del impuesto asociado (si aplica)
    deposit_id: Optional[int] = Field(default=None, description="ID del depósito asociado (si aplica)") # ID del depósito asociado (si aplica)

    date: datetime = Field(default_factory=datetime.utcnow, description="Fecha y hora de la notificación") # Fecha y hora de la notificación, se genera automaticamente al crear la notificación
    read: bool = Field(default=False, description="Indica si la notificación ha sido leída") # Indica si la notificación ha sido leída, por defecto es false

class Config:
    from_attributes = True