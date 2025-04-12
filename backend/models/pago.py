# models/pago.py
from sqlalchemy import Column, Integer, Float, ForeignKey, Date, String
from sqlalchemy.orm import relationship
from backend.database import Base
from sqlalchemy.sql import func

class Pago(Base):
    __tablename__ = "pagos"

    id = Column(Integer, primary_key=True, index=True)
    monto_pago = Column(Float)
    fecha_pago = Column(Date, default=func.now())
    red_cobranza = Column(String)
    concepto = Column(String)
    cliente_id = Column(Integer, ForeignKey("clientes.id"))
    impuesto_id = Column(Integer, ForeignKey("impuestos.id"))

    cliente = relationship("Cliente", back_populates="pagos")
    impuesto = relationship("Impuesto", back_populates="pago")