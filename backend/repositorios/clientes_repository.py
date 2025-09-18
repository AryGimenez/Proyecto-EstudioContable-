# backend/repositorios/clientes_repository.py

from sqlalchemy.orm import Session
from sqlalchemy.exc import IntegrityError
from backend import models, schemas

class ClienteRepository:
    def __init__(self, db: Session):
        self.db = db

# Obtiene un cliente por ID

    def get_by_id(self, cliente_id: int):
        return self.db.query(models.Cliente).filter(models.Cliente.Cli_ID == cliente_id).first()

# Obtiene todos los clientes

    def get_all(self, skip: int = 0, limit: int = 100):
        return self.db.query(models.Cliente).offset(skip).limit(limit).all()


#  Crea un nuevo cliente 
    def create(self, cliente_data: schemas.cliente.ClienteCreate):
        db_cliente = models.Cliente(
            Cli_Nom=cliente_data.Cli_Nom,
            Cli_Dir=cliente_data.Cli_Dir,
            Cli_Email=cliente_data.Cli_Email,
            Cli_Whatsapp=cliente_data.Cli_Whatsapp,
            Cli_Contacto=cliente_data.Cli_Contacto,
            Cli_FechaNac=cliente_data.Cli_FechaNac,
            Cli_Saldo=cliente_data.Cli_Saldo
        )
        self.db.add(db_cliente)
        try:
            self.db.commit()
            self.db.refresh(db_cliente)
            return db_cliente
        except IntegrityError:
            self.db.rollback()
            return None
        
#   Actualiza un cliente existente

    def update(self, cliente_id: int, cliente_data: schemas.cliente.ClienteUpdate):
        db_cliente = self.get_by_id(cliente_id)
        if db_cliente is None:
            return None
        
        update_data = cliente_data.dict(exclude_unset=True)
        for key, value in update_data.items():
            setattr(db_cliente, key, value)
        
        try:
            self.db.commit()
        except IntegrityError:
            self.db.rollback()
            return None
        
        self.db.refresh(db_cliente)
        return db_cliente

#   Elimina un cliente existente

    def delete(self, cliente_id: int): # Puedes añadir -> Optional[models.Cliente] para el tipo de retorno
        db_cliente = self.get_by_id(cliente_id) # Asumiendo que get_by_id devuelve el objeto Cliente o None
        if db_cliente is None:
            return None # Si el cliente no existe, devuelve None

        self.db.delete(db_cliente)
        try:
            self.db.commit() # Intenta guardar los cambios
            return db_cliente # Si tiene éxito, devuelve el cliente eliminado
        except Exception as e:
            self.db.rollback() # Si falla, deshaz los cambios
            # Opcional: puedes loggear el error 'e' aquí para depuración
            print(f"Error al eliminar cliente {cliente_id}: {e}") 
            return None # Si falla, devuelve None