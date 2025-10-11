# app/cheques/repository.py

from sqlalchemy.orm import Session, joinedload
from sqlalchemy import select
from sqlalchemy.exc import IntegrityError
from typing import List, Optional

# Importar desde el mismo paquete
from ..models.cheque import Cheque 
from ..schemas.cheques import ChequeCreate, ChequeUpdate
from ..models.cliente import Cliente
from ..models.nombre_impuesto import NombreImpuesto



class ChequeRepository:
    def __init__(self, db: Session):
        self.db = db

# Obtiene un cheque por ID
    def get_by_id(self, cheque_id: int) -> Optional[Cheque]:
        return self.db.execute(
            select(Cheque)
            .where(Cheque.Cheq_ID == cheque_id)
            .options(joinedload(Cheque.nombre_impuesto))
        ).scalars().first()
    
    def get_all_by_client(self, client_id: int) -> List[Cheque]:
        return self.db.execute(
            select(Cheque)
            .where(Cheque.Cli_ID == client_id)
            .order_by(Cheque.Cheq_FechaVencimiento.desc())
            .options(joinedload(Cheque.nombre_impuesto))
        ).scalars().all()

# Crea un nuevo cheque

    def create(self, cheque_data: ChequeCreate) -> Cheque:

        # 1. Validar Cliente

        cliente = self.db.query(Cliente).filter(Cliente.Cli_ID == cheque_data.Cli_ID).first()
        if not cliente:
            raise ValueError(f"Cliente con ID {cheque_data.Cli_ID} no encontrado")

        # 2. Validar Nombre de Impuesto (NomIm_ID)  
        nombre_impuesto = self.db.query(NombreImpuesto).filter(NombreImpuesto.NomIm_ID == cheque_data.NomIm_ID).first()
        if not nombre_impuesto:
            raise ValueError(f"Nombre de Impuesto con ID {cheque_data.NomIm_ID} no valido")
        
        # Crear el objeto Cheque e insertarlo
        db_cheque = Cheque(**cheque_data.dict())

        try:
            self.db.add(db_cheque)
            self.db.commit()
            self.db.refresh(db_cheque)
        except IntegrityError as e:
            self.db.rollback()
            raise IntegrityError(f"Error al cargar el cheque. Detalles: {e}", params=None, Orig=None)
        
        return self.get_by_id(db_cheque.Cheq_ID)
    
# Actualiza un cheque

    def update(self, cheque_id: int, cheque_update: ChequeUpdate) -> Optional[Cheque]:
        db_cheque = self.get_by_id(cheque_id)
        if not db_cheque:
            return None
        
        update_data = cheque_update.dict(exclude_unset=True)

        # Opcional: Validar si el Cli_ID o NomIm_ID cambia
        if 'Cli_ID' in update_data:
            if not self.db.query(Cliente).filter(Cliente.Cli_ID == update_data['Cli_ID']).first():
                raise ValueError(f"Cliente con ID {update_data['Cli_ID']} no encontrado para la actualización")
            
        if 'NomIm_ID' in update_data:
            if not self.db.query(NombreImpuesto).filter(NombreImpuesto.NomIm_ID == update_data['NomIm_ID']).first():
                raise ValueError(f"Nombre de Impuesto con ID {update_data['NomIm_ID']} no encontrado para la actualización")
            

        # Aplicar los cambios
        for key, value in update_data.items():
            setattr(db_cheque, key, value)

        self.db.add(db_cheque)
        self.db.commit()
        return self.get_by_id(db_cheque.Cheq_ID)
    
# Elimina un cheque

    def delete(self, cheque_id: int) -> Optional[Cheque]:
        db_cheque = self.get_by_id(cheque_id)
        if not db_cheque:
            return None
        
        # Almacenamos antes de eliminarlo

        cheque_eliminado = db_cheque

        self.db.delete(db_cheque)
        self.db.commit()

        return cheque_eliminado