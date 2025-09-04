# Backend - Proyecto Estudio Contable

Este backend está desarrollado en **Python** usando **FastAPI** y **SQLAlchemy**. Gestiona usuarios, clientes, impuestos, pagos y depósitos para un sistema contable.

## Estructura de Carpetas

- `backend/`
  - `main.py`: Punto de entrada de la API.
  - `database.py`: Configuración de la base de datos.
  - `dependencies.py`: Dependencias y conexión a la base de datos.
  - `models/`: Modelos de datos SQLAlchemy.
  - `schemas/`: Esquemas Pydantic para validación.
  - `router/`: Rutas de la API (clientes, usuarios, pagos, etc.).
  - `utils.py`: Funciones auxiliares.
  - `security.py`: Seguridad y autenticación.

## Instalación

1. Clona el repositorio.
2. Instala las dependencias:
   ```sh
   pip install -r requirements.txt