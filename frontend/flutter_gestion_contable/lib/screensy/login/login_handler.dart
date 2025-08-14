// lib/screens/login/login_screen.dart

// Importa la librería de Material Design de Flutter, utilizada para crear interfaces de usuario.
import 'package:flutter/material.dart';
import 'package:flutter_gestion_contable/screensy/password_reset/password_reset_handler.dart';
import 'package:flutter_gestion_contable/screensy/main_website/main_handler.dart';
import 'login_form.dart';

// LoginScreen es un StatefulWidget para manejar el estado del formulario de login.
class LoginHandler extends StatefulWidget {
  const LoginHandler({super.key});

  @override
  _LoginHandlerState createState() => _LoginHandlerState();
}

// _LoginScreenState maneja el estado del formulario de login.
class _LoginHandlerState extends State<LoginHandler> {
  final _formKey = GlobalKey<FormState>();
  // Clave global para identificar y manejar el estado del formulario.

  final _userController = TextEditingController();
  // Controlador para gestionar el texto ingresado en el campo de usuario.

  final _passwordController = TextEditingController();
  // Controlador para gestionar el texto ingresado en el campo de contraseña.

  bool _isPasswordVisible = false;
  // Bandera que indica si la contraseña debe mostrarse o permanecer oculta.

  // Método que se llama cuando se libera el recurso (controladores de texto).
  @override
  void dispose() {
    _userController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Método para alternar la visibilidad de la contraseña.
  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  // Método para manejar el envío del formulario (validación).
  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      // Aquí manejas el envío del formulario.
    }
  }

  void _resetPasswordFrom() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PasswordResetHandler()),
    );
  }

 void _mainScreen() {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const MainHandler(),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    // Scaffold proporciona la estructura básica visual para la pantalla.
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      // Padding añade espacio alrededor del formulario.
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LoginForm(
          formKey: _formKey,
          userController: _userController,
          passwordController: _passwordController,
          isPasswordVisible: _isPasswordVisible,
          onPasswordVisibilityToggle: _togglePasswordVisibility,
          onSubmit: _submitForm,
          onMainScreen: _mainScreen,
          onResetPassword: _resetPasswordFrom,
        ),
      ),
    );
  }
}
