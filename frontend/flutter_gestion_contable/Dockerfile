# Etapa de compilación
FROM ubuntu:20.04 AS build

# Evitar interacciones durante la instalación
ENV DEBIAN_FRONTEND=noninteractive

# Instalar dependencias
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    libglu1-mesa \
    && rm -rf /var/lib/apt/lists/*

# Instalar Flutter
RUN git clone https://github.com/flutter/flutter.git /flutter
ENV PATH="/flutter/bin:${PATH}"
RUN flutter channel stable
RUN flutter upgrade
RUN flutter config --enable-web

# Copiar el código fuente
WORKDIR /app
COPY . .

# Obtener dependencias y compilar para web
RUN flutter pub get
RUN flutter build web --release

# Etapa de producción
FROM nginx:alpine

# Copiar los archivos compilados a Nginx
COPY --from=build /app/build/web /usr/share/nginx/html

# Exponer el puerto
EXPOSE 80

# Iniciar Nginx
CMD ["nginx", "-g", "daemon off;"]