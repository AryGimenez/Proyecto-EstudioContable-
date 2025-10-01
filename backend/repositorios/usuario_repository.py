# backend/repositorios/usuario_repository.py

from sqlalchemy.orm import Session
from sqlalchemy.exc import IntegrityError # Importa el error de integridad
from typing import Optional, List

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

    def create(self, usuario_data: schemas.user.UsuarioCreate) -> Optional[models.Usuario]:
        # La verificación de duplicados es buena, pero el commit puede fallar por otras razones
        if self.get_by_username(usuario_data.username):
            return None
        if self.get_by_email(usuario_data.email):
            return None

        hashed_password = get_password_hash(usuario_data.password)
        db_usuario = models.Usuario(
            usuario_nombre=usuario_data.username, # Accedemos por el nombre del esquema Pydantic
            usuario_email=usuario_data.email,      # Accedemos por el nombre del esquema Pydantic
            usuario_contraseña=hashed_password,
            usuario_rol=usuario_data.usuario_rol,
            is_active=usuario_data.is_active # Incluimos is_active
        )
        self.db.add(db_usuario)

        # ⚠️ Añade un bloque try-except para capturar el error de la base de datos
        try:
            self.db.commit()
            self.db.refresh(db_usuario)
            return db_usuario
        except IntegrityError:
            # Si el commit falla (por duplicidad o datos inválidos), haz un rollback
            self.db.rollback()
            return None
        except Exception:
            # Captura cualquier otro error del commit
            self.db.rollback()
            return None

        
    def update(self, usuario_id: int, usuario_data: schemas.user.UsuarioUpdate) -> Optional[models.Usuario]:
        db_usuario = self.get_by_id(usuario_id)
        if db_usuario is None:
            return None
        
        update_data = usuario_data.model_dump(exclude_unset=True, by_alias=True)
        if "usuario_contraseña" in update_data and update_data["usuario_contraseña"]:
            update_data["usuario_contraseña"] = get_password_hash(update_data["usuario_contraseña"])
            
        for key, value in update_data.items():
            setattr(db_usuario, key, value)
            
        try:
            self.db.commit()
            self.db.refresh(db_usuario)
            return db_usuario
        except IntegrityError:
            self.db.rollback()
            return None # Retorna None si la actualización falla por un valor duplicado
        except Exception:
            self.db.rollback()
            return None

    def delete(self, usuario_id: int) -> Optional[models.Usuario]:
        db_usuario = self.get_by_id(usuario_id)
        if db_usuario is None:
            return None
        
        self.db.delete(db_usuario)
        try:
            self.db.commit()
            return db_usuario
        except Exception:
            self.db.rollback()
            return None