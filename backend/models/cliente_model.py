# backend/models/cliente_model.py

from sqlalchemy import Column, Integer, String, Float, Date, Numeric # Importa los tipos de columna de SQLAlchemy
from sqlalchemy.orm import relationship, Mapped, mapped_column # Importa sintaxis ORM moderna (Mapped) y relaciones
from typing import List # Tipo para anotaciones de relaciones uno-a-muchos
from datetime import date # Importa el tipo date de Python

from backend.database import Base # Asegura Importacion de Base de datos, para la posible creacion de la Tabla

class ClienteModel(Base): # Clase que define el modelo ORM para la tabla de Clientes
    
    __tablename__ = "Cliente" # El nombre de la tabla, que sera creada al abrir el uvicorn

    # --- Columnas de Atributos ---
    Cli_ID: Mapped[int] = mapped_column(Integer, primary_key=True, index=True) # ID único del cliente, clave primaria
    Cli_Nom: Mapped[str] = mapped_column(String(255)) # Nombre completo o razón social del cliente
    Cli_Dir: Mapped[str] = mapped_column(String(255)) # Dirección física o postal del cliente
    Cli_Email: Mapped[str] = mapped_column(String(255)) # Correo electrónico del cliente
    Cli_Whatsapp: Mapped[str] = mapped_column(String(20)) # Número de WhatsApp para alertas
    Cli_DatoContacto: Mapped[str] = mapped_column(String(255)) # Nombre de contacto secundario (si aplica)
    Cli_FechaNac: Mapped[date] = mapped_column(Date) # Fecha de nacimiento del cliente (tipo Date de SQL)
    
    # Precision para el saldo
    Cli_Saldo: Mapped[float] = mapped_column(Numeric(precision=10, scale=2), default=0.0) # Saldo actual del cliente, usa Numeric con 2 decimales, por defecto 0.0

    # --- Relaciones (relationships), para mapeo de otros models ---

    impuestos: Mapped[List["Impuesto"]] = relationship( # Relación uno-a-muchos con la tabla Impuesto
        "Impuesto", back_populates="cliente", cascade="all, delete-orphan" # Permite acceder a sus impuestos, borrado en cascada
    )
    pagos: Mapped[List["Pago"]] = relationship( # Relación uno-a-muchos con la tabla Pago
        "Pago", back_populates="cliente", cascade="all, delete-orphan" # Permite acceder a sus pagos, borrado en cascada
    )
    depositos: Mapped[List["Deposito"]] = relationship( # Relación uno-a-muchos con la tabla Deposito
        "Deposito", back_populates="cliente", cascade="all, delete-orphan" # Permite acceder a sus depósitos, borrado en cascada
    )
    cheques: Mapped[List["Cheque"]] = relationship( # Relación uno-a-muchos con la tabla Cheque
        "Cheque", back_populates="cliente", cascade="all, delete-orphan" # Permite acceder a sus cheques, borrado en cascada
    )
    notificaciones: Mapped[List["Notificacion"]] = relationship( # Relación uno-a-muchos con la tabla Notificacion
        "Notificacion", back_populates="cliente", cascade="all, delete-orphan" # Permite acceder a sus notificaciones, borrado en cascada
    )

    def __repr__(self): # Método para representación legible del objeto en logs/depuración
        return f"<Cliente ID: {self.Cli_ID}, Nombre: {self.Cli_Nom}>"