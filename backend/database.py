# backend/database.py

from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.ext.declarative import declarative_base

# 🔌 Reemplaza los valores con la información de tu servidor MySQL
DATABASE_URL = "mysql+mysqlconnector://root:@localhost:3306/base_de_datos" #Cambiar por la base de datos a usar
# Ejemplo: "mysql+mysqlconnector://admin_user:pass123@localhost:3306/estudio_contable_db"  # Ejemplo de como tiene que ir al tener el servidor de la base de datos

engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

