# Backend - Proyecto Estudio Contable

# Estructura Completa del Backend

# 1. Organización de Directorios
El backend está organizado en una estructura modular siguiendo buenas prácticas de desarrollo:

```bash
    backend/
    ├── Archivos de Configuración Principal
    │   ├── main.py            # Punto de entrada de la aplicación
    │   ├── config.py          # Configuraciones y variables de entorno
    │   ├── database.py        # Configuración de la base de datos
    │   ├── dependencies.py    # Dependencias e inyección de dependencias
    │   ├── security.py        # Funciones de seguridad y autenticación
    │   └── utils.py           # Utilidades generales
    │
    ├── models/                         # Modelos de datos (SQLAlchemy)
    │   ├── cliente.py                  # Modelos datos de clientes
    │   ├── deposito.py                 # Modelo de depósitos
    │   ├── impuesto.py                 # Modelo de impuestos
    │   ├── nombre_impuesto.py          # Modelo de nombres de impuestos
    │   ├── notificacion.py             # Modelo de notificaciones
    │   ├── pago.py                     # Modelo de pagos
    │   ├── password_reset_request.py   # Modelo de solicitudes de restablecimiento de contraseña
    │   └── user.py                     # Modelo de usuarios
    │
    ├── schemas/                    # Esquemas Pydantic para validación
    │   ├── auth.py                 # Esquema Pydantic de autenticación
    │   ├── cliente.py              # Esquema Pydantic para clientes
    │   ├── config.py               # Esquema Pydantic para configuración
    │   ├── deposito.py             # Esquema Pydantic para depósitos
    │   ├── impuesto.py             # Esquema Pydantic para impuestos
    │   ├── nombre_impuesto.py      # Esquema Pydantic para nombres de impuestos
    │   ├── notificacion.py         # Esquema Pydantic para notificaciones
    │   ├── pago.py                 # Esquema Pydantic para pagos
    │   ├── token.py                # Esquema Pydantic para tokens
    │   └── user.py                 # Esquema Pydantic para usuarios
    │
    ├── router/                     # Endpoints de la API
    │   ├── auth.py                 # Rutas de autenticación
    │   ├── clientes.py             # Rutas para gestión de clientes
    │   ├── depositos.py            # Rutas para gestión de depósitos
    │   ├── impuestos.py            # Rutas para gestión de impuestos
    │   ├── nombre_impuesto.py      # Rutas para gestión de nombres de impuestos
    │   ├── notificaciones.py       # Rutas para gestión de notificaciones
    │   ├── pagos.py                # Rutas para gestión de pagos
    │   └── users.py                # Rutas para gestión de usuarios
    │
    ├── repositorios/                       # Capa de acceso a datos
    │   ├── clientes_repository.py          # Repositorio para clientes
    │   ├── deposito_repository.py          # Repositorio para depósitos
    │   ├── impuesto_repository.py          # Repositorio para impuestos
    │   ├── nombre_impuesto_repository.py   # Repositorio para nombres de impuestos
    │   ├── notification_repository.py      # Repositorio para notificaciones
    │   ├── pago_repository.py              # Repositorio para pagos
    │   └── usuario_repository.py           # Repositorio para usuarios
    │
    ├── services/                       # Servicios de la aplicación
    │   ├── scheduler_service.py        # Servicio para tareas programadas
    │   ├── websocket_manager.py        # Servicio para gestionar conexiones WebSocket
    │   └── whatsapp_service.py         # Servicio para enviar notificaciones por WhatsApp
    │
    └── Archivos de Despliegue
        ├── requirements.txt
        ├── dockerfile
        └── docker-compose.yml

```



# 2. Componentes Principales


# Configuración y Arranque
- main.py : Punto de entrada que configura FastAPI, CORS, routers y el scheduler de notificaciones
- config.py : Variables de configuración como claves secretas, configuración de email, etc.
- database.py : Configuración de SQLAlchemy y conexión a la base de datos
- dependencies.py : Funciones para inyección de dependencias en los endpoints


# Modelos de Datos
Definen la estructura de la base de datos usando SQLAlchemy ORM:

- cliente.py : Modelo para clientes del estudio contable
- impuesto.py : Modelo para impuestos a pagar
- pago.py : Modelo para registrar pagos realizados
- deposito.py : Modelo para depósitos o transferencias
- nombre_impuesto.py : Catálogo de tipos de impuestos
- notificacion.py : Sistema de notificaciones
- user.py : Usuarios del sistema


# Schemas (Pydantic)
Definen la validación de datos para las API:

