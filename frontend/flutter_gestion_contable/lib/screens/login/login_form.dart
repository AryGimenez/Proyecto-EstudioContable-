// frontend/flutter_gestion_contable/lib/screens/login/login_form.dart

import 'package:flutter/material.dart';
// Importa los estilos de la aplicación para mantener la consistencia.
import 'package:flutter_gestion_contable/core/theme/app_text_styles.dart';
import 'package:flutter_gestion_contable/core/theme/app_colors.dart';
import 'package:flutter_gestion_contable/core/theme/app_styles.dart';
import 'login_styles.dart';

class LoginForm extends StatelessWidget {
  // Define las propiedades que este widget necesita recibir de su padre (el handler).
  final GlobalKey<FormState> formKey;
  final TextEditingController userController;
  final TextEditingController passwordController;
  final bool isPasswordVisible;
  final VoidCallback onPasswordVisibilityToggle;
  final VoidCallback onSubmit; // Callback para el botón de iniciar sesión.
  final VoidCallback onResetPassword; // Callback para el botón de "Perdí la contraseña".

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
  Widget build(BuildContext context) {
    // La estructura principal del formulario, centrada en la pantalla.
    return Center(
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: formMaxWidth
          ),
          child: Padding(
            padding: formPadding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Imagen del logo.
                Image.asset(
                  'lib/assets/Logo Barone.png',
                  height: logoHeight,
                ),
                verticalSpaceMedium,
                // El formulario que contiene los campos de texto.
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      _buildUserField(), // Campo para el usuario.
                      verticalSpaceSmall,
                      _buildPasswordField(), // Campo para la contraseña.
                      verticalSpaceMedium,
                      _buildLoginButton(), // Botón de inicio de sesión.
                    ],
                  ),
                ),
                verticalSpaceMedium,
                _buildTextButonRestPassword(), // Botón para restablecer contraseña.
                verticalSpaceMedium,
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
      onPressed: onResetPassword,
      child: Text(
        'Perdí la contraseña',
        style: AppTextStyles.bodyText1.copyWith(color: AppColors.primary),
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