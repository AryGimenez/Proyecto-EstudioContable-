# backend/database.py

from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.ext.declarative import declarative_base
from typing import Generator


# 🔌 Reemplaza los valores con la información de tu servidor MySQL
DATABASE_URL = "mysql+mysqlconnector://root:@127.0.0.1:3306/gestion_contable" #Cambiar por la base de datos a usar
# Ejemplo: "mysql+mysqlconnector://admin_user:pass123@localhost:3306/estudio_contable_db"  # Ejemplo de como tiene que ir al tener el servidor de la base de datos

engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()

# Función para obtener la sesión de DB para las rutas de FastAPI
def get_db() -> Generator:
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# --- ¡NUEVA FUNCIÓN PARA EL SCHEDULER! --- codigo comentando para ejemplo de como usar alembic
# def get_db_session_for_scheduler() -> SessionLocal:
#     ""
#     O"btiene una sesión de base de datos directamente para el scheduler.
#     El scheduler es responsable de cerrar esta sesión si se le pasa directamente.
#     """
#     return SessionLocal()
# # ------------------------------------------