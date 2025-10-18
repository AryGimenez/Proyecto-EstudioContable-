# backend/repositorios/usuario_repository.py

from sqlalchemy.orm import Session
from sqlalchemy.exc import IntegrityError # Importa el error de integridad
from typing import Optional, List

# CORRECCIÓN/AJUSTE: Asumo que estos son los paths correctos según la estructura
from .. import models, schemas
from ..security import get_password_hash # Función para hashear contraseñas


class UsuarioRepository:
    """
    Clase de repositorio que maneja las operaciones CRUD para el modelo Usuario.
    Es responsable de la lógica de seguridad básica: hashing de contraseñas y
    verificación de unicidad (username/email).
    """
    def __init__(self, db: Session):
        """Inicializa el repositorio con la sesión de base de datos."""
        self.db = db

# ----------------------------------------------------------------------
# MÉTODOS DE LECTURA (GET)
# ----------------------------------------------------------------------

    def get_by_id(self, usuario_id: int) -> Optional[models.Usuario]:
        """Obtiene un usuario por su ID primario."""
        return self.db.query(models.Usuario).filter(models.Usuario.usuario_id == usuario_id).first()

    def get_by_username(self, usuario_nombre: str) -> Optional[models.Usuario]:
        """Obtiene un usuario por su nombre de usuario, clave única para login."""
        return self.db.query(models.Usuario).filter(models.Usuario.usuario_nombre == usuario_nombre).first()

    def get_by_email(self, usuario_email: str) -> Optional[models.Usuario]:
        """Obtiene un usuario por su dirección de email, clave única."""
        return self.db.query(models.Usuario).filter(models.Usuario.usuario_email == usuario_email).first()

    def get_all(self, skip: int = 0, limit: int = 255) -> List[models.Usuario]:
        """Obtiene todos los usuarios, con soporte para paginación."""
        return self.db.query(models.Usuario).offset(skip).limit(limit).all()

# ----------------------------------------------------------------------
# MÉTODO DE CREACIÓN (CREATE)
# ----------------------------------------------------------------------

    def create(self, usuario_data: schemas.user.UsuarioCreate) -> Optional[models.Usuario]:
        """
        Crea un nuevo usuario, hashea la contraseña y maneja errores de unicidad.
        
        Flujo:
        1. Verifica manualmente la unicidad (opcional, pero útil para feedback rápido).
        2. Hashea la contraseña.
        3. Intenta guardar y hace rollback en caso de `IntegrityError` (duplicados, NOT NULL).
        
        Returns:
            models.Usuario: La instancia del usuario recién creado.
            None: Si el nombre de usuario/email ya existe o si ocurre un error de DB.
        """
        # La verificación de duplicados es buena, pero el commit puede fallar por otras razones
        if self.get_by_username(usuario_data.username):
            return None # El router/servicio debe manejar este retorno
        if self.get_by_email(usuario_data.email):
            return None # El router/servicio debe manejar este retorno

        # 1. Hashear la contraseña antes de crear el objeto
        hashed_password = get_password_hash(usuario_data.password)
        
        # 2. Crear el objeto modelo, mapeando Pydantic a SQLAlchemy
        db_usuario = models.Usuario(
            usuario_nombre=usuario_data.username, 
            usuario_email=usuario_data.email, 
            usuario_contraseña=hashed_password, # Contraseña hasheada
            usuario_rol=usuario_data.usuario_rol,
            is_active=usuario_data.is_active 
        )
        self.db.add(db_usuario)

        try:
            # 3. Commit y Refresh
            self.db.commit()
            self.db.refresh(db_usuario)
            return db_usuario
        except IntegrityError:
            # Captura errores de unicidad (aunque ya se verificaron) o NOT NULL
            self.db.rollback()
            return None
        except Exception:
            # Captura cualquier otro error del commit
            self.db.rollback()
            return None

        
# ----------------------------------------------------------------------
# MÉTODO DE ACTUALIZACIÓN (UPDATE)
# ----------------------------------------------------------------------

    def update(self, usuario_id: int, usuario_data: schemas.user.UsuarioUpdate) -> Optional[models.Usuario]:
        """
        Actualiza los campos de un usuario. Hashea la contraseña si se proporciona.
        
        Flujo:
        1. Valida si el usuario existe.
        2. Si se incluye la contraseña, la hashea.
        3. Aplica los cambios y hace rollback en caso de `IntegrityError` (ej. cambiar a un email/username ya existente).
        
        Returns:
            models.Usuario: La instancia actualizada del usuario.
            None: Si el usuario no existe o si ocurre un error de DB/Integridad.
        """
        db_usuario = self.get_by_id(usuario_id)
        if db_usuario is None:
            return None
        
        # Convierte Pydantic a dict, excluyendo campos no proporcionados
        # Nota: model_dump y by_alias son buenas prácticas de Pydantic v2
        update_data = usuario_data.model_dump(exclude_unset=True, by_alias=True)
        
        # 1. Hashear la nueva contraseña si se proporciona
        if "usuario_contraseña" in update_data and update_data["usuario_contraseña"]:
            update_data["usuario_contraseña"] = get_password_hash(update_data["usuario_contraseña"])
            
        # 2. Aplicar los cambios
        for key, value in update_data.items():
            setattr(db_usuario, key, value)
            
        try:
            # 3. Commit
            self.db.commit()
            self.db.refresh(db_usuario)
            return db_usuario
        except IntegrityError:
            self.db.rollback()
            return None 
        except Exception:
            self.db.rollback()
            return None

# ----------------------------------------------------------------------
# MÉTODO DE ELIMINACIÓN (DELETE)
# ----------------------------------------------------------------------

    def delete(self, usuario_id: int) -> Optional[models.Usuario]:
        """
        Elimina un usuario por su ID.
        
        Returns:
            models.Usuario: La instancia del usuario eliminado si existía.
            None: Si el usuario no existe o si ocurre un error en el commit.
        """
        db_usuario = self.get_by_id(usuario_id)
        if db_usuario is None:
            return None
        
        # Guardar la instancia antes de eliminar para poder retornarla
        usuario_eliminado = db_usuario 
        
        self.db.delete(db_usuario)
        try:
            self.db.commit()
            return usuario_eliminado
        except Exception:
            self.db.rollback()
            # Podrías lanzar un error específico si este usuario tiene dependencias
            return None