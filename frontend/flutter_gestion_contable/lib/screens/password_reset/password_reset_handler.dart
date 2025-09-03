// lib/screens/password_reset/password_reset_handler.dart

import 'package:flutter/material.dart';
// Importa el servicio que se comunica con tu backend (FastAPI).
import 'package:flutter_gestion_contable/services/api_service.dart';
// Importa el widget que define la apariencia del formulario.
import 'package:flutter_gestion_contable/screens/password_reset/password_reset_form.dart'; 

// Widget con estado que maneja la lógica y el estado de la pantalla.
class PasswordResetHandler extends StatefulWidget {
  const PasswordResetHandler({Key? key}) : super(key: key);

  @override
  State<PasswordResetHandler> createState() => _PasswordResetHandlerState();
}

class _PasswordResetHandlerState extends State<PasswordResetHandler> {
  // Controladores para obtener el texto de los campos del formulario.
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();
  
  // Instancia del servicio API para hacer las llamadas HTTP.
  final ApiService _apiService = ApiService();
  
  // Variable de estado que controla qué "paso" del formulario se muestra (0 para email, 1 para código).
  int _currentStep = 0;

  // Método para el primer paso: solicitar un código de reseteo.
  void _requestPasswordReset() async {
    final email = _emailController.text;
    if (email.isEmpty || !email.contains('@')) {
      _showSnackBar('Por favor, ingrese un correo válido.');
      return;
    }

    // Llama al método del ApiService para enviar la solicitud al backend.
    final result = await _apiService.requestPasswordReset(email);
    
    // Verifica si el widget sigue montado antes de actualizar el estado.
    if (mounted) {
      if (result['success']) {
        // Si la solicitud es exitosa, cambia al siguiente paso del formulario.
        setState(() {
          _currentStep = 1;
        });
        _showSnackBar('Código de verificación enviado al correo.');
      } else {
        _showSnackBar(result['message'] ?? 'Error al solicitar el código.');
      }
    }
  }

  // Método para el segundo paso: confirmar el reseteo con el código y la nueva contraseña.
  void _confirmPasswordReset() async {
    final email = _emailController.text;
    final code = _codeController.text;
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmNewPasswordController.text;

    if (code.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      _showSnackBar('Por favor, complete todos los campos.');
      return;
    }

    if (newPassword != confirmPassword) {
      _showSnackBar('Las contraseñas no coinciden.');
      return;
    }

    // Llama al método del ApiService para confirmar el reseteo con el backend.
    final result = await _apiService.confirmPasswordReset(email, code, newPassword);

    if (mounted) {
      if (result['success']) {
        // Si la confirmación es exitosa, regresa a la pantalla anterior (login).
        Navigator.of(context).pop();
        _showSnackBar('Contraseña actualizada con éxito.');
      } else {
        _showSnackBar(result['message'] ?? 'Error al actualizar la contraseña.');
      }
    }
  }

  // Método auxiliar para mostrar mensajes en la parte inferior de la pantalla.
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold proporciona la estructura básica de la pantalla.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restablecer Contraseña'),
      ),
      // SingleChildScrollView permite que la pantalla sea desplazable si el contenido es muy grande.
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          // Envía todos los controladores y métodos al widget del formulario.
          child: PasswordResetForm(
            currentStep: _currentStep,
            emailController: _emailController,
            codeController: _codeController,
            newPasswordController: _newPasswordController,
            confirmNewPasswordController: _confirmNewPasswordController,
            onRequestReset: _requestPasswordReset,
            onConfirmReset: _confirmPasswordReset,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Libera los recursos de los controladores de texto para evitar fugas de memoria.
    _emailController.dispose();
    _codeController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }
}