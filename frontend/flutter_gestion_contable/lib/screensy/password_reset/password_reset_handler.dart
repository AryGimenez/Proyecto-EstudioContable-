// lib/screens/password_reset/password_reset_handler.dart

// esta clase posee la logia de el Witget resetear Pasword

import 'package:flutter/material.dart'; // Importa el paquete de Flutter para usar widgets y funcionalidades de material design
import 'password_reset_form.dart'; // Importa el formulario de restablecimiento de contraseña

// Declara un StatefulWidget llamado PasswordResetHandler
class PasswordResetHandler extends StatefulWidget {
  const PasswordResetHandler({super.key}); // Constructor del widget

  @override
  _PasswordResetHandlerState createState() =>
      _PasswordResetHandlerState(); // Crea el estado asociado a este widget
}

// Define la clase de estado para PasswordResetHandler
class _PasswordResetHandlerState extends State<PasswordResetHandler> {
  final _formKey = GlobalKey<
      FormState>(); // Clave global para identificar el formulario y permitir la validación del formulario
  final _emailController =
      TextEditingController(); // Controlador para el campo de texto del correo electrónico
  final _verificationCodeController =
      TextEditingController(); // Controlador para el campo de texto del código de verificación
  final _passwordController =
      TextEditingController(); // Controlador para el campo de texto de la nueva contraseña
  final _confirmPasswordController =
      TextEditingController(); // Controlador para el campo de texto de confirmación de la nueva contraseña

  bool _isVerificationCodeSent =
      false; // Variable [booleana para verificar si el código de verificación ha sido enviado
  bool _isCodeVerified =
      false; // Variable booleana para verificar si el código ha sido verificado

  bool _isTextEmail = false; //

  @override
  void dispose() {
    _emailController
        .dispose(); // Libera los recursos utilizados por los controladores cuando el widget es destruido
    _verificationCodeController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _sendCode() {
    // Metodo que se lanza cuando se presiona el boton enviar codigo
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isVerificationCodeSent =
            true; // Actualiza el estado para indicar que el código ha sido enviado
      });
      // Aquí envías el correo de verificación
    }
  }

  // Método de validación del correo electrónico
  bool _emailValidator(String email) {
    return !(email.isEmpty || !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email));
  }

  void _verifyCode() {
    // Metoo que se lanza cuando preciona el botton Verificar Codigo
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isCodeVerified =
            true; // Actualiza el estado para indicar que el código ha sido verificado
      });
      // Aquí manejas la lógica de verificación del código
    }
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      // Aquí manejas el restablecimiento de la contraseña
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
              'Restablecer Contraseña')), // Define la barra de la aplicación con un título
      body: Padding(
        padding: const EdgeInsets.all(
            16.0), // Agrega un relleno alrededor del contenido principal
        child: PasswordResetForm(
          formKey: _formKey,
          emailController: _emailController,
          verificationCodeController: _verificationCodeController,
          passwordController: _passwordController,
          confirmPasswordController: _confirmPasswordController,
          isVerificationCodeSent: _isVerificationCodeSent,
          isCodeVerified: _isCodeVerified,
          onSendCode: _sendCode,
          onVerifyCode: _verifyCode,
          onSubmit: _submitForm,
        ),
      ),
    );
  }
}
