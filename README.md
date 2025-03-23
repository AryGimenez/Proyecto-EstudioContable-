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
