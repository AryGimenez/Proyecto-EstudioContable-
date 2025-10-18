# backend/models/cheque.py

# Importaciones SQLAlchemy
from sqlalchemy import Column, Integer, String, Date, Numeric, ForeignKey # Importa los tipos de columna de SQLAlchemy
from sqlalchemy.orm import relationship # Importa la función 'relationship' para definir enlaces entre modelos
from datetime import date # Importa el tipo date de Python
from ..database import Base # Importa la clase base declarativa de SQLAlchemy

# Importaciones de modelos necesarios
from .cliente import Cliente # Importa el modelo Cliente para la relación
from .nombre_impuesto import NombreImpuesto # Importa el modelo NombreImpuesto para la relación

# --- Modelo Principal (Cheque) ---

class Cheque(Base): # Clase que define el modelo ORM para la tabla de cheques
    """Modelo para la tabla de Cheques""" # Documentación principal del modelo
    __tablename__ = "cheques" # Nombre exacto de la tabla en la base de datos

    # --- Claves Primarias y Foráneas ---
    Cheq_ID = Column(Integer, primary_key=True, index=True) # ID único del cheque, clave primaria e indexada
    
    # Se usa la referencia de tabla (string) para la clave foránea
    Cli_ID = Column(Integer, ForeignKey("Cliente.Cli_ID")) # Clave foránea al cliente que emite/posee el cheque
    NomIm_ID = Column(Integer, ForeignKey("NombreImpuesto.NomIm_ID"), nullable=True) # Clave foránea al tipo de impuesto asociado, puede ser nulo

    # --- Campos de Datos del Cheque ---
    Cheq_Numero = Column(String(50), index=True, nullable=False) # Número de referencia del cheque, indexado y obligatorio
    Cheq_Monto = Column(Numeric(precision=10, scale=2), nullable=False) # Monto del cheque, usa Numeric para precisión de 2 decimales, obligatorio
    Cheq_FechaEmision = Column(Date, default=date.today, nullable=False) # Fecha de emisión, por defecto la fecha actual, obligatorio
    Cheq_FechaVencimiento = Column(Date, nullable=False) # Fecha límite para el cobro o depósito, obligatorio
    Cheq_Estado = Column(String(50), default="Pendiente") # Estado actual del cheque (ej: Pendiente, Cobrado, Rechazado), por defecto "Pendiente"

    # 🔑 RELACIONES ORM: Ahora usan las clases importadas
    # SQLAlchemy relaciona automáticamente la clase con la tabla correcta a través del nombre.
    cliente = relationship("Cliente", back_populates="cheques") # Relación muchos-a-uno, permite acceder al objeto Cliente
    nombre_impuesto = relationship("NombreImpuesto") # Relación muchos-a-uno, permite acceder al objeto NombreImpuesto

    @property # Decorador que convierte el método en un atributo de lectura
    def Cheq_NomImpuesto(self): # Propiedad calculada para obtener el nombre del impuesto directamente
        """Devuelve el nombre del impuesto relacionado si está cargado (Eager Loaded)""" # Docstring que explica la propiedad
        if self.nombre_impuesto: # Verifica si la relación fue cargada
            return self.nombre_impuesto.NomIm_Txt # Retorna el texto descriptivo del impuesto
        return f"ID: {self.NomIm_ID} (Relación no cargada)" # Retorna un mensaje de advertencia si la relación no se cargó