// lib/screens/login/login_form.dart

import 'package:flutter/material.dart';
// Importa la librería de Material Design de Flutter, utilizada para crear interfaces de usuario.

class LoginForm extends StatelessWidget {
  // Define un widget sin estado que representa un formulario de inicio de sesión.

  final GlobalKey<FormState> formKey;
  // Clave global utilizada para identificar y manejar el estado del formulario (como la validación).

  final TextEditingController userController;
  // Controlador para gestionar el texto ingresado en el campo de usuario.

  final TextEditingController passwordController;
  // Controlador para gestionar el texto ingresado en el campo de contraseña.

  final bool isPasswordVisible;
  // Bandera que indica si la contraseña debe mostrarse o permanecer oculta.

  final VoidCallback onPasswordVisibilityToggle;
  // Función que se llama cuando el usuario alterna la visibilidad de la contraseña.

  final VoidCallback onSubmit;
  // Función que se ejecuta al enviar el formulario (por ejemplo, al presionar un botón de inicio de sesión).

  const LoginForm({
    super.key, // Clave opcional que identifica este widget en la jerarquía.
    required this.formKey, // Requiere la clave del formulario.
    required this.userController, // Requiere el controlador del usuario.
    required this.passwordController, // Requiere el controlador de la contraseña.
    required this.isPasswordVisible, // Requiere la bandera de visibilidad de la contraseña.
    required this.onPasswordVisibilityToggle, // Requiere la función para alternar la visibilidad.
    required this.onSubmit, // Requiere la función para manejar el envío del formulario.
  });

  @override
  Widget build(BuildContext context) {
    // Construye el widget principal que representa el formulario.
    return Form(
      key: formKey,
      // Asocia la clave del formulario para manejar su estado (por ejemplo, validaciones).

      child: Column(
        // Organiza los widgets del formulario en una columna vertical.
        children: [
          _buildUserField(),
          // Agrega el campo de texto para ingresar el usuario.

          const SizedBox(height: 16),
          // Añade un espacio vertical de 16 píxeles entre el campo de usuario y el campo de contraseña.

          _buildPasswordField(),
          // Agrega el campo de texto para ingresar la contraseña.

          const SizedBox(height: 24),
          // Añade un espacio vertical de 24 píxeles entre el campo de contraseña y el botón.

          _buildLoginButton(),
          // Agrega el botón para iniciar sesión.
        ],
      ),
    );
  }

  Widget _buildUserField() {
    // Método privado que construye el campo de texto para el usuario.
    return TextFormField(
      controller: userController,
      // Vincula el campo de texto con el controlador para gestionar su contenido.

      decoration: const InputDecoration(
        labelText: 'Usuario',
        // Etiqueta que indica al usuario qué debe ingresar en el campo (nombre de usuario).

        prefixIcon: Icon(Icons.person),
        // Icono de persona que aparece al inicio del campo de texto como referencia visual.
      ),

      validator: (value) {
        // Validador que verifica si el campo de usuario contiene texto válido.
        if (value == null || value.isEmpty) {
          // Si el valor está vacío o es nulo, muestra un mensaje de error.
          return 'Por favor ingrese su usuario';
        }
        return null;
        // Si el valor es válido, no retorna ningún error.
      },
    );
  }

  Widget _buildPasswordField() {
    // Método privado que construye el campo de texto para la contraseña.
    return TextFormField(
      controller: passwordController,
      // Vincula el campo de texto con el controlador para gestionar su contenido.

      decoration: InputDecoration(
        labelText: 'Contraseña',
        // Etiqueta que indica al usuario que debe ingresar su contraseña.

        prefixIcon: const Icon(Icons.lock),
        // Icono de candado que aparece al inicio del campo como referencia visual.

        suffixIcon: IconButton(
          // Botón que alterna la visibilidad de la contraseña.
          icon: Icon(
            isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            // Cambia el icono según el estado de visibilidad de la contraseña.
          ),
          onPressed: onPasswordVisibilityToggle,
          // Llama a la función para alternar la visibilidad de la contraseña.
        ),
      ),

      obscureText: !isPasswordVisible,
      // Oculta o muestra el texto del campo según el estado de visibilidad.

      validator: (value) {
        // Validador que verifica si el campo de contraseña contiene texto válido.
        if (value == null || value.isEmpty) {
          // Si el valor está vacío o es nulo, muestra un mensaje de error.
          return 'Por favor ingrese su contraseña';
        }
        return null;
        // Si el valor es válido, no retorna ningún error.
      },
    );
  }

  Widget _buildLoginButton() {
    // Método privado que construye el botón para iniciar sesión.
    return ElevatedButton(
      onPressed: onSubmit,
      // Llama a la función para manejar el envío del formulario al presionar el botón.

      child: const Text('Iniciar sesión'),
      // Texto que aparece dentro del botón.
    );
  }
}
