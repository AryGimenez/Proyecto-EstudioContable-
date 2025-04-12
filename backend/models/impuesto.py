# models/impuesto.py
from sqlalchemy import Column, Integer, String, Float, ForeignKey
from sqlalchemy.orm import relationship
from backend.database import Base

class Impuesto(Base):
    __tablename__ = "impuestos"

    id = Column(Integer, primary_key=True, index=True)
    tipo = Column(String)
    monto = Column(Float)
    monto_pago = Column(Float, default=0.0)
    honorario = Column(Float, default=0.0)
    cliente_id = Column(Integer, ForeignKey("clientes.id"))

    cliente = relationship("Cliente", back_populates="impuestos")
    pago = relationship("Pago", back_populates="impuesto")