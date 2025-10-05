// frontend/flutter_gestion_contable/lib/screens/login/login_handler.dart

import 'package:flutter/material.dart'; // Importa el paquete principal de Flutter.
import 'package:flutter_gestion_contable/services/api_service.dart'; // Importa el servicio API
import 'package:flutter_gestion_contable/screens/login/login_form.dart'; // Importa el formulario de login
import 'package:flutter_gestion_contable/screens/main_website/main_handler.dart'; // Importa la pantalla principal a la que se navegará después del login exitoso.
import 'package:flutter_gestion_contable/screens/password_reset/password_reset_handler.dart'; // Importa la pantalla para el reseteo de contraseña.

/// Widget principal que gestiona el estado y la lógica de negocio de la pantalla de Login.
///
/// Este [StatefulWidget] es el punto de control para:
/// 1. Los [TextEditingController] para el formulario.
/// 2. La visibilidad de la contraseña.
/// 3. La comunicación con la [ApiService] para la autenticación.
/// 4. La navegación a la pantalla principal o de reseteo de contraseña.
class LoginHandler extends StatefulWidget {
  const LoginHandler({Key? key}) : super(key: key); // Constructor del widget.

  @override
  State<LoginHandler> createState() => _LoginHandlerState(); // Crea el estado asociado a este widget.
}

/// Estado asociado al [LoginHandler].
///
/// Implementa la lógica de manejo del formulario y las operaciones asíncronas.
class _LoginHandlerState extends State<LoginHandler> {
  // Clave para identificar el formulario y sus validaciones.
  final _formKey = GlobalKey<FormState>(); // Clave global para el formulario.
  final _userController = TextEditingController(); // Controlador para el campo de usuario.
  final _passwordController = TextEditingController(); // Controlador para el campo de contraseña.
  bool _isPasswordVisible = false;  // Estado para controlar la visibilidad de la contraseña.

  // Instancia de ApiService para usar sus métodos de login.
  final ApiService _apiService = ApiService();

  
  /// Método que se ejecuta al presionar el botón de "Iniciar sesión".
  /// @returns Un [Future<void>] que se completa después de intentar la autenticación
  /// y manejar la navegación o mostrar el error.
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

  
   /// Alterna la visibilidad del texto en el campo de contraseña.
   /// * Llama a [setState] para forzar el redibujo del [LoginForm] y actualizar el
   /// ícono del ojo y la propiedad [obscureText].
  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  /// Navega a la pantalla de reseteo de contraseña.
  /// * Utiliza [Navigator.of(context).push] para ir a [PasswordResetHandler]
  /// permitiendo al usuario volver a la pantalla de login.
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