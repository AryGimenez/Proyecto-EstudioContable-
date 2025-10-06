

# Estructura general de proyecto 
Para cada componente o interfas vamos a generar esta estructura.

Vamos a usar una estructura de proyecto bien organizada y separada. La idea es tener: 

- **Archivos que terminen en "Styles"**: Contendrán los estilos de la aplicación. 
- **Archivos que terminen en "Screen"**: Serán utilizados para lanzar las diferentes pantallas de la aplicación. 
- **Archivos que terminen en "Form"**: Contendrán el contenido de los formularios.

### Beneficios de esta Estructura

1. **Organización Clara**: Separación lógica de componentes y funcionalidades
2. **Mantenibilidad**: Facilita la localización y modificación de código
3. **Escalabilidad**: Permite añadir nuevos módulos manteniendo la coherencia
4. **Reutilización**: Promueve la creación de componentes reutilizables
5. **Consistencia**: Mantiene un estilo uniforme en toda la aplicación

---------------------------------------------------------------------


# Documentación para Levantar el Entorno de Flutter

## Requisitos Previos

- Tener instalado [Flutter SDK](https://docs.flutter.dev/get-started/install)
- Tener instalado [Android Studio](https://developer.android.com/studio) o [Visual Studio Code](https://code.visualstudio.com/) con el plugin de Flutter
- Tener configurado un emulador Android/iOS o un dispositivo físico

---

## Pasos para Configurar el Entorno

### 1. Clonar el repositorio

```bash
cd Proyecto-EstudioContable-/frontend/flutter_gestion_contable
```

### 2. Instalar dependencias

Ejecuta en la terminal dentro de la carpeta del proyecto Flutter:

```bash
flutter pub get
```

### 3. Verificar configuración

Comprueba que no haya errores en el archivo `pubspec.yaml` y que todas las dependencias se hayan instalado correctamente.

### 4. Ejecutar la aplicación

Para correr la app en un emulador o dispositivo conectado:

```bash
flutter run
```

### 5. Compilar para web (opcional)

Si quieres levantar la app en modo web:

```bash
flutter run -d chrome
```



---

## Notas

- Si agregas nuevas dependencias, recuerda ejecutar `flutter pub get` nuevamente.
- Para solucionar errores de dependencias, revisa el archivo `pubspec.yaml` y asegúrate de que las versiones sean compatibles.
- Puedes usar `flutter doctor` para verificar que tu entorno esté correctamente configurado.

---

## Recursos Útiles

- [Documentación oficial de Flutter](https://docs.flutter.dev/)


# Etructura de proyecto

```
lib/
├── core/ // El directorio `core` contiene los elementos fundamentales de la  aplicación
│   ├── theme // Contiene los estilos y temas de la aplicación
│   │   ├── app_colors.dart // Colores centralizado
│   │   ├── app_styles.dart // Estilos centralizados
│   │   ├── app_text_styles.dart // Estilo de los textos de la interfaz
│   │   └── app_theme.dart // Tema general de la aplicación
├── models/ // Contiene los modelos de datos utilizados en la aplicación
│   ├── client.dart // Modelo de cliente <!> Falta
│   ├── deposit.dart // Modelo de depósito <!> Falta
│   └── user.dart // Modelo de usuario
├── screens/ // Contiene las diferentes pantallas de la aplicación
│   |── add_client/ // Interfaz para agregar clientes <!> Arreglar Logica Fuertemente acoplada 
│   |    ├── add_clients_handler.dart // Maneja la logica de negocio    
│   |    └── add_client_screen.dart // Pantalla para agregar clientes
│   |── clientes/ // <!> Creo que es la interfas para mostrar los clietnes
│   |    ├── clients_handler.dart //<!> Maneja la logica de negocio
│   |    └── clients_screen.dart // <!> Pantalla para listar clientes

│   ├── depositos/ //<!> Interas para representar las transacciones que los clietes acen para pagar sus impuestos  
│   |    ├── depositos_handler.dart //<!> Maneja la logica de negocio
│   |    ├── depositos_screen.dart // <!> Pantalla para visualisar los depositos
│   |    ├── 
│   |    ├── 

│   └── login/  // Interfaz para logearse al sistema
│   │   ├── login_form.dart // Contiene el formulario de login
│   │   ├── login_handler.dart // Pantalla de login
│   │   └── login_styles.dart // Estilos de la pantalla de login
│   └── depositos/ // Interfas de depositos esta representa las transacciones que los clientes realizan para pagar sus impuestos 
│   |    ├── deposit_form.dart // 
│   |    └── deposit_screen.dart // Este se encarga de la comunicacion con el backend y la logica de negocio
│   └── clients/ // Gestion de clientes
│   |    ├── clients_handler.dart // Maneja la logica de negocio

└── main.dart // Lanzador de la aplicacion
``` 

# Documentación del proyecto general

# Clients
Interfaz para mostrar clientes de la empresa

### clients_handler.dart
Maneja la lógica de negocio, la gestión del estado (usando ChangeNotifier) y la comunicación con el backend a través de ApiService. Se encarga de cargar, filtrar, agregar, editar y eliminar clientes, pero no tiene ninguna lógica de UI.


### clients_screen.dart
Se encarga del diseño, la disposición de los widgets (DataTable, SearchBar, ActionButtons) y la gestión de la interacción directa con el usuario (como abrir diálogos, manejar controllers de texto y snackbars). No maneja el estado de los datos.

# Depositos
Interfaz para mostrar depósitos de la empresa son las transacciones que los clientes realizan. para pagar sus impuestos.

### depositos_handler.dart
Maneja la lógica de negocio, la gestión del estado (usando ChangeNotifier) y la comunicación con el backend a través de ApiService. Se encarga de cargar, filtrar, agregar, editar y eliminar depósitos, pero no tiene ninguna lógica de UI.


### depositos_screen.dart
Se encarga del diseño, la disposición de los widgets (DataTable, SearchBar, ActionButtons) y la gestión de la interacción directa con el usuario (como abrir diálogos, manejar controllers de texto y snackbars). No maneja el estado de los datos.

# Documentación para Levantar el Entorno de Flutter
