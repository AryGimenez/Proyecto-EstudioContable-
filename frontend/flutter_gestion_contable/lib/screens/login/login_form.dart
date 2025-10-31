// frontend/flutter_gestion_contable/lib/screens/login/login_form.dart

import 'package:flutter/material.dart';
// Importa los estilos de la aplicación para mantener la consistencia.
import 'package:flutter_gestion_contable/core/theme/app_text_styles.dart';
import 'package:flutter_gestion_contable/core/theme/app_colors.dart';
import 'package:flutter_gestion_contable/core/theme/app_styles.dart';
import 'login_styles.dart';

/// Widget de presentación (StatelessWidget) que construye el formulario
/// de inicio de sesión.
///
/// Este widget es puramente de UI y no maneja la lógica de negocio ni el estado
/// (como los valores de los campos de texto o la visibilidad de la contraseña);
/// en su lugar, recibe todos los datos (controladores, flags) y las acciones
/// (callbacks) de su widget padre (el LoginHandler o ViewModel).
///
/// Componentes principales:
/// - Logo de la aplicación.
/// - Un [Form] que contiene [TextFormField] para Usuario y Contraseña.
/// - Botón principal de "Iniciar sesión".
/// - Botones de acción secundaria ("Perdí la contraseña" y "Configuración").
class LoginForm extends StatelessWidget {
  final GlobalKey<FormState> formKey; // Clave para validar el formulario.
  final TextEditingController userController; // Controlador para el campo de usuario.
  final TextEditingController passwordController; // Controlador para el campo de contraseña.
  final bool isPasswordVisible; // Flag para controlar la visibilidad de la contraseña.
  final VoidCallback onPasswordVisibilityToggle; // Callback para alternar la visibilidad de la contraseña. 
  final VoidCallback onSubmit; // Callback para el botón de iniciar sesión.
  final VoidCallback onResetPassword; // Callback para el botón de "Perdí la contraseña".
  
  /// Constructor del widget [LoginForm].
  ///
  /// Este widget requiere que todas sus propiedades sean inicializadas por el widget padre
  /// para establecer las referencias a los controladores de texto, el estado de la UI,
  /// y las funciones de acción que desencadenarán la lógica de negocio.
  ///
  /// @param key La clave del widget.
  /// @param formKey Una clave global ([GlobalKey<FormState>]) utilizada para validar y
  ///       guardar los campos del formulario antes de la autenticación.
  /// @param userController Controlador para gestionar la entrada de texto del campo 'Usuario'.
  /// @param passwordController Controlador para gestionar la entrada de texto del campo 'Contraseña'.
  /// @param isPasswordVisible Bandera que indica si el texto de la contraseña debe ser visible o estar ofuscado.
  /// @param onPasswordVisibilityToggle Callback que se ejecuta al presionar el ícono de visibilidad
  ///        (el ojo), para cambiar el estado de [isPasswordVisible].
  /// @param onSubmit Callback que se ejecuta cuando el usuario presiona el botón 'Iniciar sesión'.
  /// @param onResetPassword Callback que se ejecuta al presionar el botón 'Perdí la contraseña'.
  const LoginForm({
    super.key,
    required this.formKey,
    required this.userController,
    required this.passwordController,
    required this.isPasswordVisible,
    required this.onPasswordVisibilityToggle,
    required this.onSubmit,
    required this.onResetPassword,
  });

