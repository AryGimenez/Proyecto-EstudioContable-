# models/cliente.py
from sqlalchemy import Column, Integer, String, Float
from sqlalchemy.orm import relationship
from backend.database import Base

class Cliente(Base):
    __tablename__ = "clientes"

    id = Column(Integer, primary_key=True, index=True)
    nombre_completo = Column(String)
    email = Column(String, unique=True, index=True)
    contacto = Column(String)
    whatsapp = Column(String)
    saldo = Column(Float, default=0.0)
    direccion = Column(String)

    impuestos = relationship("Impuesto", back_populates="cliente")
    pagos = relationship("Pago", back_populates="cliente")
    depositos = relationship("Deposito", back_populates="cliente")