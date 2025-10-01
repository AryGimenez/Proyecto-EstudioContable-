# Backend - Sistema de Gestión de Pagos y Alertas

Este backend está desarrollado con **FastAPI** y **SQLAlchemy**. Gestiona usuarios, clientes, pagos, depósitos e impuestos, proporcionando una API REST segura y escalable.

---

## Estructura de Carpetas

```
backend/
│
├── config.py
├── database.py
├── dependencies.py
├── docker-compose.yml
├── dockerfile
├── main.py
├── security.py
├── utils.py
│
├── models/
│   ├── cliente.py
│   ├── deposito.py
│   ├── impuesto.py
│   ├── pago.py
│   ├── password_reset_request.py
│   └── user.py
│
├── router/
│   ├── auth.py
│   ├── clientes.py
│   ├── depositos.py
│   ├── impuestos.py
│   ├── pagos.py
│   └── user.py
│
├── schemas/
│   ├── auth.py
│   ├── cliente.py
│   ├── config.py
│   ├── deposito.py
│   ├── impuesto.py
│   ├── pago.py
│   └── user.py
│
└── FastApi/
    ├── main.py
    └── router/
        ├── auth.py
        ├── reauth.py
        └── users.py
```

---

## Descripción de Archivos

### Archivos Principales

- **config.py**  
  Configuración global del proyecto (variables de entorno, claves, rutas).

- **database.py**  
  Configuración y conexión a la base de datos con SQLAlchemy.

- **dependencies.py**  
  Dependencias reutilizables para los endpoints (sesión de BD, autenticación).

- **main.py**  
  Punto de entrada de la aplicación FastAPI. Inicializa la app, routers y middlewares.

- **security.py**  
  Funciones de seguridad: manejo de contraseñas y tokens JWT.

- **utils.py**  
  Funciones auxiliares y utilitarias para el backend.

---

### Carpeta `models/`

Modelos ORM que representan las tablas de la base de datos:

- **cliente.py**: Modelo de cliente.
- **deposito.py**: Modelo de depósito.
- **impuesto.py**: Modelo de impuesto.
- **pago.py**: Modelo de pago.
- **password_reset_request.py**: Solicitudes de restablecimiento de contraseña.
- **user.py**: Modelo de usuario.

---

### Carpeta `router/`

Endpoints de la API REST:

- **auth.py**: Autenticación (login, registro, recuperación).
- **clientes.py**: CRUD de clientes.
- **depositos.py**: CRUD de depósitos.
- **impuestos.py**: CRUD de impuestos.
- **pagos.py**: CRUD de pagos.
- **user.py**: Gestión de usuarios.

---

### Carpeta `schemas/`

Esquemas Pydantic para validación y serialización de datos:

- **auth.py**: Esquemas de autenticación.
- **cliente.py**: Esquemas de clientes.
- **config.py**: Esquemas de configuración.
- **deposito.py**: Esquemas de depósitos.
- **impuesto.py**: Esquemas de impuestos.
- **pago.py**: Esquemas de pagos.
- **user.py**: Esquemas de usuarios.

---

### Carpeta `FastApi/`

Sub-aplicación o módulo adicional:

- **main.py**: Punto de entrada de la sub-aplicación.
- **router/auth.py**: Endpoints de autenticación.
- **router/reauth.py**: Endpoints de re-autenticación.
- **router/users.py**: Gestión de usuarios.

---

## Despliegue

- Utiliza **Docker** y **Docker Compose** para contenerización y despliegue.
- Configura variables de entorno y credenciales en `config.py` o archivos `.env`.

---

## Requisitos

- Python 3.9+
- FastAPI
- SQLAlchemy
- Uvicorn
- Otros paquetes según los modelos y rutas (ver `requirements.txt`)

---

## Contribución

Sigue la estructura modular para agregar nuevos modelos, rutas o esquemas.  
Asegúrate de documentar y testear tus cambios.

---

## Licencia

Este proyecto está bajo

## Uvicorn

tener el entorno venv para que funcione uvicorn correctamente.

--- Comandos ---

python -m venv venv  <---- crear entorno virtual venv
source venv/bin/activate  # En Linux/Mac
& venv\Scripts\activate.ps1  # En Windows


una vez abierto el venv por primera vez usar 

pip install uvicorn
pip install -r requirements.txt
pip install fastapi <---  instalar fastapi

cuando tengas todo instalado ya podras usar el comando de abajo

uvicorn main:app --reload  <---- comando para abrir el servidor

📝 Documentación: Configuración y Arranque de Backend
Este documento detalla los pasos para instalar y configurar el entorno de desarrollo necesario para la API, incluyendo la base de datos MySQL con XAMPP y el servidor de la API con FastAPI.

Paso 1: Instalación de XAMPP (Servidor Local)
XAMPP es un paquete de software gratuito que instala un servidor web (Apache) y una base de datos (MySQL) en tu computadora.

Descarga XAMPP: Ve al sitio web oficial de Apache Friends y descarga el instalador de XAMPP para tu sistema operativo.

Instala XAMPP: Ejecuta el instalador. Es recomendable usar la configuración por defecto. Asegúrate de que Apache y MySQL estén seleccionados para la instalación.

Paso 2: Iniciar la Base de Datos con XAMPP
Para que tu backend pueda conectarse a la base de datos, el servidor de MySQL debe estar en ejecución.

Abre el Panel de Control de XAMPP: Puedes encontrarlo en el menú de inicio de Windows.

Inicia los módulos: En el panel de control, haz clic en el botón Start (Iniciar) junto a los módulos Apache y MySQL. Una vez que se inicien, el nombre del módulo y el botón se pondrán en verde.

Paso 3: Crear la Base de Datos en phpMyAdmin
Tu código espera una base de datos con un nombre específico, base_de_datos. Debes crearla manualmente.

Abre phpMyAdmin: En el Panel de Control de XAMPP, haz clic en el botón Admin junto al módulo de MySQL. Esto abrirá phpMyAdmin en tu navegador web.

Crea la base de datos: En la página principal de phpMyAdmin, ve a la pestaña Bases de datos. En el campo de texto, escribe base_de_datos y haz clic en el botón Crear.

Paso 4: Configurar la Conexión en la API (FastAPI)
La DATABASE_URL en tu código debe coincidir con la configuración por defecto de XAMPP.

Host: localhost

Usuario: root

Contraseña: No tiene (déjala vacía)

Puerto: 3306

Nombre de la BD: base_de_datos

Tu archivo database.py debe lucir así:

Python

# backend/database.py

DATABASE_URL = "mysql+mysqlconnector://root:@localhost:3306/base_de_datos"
# Si usas PyMySQL, cambia el conector
# DATABASE_URL = "mysql+pymysql://root:@localhost:3306/base_de_datos"
Paso 5: Iniciar el Servidor de FastAPI
Una vez que XAMPP esté corriendo y la base de datos exista, puedes iniciar tu backend.

Abre tu terminal en la carpeta principal de tu proyecto.

Activa tu entorno virtual (venv).

Inicia el servidor: Ejecuta el siguiente comando para arrancar la API.

Bash

uvicorn main:app --reload
Verifica la conexión: Si todo está configurado correctamente, el servidor se iniciará sin errores. La línea Base.metadata.create_all() en tu main.py creará automáticamente las tablas (como la tabla Usuario) dentro de la base de datos base_de_datos.