// lib/screens/login/login_form.dart

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

  // Widget para el botón de "Perdí la contraseña".
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

  // Widget para el campo de texto del usuario.
  Widget _buildUserField() {
    return TextFormField(
      controller: userController,
      decoration: const InputDecoration(
        labelText: 'Usuario',
        labelStyle: AppTextStyles.bodyText1,
        prefixIcon: Icon(Icons.person),
      ),
      // Lógica de validación del campo.
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Por favor ingrese su usuario';
        }
        return null;
      },
    );
  }

  // Widget para el campo de texto de la contraseña.
  Widget _buildPasswordField() {
    return TextFormField(
      controller: passwordController,
      decoration: InputDecoration(
        labelText: 'Contraseña',
        prefixIcon: const Icon(Icons.lock),
        // Ícono del ojo para mostrar/ocultar la contraseña.
        suffixIcon: IconButton(
          icon: Icon(
            isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          // Llama a la función onPasswordVisibilityToggle que viene del handler.
          onPressed: onPasswordVisibilityToggle,
        ),
      ),
      obscureText: !isPasswordVisible,
      // Lógica de validación del campo.
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Por favor ingrese su contraseña';
        }
        return null;
      },
    );
  }

  // Widget para el botón de inicio de sesión.
  Widget _buildLoginButton() {
    return ElevatedButton(
      // Llama a la función onSubmit que viene del handler.
      onPressed: onSubmit,
      child: const Text('Iniciar sesión'),
    );
  }

  // Widget para el botón de configuración desplegable.
  Widget _buildConfigurationButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: AppColors.primary,
      ),
      child: ExpansionTile(
        title: const Text(
          'Configuración',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: const Icon(
          Icons.settings,
          color: Colors.white,
        ),
        trailing: const Icon(
          Icons.keyboard_arrow_down,
          color: Colors.white,
        ),
        children: [
          ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            leading: const Icon(Icons.wifi, color: Colors.white),
            title: const Text(
              'Dirección IP',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              // Acción al tocar Dirección IP
            },
          ),
          const SizedBox(height: 5),
          ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            leading: const Icon(Icons.router, color: Colors.white),
            title: const Text(
              'Puerto',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              // Acción al tocar Puerto
            },
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFf8f19f),
                foregroundColor: AppColors.primary,
              ),
              onPressed: () {
                // Acción al tocar Conectar
              },
              child: const Text('Conectar'),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}