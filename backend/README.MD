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
venv\Scripts\activate  # En Windows


una vez abierto el venv por primera vez usar 

pip install uvicorn
pip install -r requirements.txt
pip install fastapi <---  instalar fastapi

cuando tengas todo instalado ya podras usar el comando de abajo

uvicorn main:app --reload  <---- comando para abrir el servidor

Patrones de Diseño Utilizados
Para garantizar que el proyecto sea escalable, mantenible y robusto, se han implementado dos patrones de diseño clave: el Patrón Repositorio y el Patrón Façade (Fachada).

Patrón Repositorio 💾
El Patrón Repositorio actúa como una capa de abstracción entre la lógica de negocio de la aplicación y la capa de acceso a datos (en este caso, la base de datos MySQL).

Propósito: Centralizar todas las operaciones CRUD (Crear, Leer, Actualizar, Eliminar) en un solo lugar. Esto significa que las funciones de la API ya no interactúan directamente con la base de datos (db.query), sino que delegan esa responsabilidad al Repositorio.

Beneficios:

Modularidad: Las rutas de la API se mantienen limpias y se enfocan únicamente en manejar peticiones HTTP.

Mantenibilidad: Si en el futuro se cambia la tecnología de la base de datos (por ejemplo, de MySQL a PostgreSQL), solo se necesita modificar el código dentro del Repositorio, sin tocar las rutas de la API.

Reutilización: La lógica de consulta a la base de datos puede ser reutilizada fácilmente en diferentes partes del proyecto.

Patrón Façade (Fachada) 🏛️
El Patrón Façade proporciona una interfaz simplificada para un subsistema complejo. Es especialmente útil para agrupar múltiples operaciones relacionadas en una única llamada, ocultando la complejidad subyacente.

Propósito: Simplificar la interacción del cliente con el sistema. En lugar de que el Cliente tenga que realizar varias llamadas a diferentes repositorios (por ejemplo, ClienteRepository, PagoRepository, ImpuestoRepository) para obtener toda su información, el Façade maneja todo ese proceso internamente.

Beneficios:

Simplificación: El cliente de la API (por ejemplo, la aplicación Flutter) solo necesita hacer una única llamada para obtener toda la información relevante de un cliente, como sus datos personales, pagos e impuestos.

Coherencia: Garantiza que las operaciones complejas siempre se realicen de la misma manera.

Bajo Acoplamiento: Aísla el código del cliente de la API de la complejidad del backend, lo que facilita los cambios futuros.