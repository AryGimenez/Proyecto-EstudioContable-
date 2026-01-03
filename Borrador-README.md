

## -->ARY <Mejorar-ChatGPT> --- Agrear una seccion para instalar terminal con gatchet que uso yo uso zwt 



## -- Verson ChatGPT -- Corregir 

### Instalación en Windows

Si usas Windows, instala **Windows Subsystem for Linux (WSL)** para facilitar la ejecución de comandos y herramientas de desarrollo.  
[Guía oficial de instalación de WSL](https://learn.microsoft.com/es-es/windows/wsl/install)

### Instalación de Terminal Personalizada (zwt)

Para una terminal avanzada y personalizada, puedes instalar [zwt](https://github.com/your-gatchet/zwt) siguiendo estos pasos:


### Proceso de Instalación
```bash
# 1. Clonar repositorio
git clone https://github.com/tu-usuario/apa-sa-sistema.git
cd apa-sa-sistema

# 2. Iniciar contenedores
docker-compose up -d --build

# 3. Configurar base de datos
docker exec -it api python manage.py migrate

# 4. Iniciar aplicación Flutter
flutter run
```

### ---- Fit Edicion------









<!> Esto creo que esta repetido 

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