# backend/models/cheque.py

# Importaciones SQLAlchemy
from sqlalchemy import Column, Integer, String, Date, Numeric, ForeignKey
from sqlalchemy.orm import relationship
from datetime import date
from ..database import Base # Asumo que Base está en app/database.py

# Importaciones de modelos necesarios
from .cliente import Cliente
from .nombre_impuesto import NombreImpuesto 

# --- Modelo Principal (Cheque) ---

class Cheque(Base):
    """Modelo para la tabla de Cheques"""
    __tablename__ = "cheques"

    # Claves Primarias y Foráneas
    Cheq_ID = Column(Integer, primary_key=True, index=True)
    
    # Se usa la referencia de tabla (string) para la clave foránea
    Cli_ID = Column(Integer, ForeignKey("Cliente.Cli_ID")) 
    NomIm_ID = Column(Integer, ForeignKey("NombreImpuesto.NomIm_ID"))

    # Campos de Datos del Cheque
    Cheq_Numero = Column(String(50), index=True, nullable=False)
    Cheq_Monto = Column(Numeric(10, 2), nullable=False)
    Cheq_FechaEmision = Column(Date, default=date.today, nullable=False)
    Cheq_FechaVencimiento = Column(Date, nullable=False)
    Cheq_Estado = Column(String(50), default="Pendiente") 

    # 🔑 RELACIONES ORM: Ahora usan las clases importadas
    # SQLAlchemy relaciona automáticamente la clase con la tabla correcta a través del nombre.
    cliente = relationship("Cliente", back_populates="cheques")
    nombre_impuesto = relationship("NombreImpuesto")

    @property
    def Cheq_NomImpuesto(self):
        """Devuelve el nombre del impuesto relacionado si está cargado (Eager Loaded)"""
        if self.nombre_impuesto:
            return self.nombre_impuesto.NomIm_Txt
        return f"ID: {self.NomIm_ID} (Relación no cargada)"
