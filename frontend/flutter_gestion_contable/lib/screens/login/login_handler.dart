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
    if (_formKey.currentState?.validate() ?? false) {// Valida el formulario antes de hacer la llamada a la API.
      final username = _userController.text.trim(); // Obtiene el texto del campo de usuario y lo recorta de espacios.
      final password = _passwordController.text.trim(); // Obtiene el texto del campo de contraseña y lo recorta de espacios. 
      final result = await _apiService.login(username, password); // Llama al método de login del servicio API y espera el resultado.

      if (mounted) { // Verifica si el widget sigue montado antes de actualizar la UI.
        if (result['success']) {// Si la autenticación es exitosa.          
          Navigator.of(context).pushReplacement( // Si es exitoso, navega a la pantalla principal y reemplaza la actual.
            MaterialPageRoute(builder: (context) => const MainHandler()), // Construye la ruta a la pantalla principal.
          );
        } else { // Si la autenticación falla.
          ScaffoldMessenger.of(context).showSnackBar( // Muestra un mensaje de error en la parte inferior de la pantalla.
            SnackBar( // Crea un widget SnackBar para mostrar el mensaje de error.
              content: Text(result['message'] ?? 'Error de autenticación.'), // Muestra el mensaje de error devuelto por el backend o un mensaje predeterminado.
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
    setState(() { // Actualiza el estado para cambiar la visibilidad de la contraseña.
      _isPasswordVisible = !_isPasswordVisible; // Cambia el valor de _isPasswordVisible a su opuesto.
    });
  }

  /// Navega a la pantalla de reseteo de contraseña.
  /// * Utiliza [Navigator.of(context).push] para ir a [PasswordResetHandler]
  /// permitiendo al usuario volver a la pantalla de login.
  void _navigateToPasswordReset() {
    Navigator.of(context).push( // Navega a la pantalla de reseteo de contraseña.
      MaterialPageRoute(builder: (context) => const PasswordResetHandler()), // Construye la ruta a la pantalla de reseteo de contraseña.
    );
  }

  /// Construye la interfaz de usuario de la pantalla de login.
  /// * Utiliza [Scaffold] para proporcionar la estructura básica.
  /// * Incluye un [LoginForm] para el ingreso de credenciales.
  @override
  Widget build(BuildContext context) {
    return Scaffold( // Construye la estructura básica de la pantalla de login.
      body: Center( // Centra el contenido de la pantalla.
        child: SingleChildScrollView( // Permite el desplazamiento vertical si el contenido excede la altura de la pantalla.
          padding: const EdgeInsets.all(16.0), // Añade un padding uniforme alrededor del formulario.
          child: LoginForm( // Incluye el widget LoginForm para el ingreso de credenciales.
            formKey: _formKey, // Pasa la clave del formulario para validar y acceder a sus métodos.
            userController: _userController, // Pasa el controlador para el campo de usuario.
            passwordController: _passwordController, // Pasa el controlador para el campo de contraseña.
            isPasswordVisible: _isPasswordVisible, // Pasa el estado de visibilidad de la contraseña.
            onPasswordVisibilityToggle: _togglePasswordVisibility, // Pasa el método para alternar la visibilidad de la contraseña.
            onSubmit: _submitForm, // El botón de "Iniciar sesión" llama a este método.
            onResetPassword: _navigateToPasswordReset, // El botón "Olvidaste..." llama a este método.
          ),
        ),
      ),
    );
  }


  /// Libera los recursos de los controladores cuando el widget se desmonta.
  /// * Es importante llamar a [dispose] para liberar memoria y evitar fugas.
  @override
  void dispose() {
    _userController.dispose(); // Libera el controlador de usuario.
    _passwordController.dispose(); // Libera el controlador de contraseña.
    super.dispose(); // Llama al método dispose de la clase base para liberar recursos adicionales.
  }

}