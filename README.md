<<<<<<< HEAD
# Sistema de Gestión de Pagos para Estudio Contable

## Descripción
Este sistema informático está diseñado para gestionar y controlar los pagos de diversos servicios e impuestos que un estudio contable administra para sus clientes. Incluye la generación de alertas y notificaciones automáticas para garantizar el cumplimiento de pagos a tiempo.

## Tecnologías Utilizadas
- **Flutter**: Para el desarrollo de la aplicación web y móvil con un solo código base.
- **FastAPI**: Para la gestión de la lógica del sistema y el envío de alertas.
- **MySQL**: Base de datos para almacenar toda la información del sistema.
- **Docker**: Para la gestión eficiente de los servicios del sistema.
- **Nginx**: Manejo de la comunicación entre los usuarios y el sistema.
- **Restic**: Para la realización de copias de seguridad de la base de datos.
- **Nagios**: Para la monitorización y aseguramiento del correcto funcionamiento del sistema.

## Características Principales
### Registro de Clientes
- Nombre, fecha de nacimiento, dirección y datos de contacto.
- Registro de número de WhatsApp para envío de notificaciones automáticas.

### Gestión de Impuestos y Pagos
- Registro de diferentes impuestos (BPS, DGI, cable, otros servicios).
- Definición de fechas de vencimiento y montos a pagar.
- Configuración de impuestos como montos fijos o recurrentes mensuales.
- Posibilidad de agregar subcategorías de impuestos y calcular el monto total.
- Generación de alertas automáticas antes de la fecha de vencimiento.
- Asignación automática de honorarios con posibilidad de ajuste manual.

### Generación de Alertas
- Notificaciones push en dispositivos móviles.
- Alertas en la interfaz web al iniciar sesión.
- Notificaciones automáticas por WhatsApp sobre pagos pendientes.

### Funcionalidades de Usuarios
#### Ingreso al Sistema
- Autenticación con usuario y contraseña.
- Recuperación de contraseña con envío de código por WhatsApp.
- Sesión persistente en móvil y autenticación rápida en la web.

#### Roles de Usuario
**Contadores:**
- Pueden gestionar y visualizar información de clientes.
- No pueden eliminar clientes ni dar de baja deudas sin autorización.
- Solicitud de baja de deudas a través del sistema.

**Propietaria:**
- Acceso completo al sistema.
- Puede dar de baja clientes (archivado de información en lugar de eliminación permanente).
- Aprobación de bajas de deudas.
- Creación y gestión de usuarios contadores.

### Contabilidad
- **Cuenta de Honorarios Prestados:** Registra ingresos por honorarios y gastos operativos.
- **Cuenta de Impuestos:** Registra los montos transferidos para el pago de impuestos.

### Listados
- Listado total de clientes.
- Clientes con atrasos o deudas.
- Impuestos a pagar en un período dado.
- Impuestos de un cliente específico (con o sin subcategorías).
- Resumen de contabilidad mensual (ingresos y gastos).

## Instalación y Configuración
### Requisitos
- Docker y Docker Compose instalados.
- Flutter configurado en el entorno de desarrollo.
- FastAPI y MySQL en contenedores.

### Instalación
1. Clonar el repositorio:
   ```sh
   git clone https://github.com/tuusuario/sistema-pagos-estudio.git
   cd sistema-pagos-estudio
   ```
2. Iniciar los contenedores con Docker Compose:
   ```sh
   docker-compose up -d
   ```
3. Configurar la base de datos:
   ```sh
   docker exec -it mysql-container mysql -u root -p < scripts/setup.sql
   ```
4. Iniciar la aplicación:
   ```sh
   flutter run
   ```

## Contacto
Si tienes alguna duda o sugerencia, puedes abrir un issue en el repositorio.
=======
# Proyecto-EstudioContable-
Sistema para gestionar pagos, impuestos y contabilidad en estudios contables. Incluye registro de clientes, alertas automáticas (push y WhatsApp), listados de deudas e impuestos, y gestión financiera. Tecnologías: Flutter, FastAPI, MySQL, Docker, Nginx, Nagi



