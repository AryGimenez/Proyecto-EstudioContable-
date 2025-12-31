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


### Estandarización de Proyectos y Usuarios

Este estándar se aplica tanto en Ubuntu como en Windows (usando WSL):

```bash
# Crear directorio de proyectos en el home
mkdir ~/Proyect

# Crear usuario y grupo para proyectos (ejecutar como root)
sudo groupadd group-proyect
sudo useradd -m -g group-proyect user-proyect

# Guardar la contraseña en un archivo fuera del repositorio
echo "tu_password_segura" > ~/user-proyect.pass
chmod 600 ~/user-proyect.pass
```
> **Nota:** No subas archivos de contraseñas al repositorio. Mantén la información sensible fuera de la estructura del proyecto.
---

### Mejorar la Terminal (zsh + zwt)

A continuación se detallan los pasos para instalar y personalizar la terminal usando **Oh My Zsh** y el plugin de autocompletado. Esto es opcional, pero facilita mucho el trabajo diario y mejora la experiencia en la terminal.

#### 1. Instalar Oh My Zsh
- [Web Oficial](https://ohmyz.sh/)
- [Guía GeekyTheory](https://geekytheory.com/como-instalar-oh-my-zsh-en-ubuntu)

```bash
sudo apt-get update
sudo apt-get install zsh git-core

# Instalar Oh My Zsh
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh

# Cambiar shell por defecto a zsh
chsh -s $(which zsh)
```

#### 2. Personalizar el Tema de Zsh
- [Lista de temas](https://github.com/ohmyzsh/ohmyzsh/wiki/Themes)

```bash
vim ~/.zshrc
# Buscar la línea ZSH_THEME y modificarla:
ZSH_THEME="agnoster"
```

#### 3. Instalar Plugin de Autocompletado

```bash
# Crear directorio para el plugin
mkdir -p ~/.zsh/zsh-autosuggestions

# Clonar el repositorio del plugin
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions

# Agregar la siguiente línea al final de ~/.zshrc
echo 'source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh' >> ~/.zshrc
```

#### 4. Iniciar Zsh

```rbash
zsh
```

> **Tip:** Una vez configurado, cada vez que abras WSL tendrás la terminal personalizada y autocompletada.  
> Puedes consultar la documentación oficial de cada herramienta para más detalles

---


### Instalación de Docker y Docker Compose en Ubuntu/WSL

A continuación se detallan los pasos recomendados para instalar Docker y Docker Compose en Ubuntu, tanto para desarrollo como para producción.  
Consulta la [documentación oficial de Docker](https://docs.docker.com/engine/install/ubuntu/) y [Docker Compose](https://docs.docker.com/compose/install/) para más detalles.

#### 1. Eliminar versiones anteriores de Docker

```bash
sudo apt-get remove docker docker-engine docker.io containerd runc
```

#### 2. Instalar dependencias necesarias

```bash
sudo apt-get update

sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
```

> Puedes usar `apt` o `apt-get`. Ambos funcionan, pero `apt-get` es el comando clásico y recomendado para scripts.

#### 3. Agregar la clave GPG oficial de Docker

```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
```

#### 4. Agregar el repositorio de Docker

```bash
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

#### 5. Instalar Docker Engine

```bash
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io
# Si prefieres evitar paquetes recomendados (opcional):
# sudo apt-get install --no-install-recommends docker-ce docker-ce-cli containerd.io
```

#### 6. Instalar Docker Compose

```bash
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
```

#### 7. Verificar la instalación de Docker Compose

```bash
docker-compose --version
```

---

> Estos pasos aseguran una instalación limpia y funcional de Docker y Docker Compose en


























## Proceso de crear el entorno de desarrollo con docker.

Nosotros por estándar lo que hacemos es crear un directorio en /home/project

y  vinculamos el directorio del proyecto a /home/project/NombreProyecto para seguir un estandar. 

tambien recomendamos crear un usuario  user-project group-project y darle permiso a el proyecto a fin de mantener la seguridad y un estandar para el entorno de produccion

```bash
  sudo ln -s /mnt/c/Users/argi_/Documents/GitHub/Proyecto-EstudioContable- /home/project/Proyecto-EstudioContable-
```

## Proceso para crear el entorno de desarrollo con Docker

Por estándar, recomendamos organizar todos los proyectos en el directorio `/home/project` en el entorno de desarrollo y producción. Esto facilita la administración, el despliegue y el mantenimiento de los proyectos.

Para mantener la seguridad y seguir buenas prácticas, sugerimos crear un usuario y un grupo específicos para cada proyecto. De esta forma, los archivos y procesos del proyecto estarán aislados y protegidos de otros usuarios del sistema.

### Pasos recomendados

1. **Crear el directorio estándar para proyectos, lo hacemos como administrador porque necesitamos permisos elevados en el directorio /home:**
   ```bash
   sudo mkdir -p /home/project \
   ```

2. **Crear un usuario y grupo para el proyecto:**
   ```bash
   sudo groupadd group-project
   sudo useradd -m -g group-project user-project
   ```

3. **Corroborar que el usuario y grupo se crearon correctamente:**
```bash
   id user-project

   # te va a dar un resultado como este
   uid=1001(user-project) gid=1001(group-project) groups=1001(group-project)
```

   > Es correcto y recomendable crear un usuario y grupo dedicados para cada proyecto, ya que esto mejora la seguridad y facilita la gestión de permisos en el servidor.

3. **Dar permisos al usuario y grupo sobre el directorio del proyecto:**
   ```bash
   sudo chown -R user-project:group-project /home/project/NombreProyecto
   ```

4. **Vincular el directorio del proyecto (por ejemplo, desde WSL) al estándar suele pedir perisos por lo que debes ejecutarlo como root:**
   ```bash
   sudo ln -s /mnt/c/Users/argi_/Documents/GitHub/Proyecto-Estudiocontabler- /home/project/Proyecto-Estudiocontabler-
   ```

5. **Dar permisos al usuario y grupo sobre el directorio del proyecto:**
   ```bash
   sudo chown -R user-project:group-project /home/project/Proyecto-Estudiocontabler-
   ```



/mnt/c/Users/argi_/Documents/GitHub/Proyecto-EstudioContable-
/mnt/c/Users/argi_/Documents/GitHub/Proyecto-Estudiocontabler-





---

**Ventajas de esta organización:**
- Permite estandarizar la estructura en todos los servidores y entornos de desarrollo.
- Facilita el control de acceso y la administración de permisos.
- Mejora la seguridad al aislar los archivos y






























### Proceso de Instalación del Proyecto

```bash
# 1. Clonar repositorio
git clone https://github.com/tu-usuario/apa-sa-sistema.git
cd apa-sa-sistema

# 2. Iniciar contenedores
docker-compose up -d --build

# 3. Configurar base de datos
docker exec -it api python manage.py migrate

# 4. Iniciar aplicación Flutter
```