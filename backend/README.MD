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

(venv) C:\Users\argi\tu-proyecto> deactivate

una vez abierto el venv por primera vez usar 

pip install "uvicorn[standard]"

antes del comando de abajo crear archivos requirements.txt con comando
pip freeze > requirements.txt

despues ejecturar comando 
pip install -r requirements.txt

despues de tener el archivo de arriba ejecutar la instalacion de abajo
pip install fastapi <---  instalar fastapi

cuando tengas todo instalado ya podras usar el comando de abajo

uvicorn main:app --reload  <---- comando para abrir el servidor



# Nombre de tu proyecto

Breve descripción del proyecto: para qué sirve, qué problema resuelve y con qué tecnologías está construido.

---

## 🚀 Puesta en marcha

Sigue estos pasos para tener una copia local de este proyecto en funcionamiento en tu máquina.

### 📋 Requisitos previos

Asegúrate de tener instalados los siguientes programas:

- **Python 3.x**
- **pip** (el gestor de paquetes de Python)
- **Node.js** (si tu frontend lo necesita)
- **Flutter** (para el frontend web)

### ⚙️ Instalación

1.  **Clona el repositorio**:
    ```bash
    git clone [https://github.com/tu-usuario/tu-proyecto.git](https://github.com/tu-usuario/tu-proyecto.git)
    cd tu-proyecto
    ```

2.  **Configura el backend (Python)**:
    -   Crea un entorno virtual:
        ```bash
        python -m venv venv
        ```
    -   Activa el entorno virtual:
        -   En Windows: `venv\Scripts\activate`
        -   En macOS/Linux: `source venv/bin/activate`
    -   Instala las dependencias del backend:
        ```bash
        pip install -r requirements.txt
        ```

3.  **Configura el frontend (Flutter)**:
    -   Navega al directorio del frontend:
        ```bash
        cd frontend/flutter_gestion_contable
        ```
    -   Instala las dependencias de Flutter:
        ```bash
        flutter pub get
        ```
    -   Compila el proyecto para la web:
        ```bash
        flutter build web
        ```

---

## 🖥️ Uso

1.  **Vuelve al directorio principal**:
    ```bash
    cd ../..
    ```
2.  **Inicia el servidor backend**:
    ```bash
    uvicorn main:app --reload
    ```
3.  **Abre la aplicación**:
    -   Una vez que el servidor se esté ejecutando, abre tu navegador y visita `http://127.0.0.1:8000`.

---

## 🧩 Solución de problemas comunes

Aquí tienes un resumen de los errores que puedes encontrar y cómo resolverlos.

### 1. `SyntaxError: Missing parentheses in call to 'print'`

-   **Causa**: Este error ocurre cuando una de las librerías instaladas (como `python-jose`) es una versión antigua que utiliza la sintaxis de Python 2.
-   **Solución**: Desinstala y reinstala la librería para obtener la versión correcta compatible con Python 3.
    ```bash
    pip uninstall python-jose
    pip install "python-jose[cryptography]"
    ```

### 2. `RuntimeError: Directory 'frontend/flutter_gestion_contable/build/web' does not exist`

-   **Causa**: El servidor de Uvicorn no puede encontrar los archivos del frontend porque no han sido generados.
-   **Solución**: Asegúrate de haber ejecutado el comando `flutter build web` en el directorio correcto (`frontend/flutter_gestion_contable`) antes de iniciar el servidor.

---

## 👥 Colaboración

Si quieres contribuir a este proyecto, sigue estos pasos:

1.  Haz un "Fork" del proyecto.
2.  Crea tu rama de función (`git checkout -b feature/MiCaracteristicaGenial`).
3.  Haz tus "commits" (`git commit -m 'Añadir nueva característica'`).
4.  Sube tu rama (`git push origin feature/MiCaracteristicaGenial`).
5.  Abre un "Pull Request".

---

## 🛡️ Licencia

Este proyecto está bajo la Licencia MIT.


