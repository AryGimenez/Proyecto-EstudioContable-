from pydantic import BaseModel, Field
from typing import Optional
from datetime import datetime

class NotificationMessage(BaseModel):
    """
    Esquema Pydantic para un mensaje de notificacion general.
    se usa tanto para WebSockets como para la logica de mensajes como whatsapp
    """

    id: Optional[int] = Field(default=None, description="ID de la notificación(Opcional para notificaciones persistentes)")
    type: str = Field(..., description="Tipo de notificación (e.g., 'pago_recibido', 'recordatorio_impuesto')")
    message: str = Field(..., description="Contenido del mensaje de la notificación")
    client_id: Optional[int] = Field(default=None, description="ID del cliente asociado (si aplica)")
    payment_id: Optional[int] = Field(default=None, description="ID del pago asociado (si aplica)")
    user_id: Optional[int] = Field(default=None, description="ID del usuario que generó la notificación (si aplica)")

    # Campos específicos para el contexto

    payment_id: Optional[int] = Field(default=None, description="ID del pago asociado (si aplica)")
    tax_id: Optional[int] = Field(default=None, description="ID del impuesto asociado (si aplica)")
    deposit_id: Optional[int] = Field(default=None, description="ID del depósito asociado (si aplica)")

    date: datetime = Field(default_factory=datetime.utcnow, description="Fecha y hora de la notificación")
    read: bool = Field(default=False, description="Indica si la notificación ha sido leída")

class Config:
    from_attributes = True