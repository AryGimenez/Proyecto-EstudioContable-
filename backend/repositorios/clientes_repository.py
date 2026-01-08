# backend/repositorios/clientes_repository.py

from sqlalchemy.orm import Session
from sqlalchemy.exc import IntegrityError
from typing import List, Optional
from decimal import Decimal # Mantener si se usa Decimal en otros repositorios para consistencia

from ..models.cliente_model import ClienteModel # Importa el modelo de la DB
from ..schemas.cliente_schem import ClienteCreate, ClienteUpdate # Importa los esquemas de Pydantic

class ClienteRepository:
    """
    Clase de repositorio que maneja las operaciones CRUD (Crear, Leer, Actualizar, Eliminar)
    para el modelo ClienteModel. Actúa como la capa de acceso a datos para la tabla de clientes.
    """
    def __init__(self, db: Session):
        """
        Inicializa el repositorio con la sesión de base de datos de SQLAlchemy.
        
        Args:
            db (Session): Sesión de SQLAlchemy inyectada por FastAPI (get_db).
        """
        self.db = db

# ----------------------------------------------------------------------
# MÉTODOS DE LECTURA (GET)
# ----------------------------------------------------------------------

    def get_by_id(self, cliente_id: int) -> Optional[ClienteModel]:
        """
        Obtiene un cliente por su ID.
        
        Args:
            cliente_id (int): ID del cliente a buscar.
            
        Returns:
            Optional[ClienteModel]: La instancia del modelo ClienteModel si se encuentra, o None.
        """
        return self.db.query(ClienteModel).filter(ClienteModel.Cli_ID == cliente_id).first()

    
    def get_all(self) -> List[ClienteModel]:
        """
        Obtiene una lista de todos los clientes en la base de datos.
        
        Returns:
            List[ClienteModel]: Una lista de instancias del modelo ClienteModel.
        """
        return self.db.query(ClienteModel).all()


# ----------------------------------------------------------------------
# MÉTODO DE CREACIÓN (CREATE)
# ----------------------------------------------------------------------
    def create(self, cliente_data: ClienteCreate) -> ClienteModel:
        """
        Crea un nuevo registro de cliente en la base de datos.
        
        Args:
            cliente_data (ClienteCreate): Esquema Pydantic con los datos del nuevo cliente.
            
        Returns:
            ClienteModel: La instancia del modelo ClienteModel recién creada y refrescada.
        
        Raises:
            IntegrityError: Si falla alguna restricción de unicidad o NOT NULL.
        """
        
        # Convierte el esquema Pydantic (cliente_data) a una instancia del modelo SQLAlchemy (db_cliente)
        db_cliente = ClienteModel(**cliente_data.dict()) 
        
        try:
            self.db.add(db_cliente) 
            self.db.commit()
            self.db.refresh(db_cliente)
            return db_cliente
        except IntegrityError:
            # En caso de fallar el commit por una restricción (ej. DNI duplicado), se hace rollback
            self.db.rollback()
            # Se podría relanzar una excepción más específica si fuera necesario
            raise 
    
# ----------------------------------------------------------------------
# MÉTODO DE ACTUALIZACIÓN (UPDATE)
# ---------------------------------------------------------------------- 

    def update(self, cliente_id: int, cliente_data: ClienteUpdate) -> Optional[ClienteModel]:
        """
        Actualiza los campos de un cliente existente.
        
        Args:
            cliente_id (int): ID del cliente a actualizar.
            cliente_data (ClienteUpdate): Esquema Pydantic con los campos a modificar.
            
        Returns:
            Optional[ClienteModel]: La instancia actualizada del modelo ClienteModel si se encuentra, o None.
        """
        db_cliente = self.get_by_id(cliente_id)
        if db_cliente:
            # Obtiene un diccionario de los campos del Pydantic que fueron realmente enviados
            update_data = cliente_data.dict(exclude_unset=True)
            
            # Itera sobre los datos y actualiza los atributos del objeto SQLAlchemy
            for key, value in update_data.items():
                setattr(db_cliente, key, value)
            
            self.db.commit()
            self.db.refresh(db_cliente)
        return db_cliente


# ----------------------------------------------------------------------
# MÉTODO DE ELIMINACIÓN (DELETE)
# ----------------------------------------------------------------------
    def delete(self, cliente_id: int) -> Optional[ClienteModel]:
        """
        Elimina un cliente por su ID.
        
        Nota: La eliminación del cliente puede desencadenar eliminaciones en cascada 
        (ej. impuestos y pagos asociados) si el modelo ClienteModel está configurado con 
        `cascade="all, delete-orphan"` en sus relaciones.
        
        Args:
            cliente_id (int): ID del cliente a eliminar.
            
        Returns:
            Optional[ClienteModel]: La instancia del cliente eliminado si existía, o None.
        """
        db_cliente = self.get_by_id(cliente_id)
        if db_cliente:
            # Guarda la instancia antes de eliminar para poder retornarla
            cliente_eliminado = db_cliente
            
            self.db.delete(db_cliente)
            self.db.commit()
            return cliente_eliminado # Retorna el objeto que fue eliminado
        
        return None