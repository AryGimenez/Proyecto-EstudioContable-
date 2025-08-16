# models/deposito.py
from sqlalchemy import Column, Integer, Float, ForeignKey, Date, String
from sqlalchemy.orm import relationship
from backend.database import Base
from sqlalchemy.sql import func

class Deposito(Base):
    __tablename__ = "depositos"

    id = Column(Integer, primary_key=True, index=True)
    monto = Column(Float)
    fecha = Column(Date, default=func.now())
    concepto = Column(String)
    cliente_id = Column(Integer, ForeignKey("clientes.id"))

    cliente = relationship("Cliente", back_populates="depositos")