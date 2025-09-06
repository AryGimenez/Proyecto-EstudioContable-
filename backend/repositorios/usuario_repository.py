# backend/repositorios/usuario_repository.py

from sqlalchemy.orm import Session
from sqlalchemy.exc import IntegrityError # Importa el error de integridad
from backend import models, schemas
from backend.security import get_password_hash


class UsuarioRepository:
    def __init__(self, db: Session):
        self.db = db

    def get_by_id(self, usuario_id: int):
        return self.db.query(models.Usuario).filter(models.Usuario.usuario_id == usuario_id).first()

    def get_by_username(self, usuario_nombre: str):
        return self.db.query(models.Usuario).filter(models.Usuario.usuario_nombre == usuario_nombre).first()

    def get_by_email(self, usuario_email: str):
        return self.db.query(models.Usuario).filter(models.Usuario.usuario_email == usuario_email).first()

    def get_all(self, skip: int = 0, limit: int = 255):
        return self.db.query(models.Usuario).offset(skip).limit(limit).all()

    def create(self, usuario_data: schemas.user.UsuarioCreate):
        # La verificación de duplicados es buena, pero el commit puede fallar por otras razones
        if self.get_by_username(usuario_data.usuario_nombre):
            return None
        if self.get_by_email(usuario_data.usuario_email):
            return None

        hashed_password = get_password_hash(usuario_data.usuario_contraseña)
        db_usuario = models.Usuario(
            usuario_nombre=usuario_data.usuario_nombre,
            usuario_email=usuario_data.usuario_email,
            # Asegúrate de que esta columna pueda almacenar la contraseña hasheada
            usuario_contraseña=hashed_password,
            usuario_rol=usuario_data.usuario_rol
        )
        self.db.add(db_usuario)

        # ⚠️ Añade un bloque try-except para capturar el error de la base de datos
        try:
            self.db.commit()
        except IntegrityError:
            # Si el commit falla (por duplicidad o datos inválidos), haz un rollback
            self.db.rollback()
            return None
        except Exception as e:
            # Captura cualquier otro error del commit
            self.db.rollback()
            raise e

        self.db.refresh(db_usuario)
        return db_usuario
        
    def update(self, usuario_id: int, usuario_data: schemas.user.UsuarioUpdate):
        db_usuario = self.get_by_id(usuario_id)
        if db_usuario is None:
            return None
        
        update_data = usuario_data.dict(exclude_unset=True)
        if "usuario_contraseña" in update_data:
            update_data["usuario_contraseña"] = get_password_hash(update_data["usuario_contraseña"])
            
        for key, value in update_data.items():
            setattr(db_usuario, key, value)
            
        try:
            self.db.commit()
        except IntegrityError:
            self.db.rollback()
            return None # Retorna None si la actualización falla por un valor duplicado
        self.db.refresh(db_usuario)
        return db_usuario

    def delete(self, usuario_id: int):
        db_usuario = self.get_by_id(usuario_id)
        if db_usuario is None:
            return None
        self.db.delete(db_usuario)
        self.db.commit()
        return db_usuario