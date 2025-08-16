# Sistema de Gestión de Pagos y Alertas - APA.SA

## Descripción
Sistema integral para gestión de pagos de impuestos y servicios en estudios contables. Permite registro de clientes, control de pagos, generación de alertas automáticas y administración de usuarios con diferentes niveles de permisos. Incluye módulos de contabilidad para seguimiento de ingresos y gastos.

## Tecnologías Utilizadas
- **Frontend**: Flutter (aplicación web y móvil)
- **Backend**: FastAPI (lógica del sistema)
- **Base de Datos**: MySQL
- **Infraestructura**: 
  - Docker (gestión de contenedores)
  - Nginx (servidor web/reverse proxy)
  - Restic (copias de seguridad)
  - Nagios (monitoreo del sistema)

## Características Principales

### 👥 Registro de Clientes
- Nombre completo y datos de contacto
- Fecha de nacimiento (envío automático de felicitaciones por WhatsApp)
- Dirección física
- Número de WhatsApp para notificaciones

### 💰 Gestión de Impuestos y Pagos
- Registro de diversos impuestos (BPS, DGI, servicios)
- Configuración de:
  - Fechas de vencimiento
  - Montos fijos o recurrentes
  - Subcategorías de impuestos
- Cálculo automático de montos totales
- Asignación de honorarios (con memoria del último monto)

### 🔔 Sistema de Alertas
- Notificaciones Push en dispositivos móviles
- Alertas en interfaz web al iniciar sesión
- Notificaciones automáticas por WhatsApp:
  - Recordatorios de pagos pendientes
  - Mensajes de cumpleaños automáticos

### 👤 Gestión de Usuarios y Roles
| Rol          | Permisos                                                                 |
|--------------|--------------------------------------------------------------------------|
| **Contador** | - Gestión de clientes<br>- Modificación de datos de pago<br>- Solicitud de baja de deudas |
| **Propietario** | - Acceso completo<br>- Baja de clientes (archivado)<br>- Autorización de bajas de deudas<br>- Creación de usuarios |

### 📊 Módulo Contable
- **Cuenta de Honorarios**: Registro de ingresos por honorarios y gastos operativos
- **Cuenta de Impuestos**: Seguimiento de montos transferidos para pagos
- Generación de reportes mensuales

### 📋 Listados y Reportes
1. Listado completo de clientes (búsqueda por nombre/apellido)
2. Clientes con atrasos o deudas pendientes
3. Impuestos a pagar en período específico
4. Detalle de impuestos por cliente
5. Resumen contable mensual (ingresos vs gastos)

## Instalación y Configuración

### Requisitos Previos
- Docker y Docker Compose instalados
- Flutter SDK (versión estable)
- MySQL 8.0+

### -->ARY <Mejorar-ChatGPT> --- En caso de usar Windowus instalar WSL

## -->ARY <Mejorar-ChatGPT> --- Agrear una seccion para instalar terminal con gatchet que uso yo uso zwt 



## -- Version ChatGPT -- Corregir 

### Instalación en Windows

Si usas Windows, instala **Windows Subsystem for Linux (WSL)** para facilitar la ejecución de comandos y herramientas de desarrollo.  
[Guía oficial de instalación de WSL](https://learn.microsoft.com/es-es/windows/wsl/install)

### Instalación de Terminal Personalizada (zwt)

Para una terminal avanzada y personalizada, puedes instalar [zwt](https://github.com/your-gatchet/zwt) siguiendo estos pasos:


### Proceso de Instalación
```bash
# 1. Clonar repositorio
git clone https://github.com/tu-usuario/apa-sa-sistema.git  #Usar el repositorio correspondiente
cd apa-sa-sistema

# 2. Iniciar contenedores
docker-compose up -d --build

# 3. Configurar base de datos
docker exec -it api python manage.py migrate

# 4. Iniciar aplicación Flutter
flutter run
```

### ---- Fit Edicion------