  @override
  /// Construye el árbol de widgets para el formulario de inicio de sesión.
  ///
  /// Se utiliza un [Center] y un [SingleChildScrollView] para asegurar que el
  /// formulario esté centrado en la pantalla y sea desplazable en caso de que
  /// el teclado ocupe demasiado espacio (especialmente en dispositivos móviles o web).
  ///
  /// La estructura es una [Column] que contiene:
  /// 1. El Logo de la aplicación.
  /// 2. El [Form] principal, que utiliza la [formKey] para la validación.
  /// 3. Los botones de acción secundaria ([_buildTextButonRestPassword] y [_buildConfigurationButton]).
  ///
  /// @param context El contexto del widget actual.
  /// @returns El widget central que contiene el formulario de inicio de sesión.
  Widget build(BuildContext context) {
    return Center( // Centra el formulario en la pantalla.
      child: SingleChildScrollView( // Hace que el formulario sea desplazable si es necesario.
        child: ConstrainedBox( // Limita el ancho máximo del formulario.
          constraints: const BoxConstraints( // Asegura que el formulario no exceda el ancho máximo.
            maxWidth: formMaxWidth // Ancho máximo del formulario.
          ),
          child: Padding( // Añade espacio alrededor del formulario.
            padding: formPadding, // Espacio alrededor del formulario.
            child: Column( // Columna que contiene los elementos del formulario.
              mainAxisAlignment: MainAxisAlignment.center, // Centra verticalmente los elementos.
              children: [ // Elementos del formulario.
                Image.asset( // Imagen del logo.
                  'lib/assets/Logo Barone.png', // Ruta de la imagen del logo.
                  height: logoHeight, // Altura del logo.
                ),
                verticalSpaceMedium, // Espacio vertical entre el logo y el formulario.
                Form( // Formulario que contiene los campos de texto.
                  key: formKey, // Clave para validar el formulario.
                  child: Column( // Columna que contiene los campos de texto.
                    children: [ // Elementos del formulario.
                      _buildUserField(), // Campo para el usuario.
                      verticalSpaceSmall, // Espacio vertical entre el campo de usuario y la contraseña.
                      _buildPasswordField(), // Campo para la contraseña.
                      verticalSpaceMedium, // Espacio vertical entre el campo de contraseña y el botón de inicio de sesión.
                      _buildLoginButton(), // Botón de inicio de sesión.
                    ],
                  ),
                ),
                verticalSpaceMedium, // Espacio vertical entre el botón de inicio de sesión y el botón de restablecimiento de contraseña.
                _buildTextButonRestPassword(), // Botón para restablecer contraseña.
                verticalSpaceMedium, // Espacio vertical entre el botón de restablecimiento de contraseña y el botón de configuración.      
                _buildConfigurationButton(), // Botón de configuración.
              ],
            ),
          ),
        ),
      ),
    );
  }

  
   /// Construye el botón de "Perdí la contraseña".
   /// * Llama al callback [onResetPassword] proporcionado por el controlador
  Widget _buildTextButonRestPassword() {
    return TextButton(
      // Llama a la función onResetPassword que viene del handler.
      onPressed: onResetPassword, // Callback al presionar el botón.
      child: Text(  // Texto del botón.
        'Perdí la contraseña', // Texto del botón.
        style: AppTextStyles.bodyText1.copyWith(color: AppColors.primary), // Estilo del texto del botón.
      ),
    );
  }

