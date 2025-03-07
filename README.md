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