// lib/screens/password_reset/password_reset_form.dart

import 'package:flutter/material.dart';

// Widget sin estado, ya que solo muestra la UI y no maneja su propio estado.
class PasswordResetForm extends StatelessWidget {
  // Las propiedades (props) que el handler le pasa al formulario.
  final int currentStep;
  final TextEditingController emailController;
  final TextEditingController codeController;
  final TextEditingController newPasswordController;
  final TextEditingController confirmNewPasswordController;
  final VoidCallback onRequestReset;
  final VoidCallback onConfirmReset;

  const PasswordResetForm({
    super.key,
    required this.currentStep,
    required this.emailController,
    required this.codeController,
    required this.newPasswordController,
    required this.confirmNewPasswordController,
    required this.onRequestReset,
    required this.onConfirmReset,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // La condición "if (currentStep == 0)" decide qué formulario mostrar.
        // Si el paso actual es 0 (primera pantalla), muestra el campo de email y el botón.
        if (currentStep == 0) ...[
          TextField(
            controller: emailController,
            decoration: const InputDecoration(
              labelText: 'Correo electrónico',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.email),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            // Al presionar, llama al método que el handler le pasó.
            onPressed: onRequestReset,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text('Solicitar código', style: TextStyle(fontSize: 18)),
          ),
        ] else ...[
          // Si el paso actual no es 0, muestra el formulario de confirmación.
          TextField(
            controller: emailController,
            decoration: const InputDecoration(
              labelText: 'Correo electrónico',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.email),
            ),
            readOnly: true, // El usuario no puede editar el email en este paso.
          ),
          const SizedBox(height: 16),
          TextField(
            controller: codeController,
            decoration: const InputDecoration(
              labelText: 'Código de verificación',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.vpn_key),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: newPasswordController,
            decoration: const InputDecoration(
              labelText: 'Nueva contraseña',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.lock),
            ),
            obscureText: true, // Oculta los caracteres de la contraseña.
          ),
          const SizedBox(height: 16),
          TextField(
            controller: confirmNewPasswordController,
            decoration: const InputDecoration(
              labelText: 'Confirmar nueva contraseña',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.lock),
            ),
            obscureText: true,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            // Llama al método de confirmación en el handler.
            onPressed: onConfirmReset,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text('Confirmar nueva contraseña', style: TextStyle(fontSize: 18)),
          ),
        ],
      ],
    );
  }
}