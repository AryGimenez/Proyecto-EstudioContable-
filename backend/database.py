# backend/database.py

from sqlalchemy import create_engine # Es el "Conector". Es la herramienta que sabe cómo hablar el idioma de MySQL.
from sqlalchemy.orm import sessionmaker # Es la "Fábrica". No crea una conexión, sino que crea un objeto que fabrica sesiones (conversaciones) con la base de datos.
from sqlalchemy.ext.declarative import declarative_base # Es el "Traductor". Crea una clase base. Todas las clases que hereden de ella (como Cliente o Impuesto) serán traducidas automáticamente a tablas de SQL
from typing import Generator

# Configuración de la base de datos MySQL
usuario = "root"
password = "password"
host = "127.0.0.1"
puerto = "3306"
nombre_base_datos = "estudioContable"

# 🔌 Configuración de la base de datos
DATABASE_URL = f"mysql+mysqlconnector://{usuario}:{password}@{host}:{puerto}/{nombre_base_datos}" 

engine = create_engine(DATABASE_URL) # Motor de la base de datos

#Configuramos como quermos la sesion
SessionLocal = sessionmaker(autocommit=False, #  No hace cambios amenos que se de la orden (db.commit())
                            autoflush=False, # Evita que se envíen cambios a la base de datos antes de que tú lo pidas.
                            bind=engine)
# Clase base para los modelos ORM
Base = declarative_base()

# Función que proporciona una secion de base de datos
# funciona como grifo de agua, abre y cierra la conexion
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