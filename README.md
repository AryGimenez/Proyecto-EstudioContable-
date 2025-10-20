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
  - Restic (copias de seguridad) <!> Falta configurar en docker-compose.yml
  - Nagios (monitoreo del sistema) <!> Falta configurar de docker-compose.yml

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


### 🧰 Requisitos Previos

- **Docker y Docker Compose instalados**
Necesarios para levantar la infraestructura completa del proyecto (backend, base de datos y herramientas auxiliares).

- **Flutter SDK (versión estable)**
Requerido para compilar y ejecutar el frontend de la aplicación de forma independiente, sin necesidad de levantar la infraestructura con Docker.

- **MySQL 8.0 o superior**
Motor de base de datos utilizado por el proyecto. Puede ejecutarse tanto dentro del contenedor como de forma local.

### Instalación en Windows y Recomendación de Ubuntu

Si usas Windows, instala **Windows Subsystem for Linux (WSL)** para ejecutar herramientas y comandos de desarrollo.  
[Guía oficial de instalación de WSL](https://learn.microsoft.com/es-es/windows/wsl/install)


```bash

# Instalar WSL desde terminal windows agregando Ubuntu instal tambien la distro de Ubuntu que es la que usamos por defecto en nuestro sistema.
wsl --install Ubuntu

```

 **Recomendación:** Por compatibilidad y facilidad de uso, se recomienda trabajar en Ubuntu, que es el entorno principal utilizado en este proyecto.



<!> Aca tengo que agregar lo de zsh cuando lo ordene 




# Instalación de Zsh (Recomendado)

> **Recomendado para trabajar con la terminal de Ubuntu**, tanto en **WSL** como en **host**.  
> Zsh mejora la visualización del código y, junto con sus complementos, permite:
> - Autocompletado inteligente de los últimos comandos utilizados.  
> - Mostrar el estado de la rama Git actual.  
> - Mejorar la productividad en la terminal.

### 🧩 Instalación básica zsh

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

### ⚙️ Mejorar la Terminal (zsh + zwt) 

A continuación se detallan los pasos para instalar y personalizar la terminal usando **Oh My Zsh** y el plugin de autocompletado. Esto es opcional, pero facilita mucho el trabajo diario y mejora la experiencia en la terminal.

#### 1️⃣ Instalar Oh My Zsh
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

#### 2️⃣ Personalizar el Tema de Zsh
- [Lista de temas](https://github.com/ohmyzsh/ohmyzsh/wiki/Themes)

```bash
vim ~/.zshrc
# Buscar la línea ZSH_THEME y modificarla:
ZSH_THEME="agnoster"
```
Sugerencia: agnoster es uno de los temas más usados, muestra información útil sobre Git y la ruta actual.


#### 3️⃣ Instalar Plugin de Autocompletado

```bash
# Crear directorio para el plugin
mkdir -p ~/.zsh/zsh-autosuggestions

# Clonar el repositorio del plugin
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions

# Agregar la siguiente línea al final de ~/.zshrc
echo 'source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh' >> ~/.zshrc
```

#### 4️⃣ Iniciar Zsh

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



# <!> Aca val las recomendaciones de produccion 




# 🧠 Recomendado para producción

## 🧱 Creación del entorno de producción con Docker

### 📁 Estructura recomendada para producción

Para mantener un estándar en entornos de producción, recomendamos crear un directorio base en:
```/home/project```

Dentro de este directorio, se deben vincular los proyectos siguiendo esta estructura:

```bash
sudo ln -s /mnt/c/Users/argi_/Documents/GitHub/Proyecto-EstudioContable- /home/project/Proyecto-EstudioContable-
```


>**Beneficio:**
>Esta estructura facilita la organización, la replicación de entornos y la administración de permisos, evitando conflictos entre proyectos.


### 👥 Estándar de usuarios y permisos

Se recomienda crear un usuario y grupo dedicados para cada proyecto con el fin de mejorar la seguridad y evitar el uso de root en entornos de producción.

**Ejemplo:**

```bash
# Crear grupo del proyecto
sudo groupadd group-project

# Crear usuario asignado al grupo
sudo useradd -m -g group-project user-project
```

### 🔐 Manejo seguro de contraseñas

Guardá la contraseña del usuario fuera del repositorio, por ejemplo:

```bash
echo "tu_password_segura" > ~/user-project.pass
chmod 600 ~/user-project.pass
```
> ⚠️ Importante:
> - No subas contraseñas, llaves o tokens al repositorio.
> - Usá variables de entorno, archivos .env fuera del proyecto o herramientas como Docker Secrets, Vault, o 1Password CLI.

### 💡 Buenas prácticas adicionales

- Nunca ejecutes contenedores o servicios como root.
- Ejecutá los procesos del proyecto con el usuario user-project.
- Documentá los permisos y usuarios definidos en tu espacio de infraestructura o wiki (por ejemplo, en Notion).
- Si querés automatizar este proceso, usá el siguiente script:

```bash
#!/bin/bash
# setup_project_user.sh

# Crear grupo y usuario del proyecto
sudo groupadd -f group-project
sudo id -u user-project &>/dev/null || sudo useradd -m -g group-project user-project

# Crear archivo de contraseña fuera del repo
PASS_FILE=~/user-project.pass
if [ ! -f "$PASS_FILE" ]; then
  echo "Generando contraseña segura..."
  openssl rand -base64 16 > "$PASS_FILE"
  chmod 600 "$PASS_FILE"
  echo "Contraseña almacenada en $PASS_FILE"
fi
```

### ⚙️ Propósito del estándar

Este procedimiento busca:
- Mejorar la seguridad del entorno.
- Asegurar consistencia entre desarrollo y producción.
- Aislar los procesos del sistema principal.

>💬 En resumen:
Aunque en desarrollo no es obligatorio, aplicar este estándar te permitirá replicar condiciones reales de producción y detectar problemas antes del despliegue.




<!> Aca abria que agregar el directoiro de proyecto 



































# Proceso de crear el entorno de desarrollo con docker.

## Recomondacion Produccion 
  Para estandarizar Produccion nosotros por estándar lo que hacemos es crear un directorio en /home/project

y  vinculamos el directorio del proyecto a /home/project/NombreProyecto para seguir un estandar. 

tambien recomendamos crear un usuario  user-project group-project y darle permiso a el proyecto a fin de mantener la seguridad y un estandar para el entorno de produccion

```bash
  sudo ln -s /mnt/c/Users/argi_/Documents/GitHub/Proyecto-EstudioContable- /home/project/Proyecto-EstudioContable-
```



> **Recomendado para entornos de producción:**  
> Implementar esta configuración mejora la **seguridad del proyecto** y evita que los procesos o instrucciones se ejecuten con **permisos de administrador**.  
> De esta forma, si ocurre un error o una instrucción malintencionada, no afectará al sistema principal.  
> *(Opcional, pero altamente recomendable).*


 
 
 # <!> Revisar y mejora con ChatGpt 



## Proceso para crear el entorno de desarrollo con Docker <!> Esto esta repetido para mi no va

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