  /// Construye el campo de texto para el usuario.
  /// * Incluye la lógica de validación simple (no vacío).
  /// * Utiliza [TextFormField] para capturar la entrada del usuario.
  Widget _buildUserField() {
    return TextFormField( // Campo de texto para el usuario.
      controller: userController, // Controlador para capturar la entrada del usuario.
      decoration: const InputDecoration( // Decoración del campo de texto.
        labelText: 'Usuario', // Etiqueta del campo.
        labelStyle: AppTextStyles.bodyText1, // Estilo de la etiqueta.
        prefixIcon: Icon(Icons.person), // Icono de persona para el campo.
      ), //F 
      // Lógica de validación del campo.
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Por favor ingrese su usuario';
        }
        return null;
      },
    );
  }

  /// Construye el campo de texto para la contraseña.
  /// * Incluye la lógica de validación simple (no vacío).
  /// * Utiliza [TextFormField] para capturar la entrada de la contraseña.
  Widget _buildPasswordField() {
    return TextFormField( // Campo de texto para la contraseña.
      controller: passwordController, // Controlador para capturar la entrada de la contraseña.
      decoration: InputDecoration( // Decoración del campo de texto.
        labelText: 'Contraseña', // Etiqueta del campo.
        prefixIcon: const Icon(Icons.lock), // Icono de candado para el campo.
        // Ícono del ojo para mostrar/ocultar la contraseña.
        suffixIcon: IconButton(
          icon: Icon(
            isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          // Llama a la función onPasswordVisibilityToggle que viene del handler.
          onPressed: onPasswordVisibilityToggle, // Controla la visibilidad de la contraseña.
        ),
      ), // Decoración del campo de texto.
      obscureText: !isPasswordVisible, // Oculta la contraseña si no es visible.
      // Lógica de validación del campo.
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Por favor ingrese su contraseña';
        }
        return null;
      },
    );
  }

  /// Construye el botón de "Iniciar sesión".
  /// * Llama al callback [onSubmit] proporcionado por el controlador.
  Widget _buildLoginButton() {
    return ElevatedButton( // Botón de "Iniciar sesión".
      onPressed: onSubmit, // Controla el evento de presionar el botón.
      child: const Text('Iniciar sesión'), // Texto del botón.
    );
  }

  /// Construye el botón de configuración desplegable.
  /// * Muestra opciones como dirección IP y puerto.
  Widget _buildConfigurationButton() {  
    // <!> Porque este boton tiene un contendeor 
    return Container( // Contenedor para el botón de configuración.
      decoration: BoxDecoration(  // Decoración del contenedor.
        borderRadius: BorderRadius.circular(12.0), // Bordes redondeados.
        color: AppColors.primary, // Color de fondo del contenedor.
      ),  
      child: ExpansionTile( // Botón de expansión para configuración.
        title: const Text(  // Título del botón de expansión.
          'Configuración',  // Texto del botón de expansión.
          style: TextStyle(   // Estilo del texto del botón de expansión.
            fontWeight: FontWeight.bold, // Negrita para el texto.
            color: Colors.white, // Color del texto.
          ),
        ),
        leading: const Icon( // Icono de configuración para el botón de expansión.
          Icons.settings, // Icono de configuración.
          color: Colors.white, // Color del icono.
        ),
        trailing: const Icon( // Icono de flecha para el botón de expansión.  
          Icons.keyboard_arrow_down, // Icono de flecha.
          color: Colors.white, // Color del icono.
        ),
        children: [ // Opciones de configuración.
          ListTile( // Opción de dirección IP.
            shape: RoundedRectangleBorder( // Bordes redondeados. 
              borderRadius: BorderRadius.circular(8.0), // Bordes redondeados.
            ),
            leading: const Icon(Icons.wifi, color: Colors.white), // Icono de wifi para la dirección IP.
            title: const Text( // Título de la dirección IP.
              'Dirección IP', // Texto del título.
              style: TextStyle(color: Colors.white), // Estilo del texto.
            ),
            onTap: () {
              // Acción al tocar Dirección IP
            },
          ),
          const SizedBox(height: 5), // Espacio vertical entre las opciones.
          ListTile( // Opción de puerto. 
            shape: RoundedRectangleBorder( // Bordes redondeados.
              borderRadius: BorderRadius.circular(8.0), // Bordes redondeados.
            ),
            leading: const Icon(Icons.router, color: Colors.white), // Icono de router para el puerto.
            title: const Text( // Título del puerto.
              'Puerto', // Texto del título.
              style: TextStyle(color: Colors.white), // Estilo del texto.
            ),
            onTap: () {
              // Acción al tocar Puerto
            },
          ),
          const SizedBox(height: 10), // Espacio vertical entre las opciones.
          Padding( // Padding para el botón de conectar.
            padding: const EdgeInsets.symmetric(horizontal: 16.0), // Padding horizontal.
            child: ElevatedButton( // Botón de conectar.
              style: ElevatedButton.styleFrom( // Estilo del botón de conectar.
                backgroundColor: const Color(0xFFf8f19f), // Color de fondo del botón.
                foregroundColor: AppColors.primary, // Color del texto del botón.
              ),
              onPressed: () { // Controla el evento de presionar el botón.
                // Acción al tocar Conectar
              },
              child: const Text('Conectar'), // Texto del botón de conectar.
            ),
          ),
          const SizedBox(height: 10), // Espacio vertical entre las opciones.
        ],
      ),
    );
  }
}