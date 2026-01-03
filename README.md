# Sistema de Gestión de Pagos y Alertas - APA.SA

## Descripción
Sistema integral para gestión de pagos de impuestos y servicios en estudios contables. Permite registro de clientes, control de pagos, generación de alertas automáticas y administración de usuarios con diferentes niveles de permisos. Incluye módulos de contabilidad para seguimiento de ingresos y gastos.

## Tecnologías Utilizadas
- **Frontend**: Flutter (Para <!> En esta version por un tema de seguridad para la clita )
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

### Instalación en Windows y Recomendación de Ubuntu

Si usas Windows, instala **Windows Subsystem for Linux (WSL)** para ejecutar herramientas y comandos de desarrollo.  
[Guía oficial de instalación de WSL](https://learn.microsoft.com/es-es/windows/wsl/install)


```bash

# Instalar WSL desde terminal windows agregando Ubuntu instal tambien la distro de Ubuntu que es la que usamos por defecto en nuestro sistema.
wsl --install Ubuntu

```

 **Recomendación:** Por compatibilidad y facilidad de uso, se recomienda trabajar en Ubuntu, que es el entorno principal utilizado en este proyecto.

# Instalacion del Zsh

```bash
# Instalar Zsh
sudo apt-get install zsh

# Cambiar el shell por defecto a Zsh
chsh -s $(which zsh)

# Instalar Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Reiniciar la terminal
exec zsh
```


# Personalización del Tema en Zsh

Para cambiar el tema por defecto en Oh My Zsh y aprovechar las ventajas visuales (estado de ramas, ruta actual, etc.), edita el archivo de configuración:

```bash
vim ~/.zshrc
```

Busca la línea que contiene `ZSH_THEME` y modifícala para usar el tema **agnoster**:

```bash
ZSH_THEME="agnoster"
```

Guarda los cambios y reinicia la terminal con:

```bash
zsh
```

> El tema **agnoster** muestra el estado de las ramas de git y la ruta actual, lo que facilita el trabajo diario.  
> Puedes consultar [otros temas disponibles](https://github.com/ohmyzsh/ohmyzsh/wiki/Themes) para personalizar aún más

# Instalar plug-in para autocompletar en zsh

```bash
mkdir ~/.zsh
mkdir ~/.zsh/zsh-autosuggestions # Crear el directorio
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
vim ~/.zshrc #modificar directorio de configuracion
        source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh # agregar linia
```

Te dejo a cahtgpt el critero para todo esto el orden segun sea mas claro para la docuemtacion  una ves terminado  todo solo tengo que iniciar zsh y ya esta lo que estaria gueno es que se iniciara solo 

cuando ejecuto wsl 


Bueno haora nos toca instalr docker. 
Yo te voy a pasar unos comandos que he usado y me funcionan. 

### Instalacion 






<!> Lo siguiente voy a arreglarlo

## 🚀 Infrastructura de proyecto 

Para usar este proyecto más fácilmente, creamos un entorno con Docker y Docker Compose. Los Dockerfiles están en los directorios de frontend y backend respectivamente, pero se llaman a través de Docker Compose ubicado en la raíz del sistema.


```dart
/
├── frontend/
│   └── flutter_gestion_contable/ // Proyecto Flutter para la gestión contable
│       ├── ...
│       └── dockerfile // Dockerfile para construir la imagen del frontend
├── backend/
│   ├── ... // Código del backend con FastAPI
└── └── dockerfile // Dockerfile para construir la imagen del backend
└── docker-compose.yml // Archivo Docker Compose para orquestar los servicios
```

**Levantar servicios:**
```bash
sudo docker-compose -p estudio_contable up -d db
sudo docker-compose -p estudio_contable up --build backend
```
