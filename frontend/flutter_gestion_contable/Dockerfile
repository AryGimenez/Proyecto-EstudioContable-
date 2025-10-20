# frontend/flutter_gestion_contable/Dockerfile

# ----------------------------------------------------
# 1. Etapa de Compilación: Usamos una imagen que ya tiene Flutter
# ----------------------------------------------------
FROM cirrusci/flutter:stable AS build

# Configurar el entorno (si se necesita una versión específica, aunque 'stable' es lo estándar)
# RUN flutter channel stable
# RUN flutter upgrade
RUN flutter config --enable-web

WORKDIR /app

# 1. Optimización: Copiar solo los archivos de dependencia para cachear pub get
COPY pubspec.yaml pubspec.lock /app/
RUN flutter pub get

# 2. Copiar el resto del código
COPY . .

# 3. Compilar para web
RUN flutter build web --release

# ----------------------------------------------------
# 2. Etapa de Producción: Servidor ligero Nginx
# ----------------------------------------------------
FROM nginx:alpine

# Copiar configuración de Nginx (Opcional, pero recomendado para Flutter Web)
# Esto asegura que Nginx maneje correctamente el ruteo de URLs (deep linking)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copiar los archivos compilados desde la etapa 'build'
COPY --from=build /app/build/web /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]