# Sistema de Gestión de Pagos y Alertas - APA.SA

## Descripción del Proyecto

Este proyecto tiene como objetivo desarrollar un sistema informático para la gestión y control de pagos de impuestos y servicios ofrecidos por APA.SA. El sistema permitirá el registro de clientes, la gestión de impuestos y pagos, la generación de alertas automáticas, y la administración de usuarios con diferentes niveles de permisos. Además, incluirá funcionalidades de contabilidad para gestionar ingresos y gastos de la empresa.

## Características Principales

### Registro de Clientes
- **Nombre**
- **Fecha de nacimiento** (para mensajes de cumpleaños automáticos vía WhatsApp)
- **Dirección**
- **Datos de contacto**
- **WhatsApp** (para notificaciones automáticas)

### Gestión de Impuestos y Pagos
- **Registro de impuestos** (BPS, DGI, Cable, otros servicios)
  - Nombre del impuesto
  - Fecha de vencimiento
  - Monto a pagar
  - Frecuencia (mensual o monto fijo)
  - Subcategorías de impuestos (ej: DGI)
  - Cálculo automático del monto total
- **Asignación de honorarios** (con recordatorio del último monto asignado)

### Generación de Alertas
- **Notificaciones Push** en dispositivos móviles
- **Alertas en la interfaz web** al iniciar sesión
- **Notificaciones por WhatsApp** para pagos pendientes

### Funcionalidades de Usuarios
- **Ingreso al Sistema**
  - Versión Web: Inicio de sesión con credenciales, con opción de recordar sesión
  - Versión Móvil: Sesión persistente hasta cierre manual
  - Restablecimiento de contraseña vía WhatsApp
- **Roles de Usuarios**
  - **Contadores**: Gestión de clientes, modificación de datos de pago, solicitud de baja de deuda
  - **Propietaria**: Acceso completo, baja de clientes (archivado), autorización de baja de deuda, alta de nuevos contadores

### Contabilidad
- **Cuenta de Honorarios Prestados**: Ingresos por honorarios y gastos operativos
- **Cuenta de Impuestos**: Montos transferidos por clientes para pagos de impuestos

### Listados
- **Listado Total de Clientes**: Búsqueda por nombre o apellido
- **Listado de Clientes con Atrasos o Deudas**
- **Listado de Impuestos a Pagar en un Período Dado**
- **Listado de Impuestos de un Cliente Específico** (detallado o genérico)
- **Listado de la Contabilidad del Estudio**: Honorarios y gastos mensuales

## Tecnologías Utilizadas

- **Flutter**: Desarrollo de la interfaz web y móvil
- **FastAPI**: Lógica del sistema y gestión de alertas
- **MySQL**: Base de datos para almacenamiento de información
- **Docker**: Organización y despliegue de componentes
- **Nginx**: Manejo de comunicación entre el sistema y los usuarios
- **Restic**: Copias de seguridad de la base de datos
- **Nagios**: Monitoreo del sistema

## Plazo de Entrega

El proyecto tendrá una duración estimada de **60 a 90 días** (2 a 3 meses). La entrega se realizará en etapas:

1. **Primera Etapa**: Diseño de la interfaz y ajustes visuales.
2. **Etapas Posteriores**: Implementación funcional y pruebas.

## Instalación y Configuración

### Requisitos Previos
- Docker instalado
- MySQL configurado
- Flutter SDK instalado

### Pasos para la Instalación

1. **Clonar el Repositorio**:
   ```bash
   git clone https://github.com/tu-usuario/apa-sa-sistema.git
   cd apa-sa-sistema
>>>>>>> 50deb308c23ec6082abc17746072facc08c3f25b
