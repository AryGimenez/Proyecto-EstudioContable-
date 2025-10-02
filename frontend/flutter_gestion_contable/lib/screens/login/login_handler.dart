// lib/screens/login/login_handler.dart

import 'package:flutter/material.dart';
// Importa el servicio para manejar la comunicación con el backend.
import 'package:flutter_gestion_contable/services/api_service.dart';
// Importa el widget del formulario, que solo maneja la UI.
import 'package:flutter_gestion_contable/screens/login/login_form.dart';
// Importa la pantalla principal a la que se navegará después del login exitoso.
import 'package:flutter_gestion_contable/screens/main_website/main_handler.dart';
// Importa la pantalla para el reseteo de contraseña.
import 'package:flutter_gestion_contable/screens/password_reset/password_reset_handler.dart';

// Widget que maneja el estado de la pantalla de login.
class LoginHandler extends StatefulWidget {
  const LoginHandler({Key? key}) : super(key: key);

  @override
  State<LoginHandler> createState() => _LoginHandlerState();
}

class _LoginHandlerState extends State<LoginHandler> {
  // Clave para identificar el formulario y sus validaciones.
  final _formKey = GlobalKey<FormState>();
  final _userController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  // Instancia de ApiService para usar sus métodos de login.
  final ApiService _apiService = ApiService();

  // Método que se ejecuta al presionar el botón de "Iniciar sesión".
  void _submitForm() async {
    // Valida el formulario antes de hacer la llamada a la API.
    if (_formKey.currentState?.validate() ?? false) {
      final username = _userController.text;
      final password = _passwordController.text;

      // Llama al método de login del servicio API y espera el resultado.
      final result = await _apiService.login(username, password);

      // Verifica si el widget sigue montado antes de actualizar la UI.
      if (mounted) {
        if (result['success']) {
          // Si es exitoso, navega a la pantalla principal y reemplaza la actual.
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const MainHandler()),
          );
        } else {
          // Si falla, muestra un mensaje de error desde el backend.
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'Error de autenticación.'),
            ),
          );
        }
      }
    }
  }

  // Alterna la visibilidad de la contraseña.
  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  // Navega a la pantalla de reseteo de contraseña.
  void _navigateToPasswordReset() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const PasswordResetHandler()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Construye la estructura de la pantalla de login.
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          // Pasa los controladores y métodos al widget del formulario.
          child: LoginForm(
            formKey: _formKey,
            userController: _userController,
            passwordController: _passwordController,
            isPasswordVisible: _isPasswordVisible,
            onPasswordVisibilityToggle: _togglePasswordVisibility,
            onSubmit: _submitForm, // El botón de "Iniciar sesión" llama a este método.
            onResetPassword: _navigateToPasswordReset, // El botón "Olvidaste..." llama a este método.
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Libera los recursos de los controladores para evitar fugas de memoria.
    _userController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}