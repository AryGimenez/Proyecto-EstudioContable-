


Vamos a usar una estructura de proyecto bien organizada y separada. La idea es tener: 
- **Archivos que terminen en "Styles"**: Contendrán los estilos de la aplicación. 
- **Archivos que terminen en "Screen"**: Serán utilizados para lanzar las diferentes pantallas de la aplicación. 
- **Archivos que terminen en "Form"**: Contendrán el contenido de los formularios.

## Estructura de proyecto 

``lib/
├── core/                          
│   ├── theme/
│   │   ├── app_colors.dart        
│   │   ├── app_text_styles.dart   
│   │   └── app_theme.dart         
│   └── utils/                     
├── screens/                       
│   └── login/
│   │   ├── login_form.dart    
│   │   ├── login_screen.dart      
│   └   └── login_styles.dart
└── main.dart``



### Descripcion de la estructrua de arbol 
 
**core/**: El directorio `core` contiene los elementos fundamentales de la aplicación
**app_colors.dart**: Define la paleta de colores centralizada
**app_text_styles.dart**: Establece los estilos de texto consistentes
**app_theme.dart**: Configura el tema general de la aplicación
**utils/**: Contiene utilidades y funciones helper reutilizables.
**screens/**: Contiene las diferentes pantallas de la aplicación, cada una en su propio módulo.
**login/**: El directorio contiene los archivos correspondiente a el logeo.
**login_form.dart**: Pantalla principal de inicio de sesión
**login_screen.dart**: Es un StatefulWidget para manejar el estado del formulario de login.
**login_styles.dart**: Estilos específicos para la pantalla de login

### Beneficios de esta Estructura

1. **Organización Clara**: Separación lógica de componentes y funcionalidades
2. **Mantenibilidad**: Facilita la localización y modificación de código
3. **Escalabilidad**: Permite añadir nuevos módulos manteniendo la coherencia
4. **Reutilización**: Promueve la creación de componentes reutilizables
5. **Consistencia**: Mantiene un estilo uniforme en toda la aplicación

### Convenciones de Nombrado

- Archivos en `snake_case`
- Clases en `PascalCase`
- Variables y funciones en `camelCase`

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
git clone https://github.com/usuario/Proyecto-EstudioContable-.git
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