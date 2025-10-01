# backend/models/notificacion.py

from sqlalchemy import Integer, String, Date, DateTime, ForeignKey, Boolean
from sqlalchemy.orm import relationship, Mapped, mapped_column
from typing import Optional
from datetime import datetime, date

from ..database import Base
from .cliente import Cliente # Necesitamos relacionar notificaciones con clientes

class Notificacion(Base):
    __tablename__ = "Notificacion"

    Not_ID: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    Not_Type: Mapped[str] = mapped_column(String(50)) # 'vencimiento', 'pago', 'deposito'
    Not_Mensaje: Mapped[str] = mapped_column(String(500))
    Not_FechaCreacion: Mapped[datetime] = mapped_column(DateTime, default=datetime.now)
    Not_Leida: Mapped[bool] = mapped_column(Boolean, default=False)
    Not_FechaAccion: Mapped[Optional[date]] = mapped_column(Date, nullable=True) # Fecha del vencimiento, pago o deposito

    # Opcional: Relacionar con el cliente si la notificación es específica para él
    Cli_ID: Mapped[Optional[int]] = mapped_column(Integer, ForeignKey("Cliente.Cli_ID"), nullable=True)
    cliente: Mapped[Optional["Cliente"]] = relationship("Cliente", back_populates="notificaciones")

    # Opcional: Relacionar con el impuesto, pago o deposito si la notificación es de uno de esos tipos
    Imp_ID: Mapped[Optional[int]] = mapped_column(Integer, ForeignKey("Impuesto.Imp_ID"), nullable=True)
    impuesto: Mapped[Optional["Impuesto"]] = relationship("Impuesto", back_populates="notificaciones")
    
    Pago_ID: Mapped[Optional[int]] = mapped_column(Integer, ForeignKey("Pagos.Pago_ID"), nullable=True)
    pago: Mapped[Optional["Pago"]] = relationship("Pago", back_populates="notificaciones")

    Dep_ID: Mapped[Optional[int]] = mapped_column(Integer, ForeignKey("Depositos.Dep_ID"), nullable=True)
    deposito: Mapped[Optional["Deposito"]] = relationship("Deposito", back_populates="notificaciones")