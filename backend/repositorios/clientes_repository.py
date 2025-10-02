# backend/repositorios/clientes_repository.py

from sqlalchemy.orm import Session
from sqlalchemy.exc import IntegrityError
from typing import List, Optional

from ..models.cliente import Cliente
from ..schemas.cliente import ClienteCreate, ClienteUpdate # Importa el esquema de creación

class ClienteRepository:
    def __init__(self, db: Session):
        self.db = db

# Obtiene un cliente por ID

    def get_by_id(self, cliente_id: int) -> Optional[Cliente]:

        return self.db.query(Cliente).filter(Cliente.Cli_ID == cliente_id).first()

# Obtiene todos los clientes

    def get_all(self) -> List[Cliente]:

        return self.db.query(Cliente).all()


#  Crea un nuevo cliente 
    def create(self, cliente_data: ClienteCreate) -> Cliente:
        
        # --- ¡ESTA ES LA LÍNEA CLAVE! ---
        # Convertimos el esquema Pydantic (cliente_data) a una instancia del modelo SQLAlchemy (db_cliente)
        db_cliente = Cliente(**cliente_data.dict()) 
        # --------------------------------

        self.db.add(db_cliente)  # <--- Ahora SÍ estamos añadiendo una instancia del MODELO SQLAlchemy
        self.db.commit()
        self.db.refresh(db_cliente)
        return db_cliente
    
    
#   Actualiza un cliente existente

    def update(self, cliente_id: int, cliente_data: ClienteUpdate) -> Optional[Cliente]:

        db_cliente = self.get_by_id(cliente_id)
        if db_cliente:
            # Iterar sobre los campos proporcionados en cliente_data que NO son None
            # exclude_unset=True asegura que solo se usen los campos que realmente se enviaron
            # si el cliente_data viene de una Pydantic con valores por defecto
            update_data = cliente_data.dict(exclude_unset=True)
            
            for key, value in update_data.items():
                setattr(db_cliente, key, value)
            
            self.db.commit()
            self.db.refresh(db_cliente)
        return db_cliente


#   Elimina un cliente existente
    def delete(self, cliente_id: int) -> Optional[Cliente]:

        db_cliente = self.get_by_id(cliente_id)
        if db_cliente:
            # Lógica para manejar dependencias antes de eliminar:
            # - ¿Qué pasa con los impuestos y pagos asociados a este cliente?
            #   Tu modelo Cliente tiene cascade="all, delete-orphan" para impuestos y pagos,
            #   lo que significa que se eliminarán automáticamente.
            #   Si quieres otra lógica (ej. anular impuestos, reasignar pagos), deberías implementarla aquí.
            
            self.db.delete(db_cliente)
            self.db.commit()
        return db_cliente