- Cada schema corresponde a un modelo y define cómo se validan los datos de entrada/salida
- Incluye schemas para autenticación, tokens y configuración


# Routers
Definen los endpoints de la API REST:

- Cada router maneja un recurso específico (clientes, impuestos, etc.)
- auth.py : Endpoints para autenticación y gestión de sesiones


# Repositorios
Implementan el patrón repositorio para acceso a datos:

- Cada repositorio encapsula las operaciones CRUD para un modelo específico
- Separa la lógica de acceso a datos de la lógica de negocio


# Servicios
Implementan lógica de negocio compleja:

- scheduler_service.py : Servicio para verificar vencimientos y generar notificaciones
- websocket_manager.py : Gestión de conexiones WebSocket para notificaciones en tiempo real
- whatsapp_service.py : Integración con WhatsApp para envío de notificaciones


# Despliegue
- requirements.txt : Dependencias del proyecto
- dockerfile y docker-compose.yml : Configuración para despliegue con Docker


# 3. Flujo de Datos
1. 1.
   Las peticiones HTTP llegan a los routers
2. 2.
   Los routers utilizan schemas para validar los datos de entrada
3. 3.
   Los routers llaman a los repositorios para acceder a la base de datos
4. 4.
   Los repositorios utilizan los modelos para interactuar con la base de datos
5. 5.
   Los servicios implementan lógica de negocio compleja (notificaciones, programación de tareas)
6. 6.

Los datos validados se devuelven como respuesta HTTP
Esta arquitectura sigue el patrón de diseño de capas, separando claramente las responsabilidades y facilitando el mantenimiento y la escalabilidad del sistema.



# Guía de Instalación Paso a Paso para el Backend


# Requisitos Previos
- Python 3.10 o superior
- Acceso a la línea de comandos (PowerShell o CMD en Windows)
- Git (para clonar el repositorio)


# Paso 1: Preparar el Entorno Virtual

1. 1.
   Abre una terminal (PowerShell o CMD) en la carpeta raíz del proyecto:
   
   ``` 
    cd 
    c:\Users\silva\Documents\GitHub\Proyecto-EstudioContable-
    ```


2. 2.
   Crea un entorno virtual:
   
   ```
   python -m venv venv
   ```

3. 3.
   Activa el entorno virtual:
   
   - En Windows (PowerShell):
     ```
     .\venv\Scripts\Activate.ps1
     ```
   - En Windows (CMD):
     ```
     venv\Scripts\activate.bat
     ```

## Paso 2: Instalar Dependencias

1. 1.
Asegúrate de que el entorno virtual está activado (verás (venv) al inicio de la línea de comandos)

2. 2.
Instala todas las dependencias del archivo requirements.txt:

```
pip install -r backend\requirements.txt
Esto instalará:
```
    FastAPI: Framework web para crear APIs
    SQLAlchemy: ORM para interactuar con la base de datos
    Uvicorn: Servidor ASGI para ejecutar la aplicación
    Pydantic: Para validación de datos
    Otras dependencias necesarias


# Paso 3: Configuraciones Adicionales

1. 1.
Configura las variables de entorno en el archivo backend/config.py:

Actualiza SECRET_KEY con una clave segura
Configura los datos de correo electrónico si vas a usar notificaciones por email

2. 2.
Asegúrate de que la base de datos esté configurada correctamente en backend/database.py

Paso 4: Iniciar el Backend
1. 1.
Desde la carpeta raíz del proyecto, con el entorno virtual activado, ejecuta:

```
cd backend
uvicorn main:app --reload
```
2. 2.
El servidor se iniciará en http://127.0.0.1:8000

3. 3.
Puedes acceder a la documentación automática de la API en:

Swagger UI: http://127.0.0.1:8000/docs
ReDoc: http://127.0.0.1:8000/redoc
Solución de Problemas Comunes

1. 1.
Error de importación de módulos:

Asegúrate de que estás ejecutando el servidor desde la carpeta correcta
Verifica que el entorno virtual esté activado

2. 2.
Error de conexión a la base de datos:

Revisa la configuración en database.py
Asegúrate de que la base de datos existe y es accesible

3. 3.
Error con las dependencias:

Si hay conflictos, intenta: pip install -r backend\requirements.txt --force-reinstall

4. 4.
Problemas con el scheduler:

Verifica que APScheduler esté correctamente instalado
Revisa los logs para identificar errores específicos
Esta guía te permitirá configurar y ejecutar el backend del sistema de gestión contable. Si encuentras algún problema específico durante la instalación, revisa los mensajes de error para obtener más detalles.