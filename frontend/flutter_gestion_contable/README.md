# Estructura general de proyecto 
Para cada componente o interfas vamos a generar esta estructura.

Vamos a usar una estructura de proyecto bien organizada y separada. La idea es tener: 

- **Archivos que terminen en "Styles"**: Contendrán los estilos de la aplicación. 
- **Archivos que terminen en "Screen"**: Serán utilizados para lanzar las diferentes pantallas de la aplicación. <!> NO Creo qeu esto es la logica de la interfas pero hay que revisar 

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

Comprueba que no haya errores en el archivo `pubspec.yaml` y que todas las dependencias sqe hayan instalado correctamente.

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

## Notas
- Si agregas nuevas dependencias, recuerda ejecutar `flutter pub get` nuevamente.
- Para solucionar errores de dependencias, revisa el archivo `pubspec.yaml` y asegúrate de que las versiones sean compatibles.
- Puedes usar `flutter doctor` para verificar que tu entorno esté correctamente configurado.

---

## Recursos Útiles

- [Documentación oficial de Flutter](https://docs.flutter.dev/)

<!> Estaria bueno averiguar para usar un patron de disenio Fachada cpas para que de una menera al pasar 
los datos actualice en el bakend no se que decicion toar quiero algo que modifique escturctjra 

# 📂 Estructura de proyecto

```dart
lib/
├── core/ // El directorio `core` contiene los elementos fundamentales de la  aplicación
│   ├── theme // Contiene los estilos y temas de la aplicación
│   │   ├── app_colors.dart // Colores centralizado
│   │   ├── app_styles.dart // Estilos centralizados
│   │   ├── app_text_styles.dart // Estilo de los textos de la interfaz
│   │   └── app_theme.dart // Tema general de la aplicación
├── models/ // Contiene los modelos de datos utilizados en la aplicación
│   ├── client.dart // Modelo de cliente <!> Falta prograrm Archivo Vasio 
│   ├── deposit.dart // Modelo de depósito <!> Falta prograrm Archivo Vasio 
│   └── user.dart // Modelo de usuario <!> No entendi bien como es el tema de modificar datos 
├── screens/ // Contiene las diferentes pantallas de la aplicación
│   ├── add_client/ // Interfaz para agregar clientes <!> Arreglar Logica Fuertemente acoplada 
│   │    ├── add_clients_handler.dart // Maneja la logica de negocio <!> Falta terminar de documentar    
│   │    └── add_client_screen.dart // Pantalla para agregar clientes
│   ├── clientes/ // <!> Creo que es la interfas para mostrar los clietnes
│   │    ├── clients_handler.dart //<!> Maneja la logica de negocio
│   │    └── clients_screen.dart // <!> Pantalla para listar clientes
│   ├── deposits/ // Interfaz para representar la transacción que el cliente realiza para pagar sus impuestos y los honorarios del estudio contable   <!> Fuertemente Vinculado  
│   │    ├── deposits_handler.dart // Maneja la lógica de negocio
│   │    └── deposits_screen.dart // Pantalla para visualizar los depósitos
│   ├── login/  // Interfaz para logearse al sistema
│   │   ├── login_form.dart // Contiene el formulario de login
│   │   ├── login_handler.dart // Pantalla de login
│   │   └── login_styles.dart // Estilos de la pantalla de login
│   ├── main_website/ // 🎛️ Contenedor principal que define el layout y la navegación (Barra lateral y Contenido).
│   │   ├── main_content.dart //🏠 Vista de Bienvenida (Home). Es el placeholder inicial de la aplicación.
│   │   ├── main_handler.dart //🧠 Manejador de Estado y Navegación. Controla el menú lateral, el cambio de pantallas, y la inyección de la lógica (Providers).
│   │   ├── main_style.dart //🎨 Paleta de Colores Global. Define los colores usados en toda la aplicación (primario, secundario, fondo, texto, éxito, error). <!> Esto no entiendo porque esta aca tendria que estar en otro lugar no se parese que esta en un menu caps en theme que por lo que entendi estan todos los estilos de la web 
│   │   └── notification_modal.dart //🔔 Componente Modal de Notificaciones. Muestra el pop-up con la lista de alertas. <!> Falta documentar 
│   ├── password_reset/ //🔒 Módulo de Restablecimiento de Contraseña. Controla el flujo de solicitud y confirmación (código + nueva clave).
│   │   ├── password_reset_form.dart // 🎨 Componente UI del Formulario. Muestra los campos de entrada y botones, cambiando su contenido según el paso actual. <!> Falta documentar
│   │   ├── password_reset_handler.dart // 🧠 Manejador de Lógica y Estado. Controla el flujo de 2 pasos, validaciones y la comunicación con la API.<!> Falta documentar
│   │   └── password_reset_style.dart // 📐 Constantes de Estilo. Define constantes de diseño únicas para este módulo (ej. ancho máximo del formulario).<!> Estilos uniocs interras
│   ├── payments/ // Interfaz para representar la transacción que el cliente realiza para pagar sus impuestos y los honorarios del estudio contable   <!> Fuertemente Vinculado  Esto no entiendo no esta en la interfas desposito 
│   │    ├── payments_handler.dart // Maneja la lógica de negocio
│   │    └── payments_screen.dart // Pantalla para visualizar los pagos
└── main.dart // Lanzador de la aplicacion
``` 

# Documentación del proyecto general

# clients/
Interfaz para mostrar clientes de la empresa

### clients_handler.dart
Maneja la lógica de negocio, la gestión del estado (usando ChangeNotifier) y la comunicación con el backend a través de ApiService. Se encarga de cargar, filtrar, agregar, editar y eliminar clientes, pero no tiene ninguna lógica de UI.

### clients_screen.dart
Se encarga del diseño, la disposición de los widgets (DataTable, SearchBar, ActionButtons) y la gestión de la interacción directa con el usuario (como abrir diálogos, manejar controllers de texto y snackbars). No maneja el estado de los datos.

# depositos/
Interfaz para mostrar depósitos de la empresa son las transacciones que los clientes realizan. para pagar sus impuestos.

### depositos_handler.dart
Maneja la lógica de negocio, la gestión del estado (usando ChangeNotifier) y la comunicación con el backend a través de ApiService. Se encarga de cargar, filtrar, agregar, editar y eliminar depósitos, pero no tiene ninguna lógica de UI.

### depositos_screen.dart
Se encarga del diseño, la disposición de los widgets (DataTable, SearchBar, ActionButtons) y la gestión de la interacción directa con el usuario (como abrir diálogos, manejar controllers de texto y snackbars). No maneja el estado de los datos.

# main_website/
El módulo main_website contiene los componentes esenciales para la estructura principal de la aplicación (el layout o shell). Su responsabilidad principal es gestionar el estado de la navegación, la barra lateral y la visualización del contenido de la página actual.

### main_content.dart
Contenido de Bienvenida/Home: Es un widget simple (StatelessWidget) que representa la vista inicial por defecto (Bienvenido al sitio principal). Contiene una AppBar básica con el botón de cerrar sesión y se usa como el placeholder inicial cuando el usuario ingresa a la aplicación.

### main_handler.dart
Lógica de la Interfaz Principal (Shell): Es el Widget Stateful (MainHandler) que gestiona el estado de toda la página. Maneja la selección del menú lateral, el cambio de pantalla (inyectando el widget adecuado como _currentChild), la lógica de cierre de sesión (_logout) y la inyección de dependencias (ApiService) a través de ChangeNotifierProvider.

### main_style.dart
Paleta de Colores Global: Este archivo define las constantes de color de toda la aplicación (AppColors). Tener varios colores es una buena práctica porque define una paleta completa (Primario, Secundario, Fondo, Texto, Éxito, Error) que debe usarse de forma consistente en toda la aplicación, no solo en la barra lateral.

### notification_modal.dart
Componente Modal de Notificaciones: Es un Widget Stateless que define la estructura visual del pop-up (diálogo o modal) que se muestra cuando el usuario hace clic en el ícono de notificaciones en la barra superior. Contiene la lógica para cerrarse (Navigator.of(context).pop()).


<!> Terminar de documentar los componentes