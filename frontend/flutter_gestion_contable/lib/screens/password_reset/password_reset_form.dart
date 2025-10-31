// frontend/flutter_gestion_contable/lib/screens/password_reset/password_reset_form.dart

import 'package:flutter/material.dart';

/// Widget presentacional (Stateless) para el formulario de restablecimiento de contraseña.
/// 
/// Este widget se encarga exclusivamente de la apariencia visual y no contiene lógica
/// de negocio o manejo de estado interno. Recibe todos los controladores de texto 
/// y los callbacks de acción (onPressed) desde el [PasswordResetHandler].
class PasswordResetForm extends StatelessWidget {
  // Las propiedades (props) que el handler le pasa al formulario.
  final int currentStep; /// Paso actual del flujo de reseteo (0: Solicitud de Email; 1: Código y Nueva Clave).
  final TextEditingController emailController; /// Controlador para el campo de correo electrónico.
  final TextEditingController codeController; /// Controlador para el campo del código de verificación.
  final TextEditingController newPasswordController; /// Controlador para el campo de nueva contraseña.
  final TextEditingController confirmNewPasswordController; /// Controlador para el campo de confirmación de nueva contraseña.
  final VoidCallback onRequestReset; /// Callback para solicitar el restablecimiento de contraseña.
  final VoidCallback onConfirmReset; /// Callback para confirmar el restablecimiento de contraseña.

  
  
  /// Constructor de la clase [PasswordResetForm].
  /// 
  /// Este constructor requiere todos los parámetros para que el formulario pueda 
  /// vincular los campos de texto a los [TextEditingController]s y los botones
  /// a sus respectivas funciones de acción.
  ///
  /// @param currentStep Indica el paso actual del flujo (0 o 1) para renderizar
  /// el conjunto de campos correspondiente.
  /// @param emailController Controlador para capturar o mostrar el email.
  /// @param codeController Controlador para el código de verificación.
  /// @param newPasswordController Controlador para la nueva contraseña.
  /// @param confirmNewPasswordController Controlador para confirmar la nueva contraseña.
  /// @param onRequestReset Callback ejecutado al presionar "Solicitar código" (Paso 0)./// @param onConfirmReset Callback ejecutado al presionar "Confirmar nueva contraseña" (Paso 1).
  /// @param onConfirmReset Callback ejecutado al presionar "Confirmar nueva contraseña" (Paso 1).
  const PasswordResetForm({ //<!> Porque este constructor pide todos los parametros porque lo nesesitaria 
    super.key,
    required this.currentStep,
    required this.emailController,
    required this.codeController,
    required this.newPasswordController,
    required this.confirmNewPasswordController,
    required this.onRequestReset,
    required this.onConfirmReset,
  });

  /// Método que construye la interfaz de usuario para la pantalla de restablecimiento de contraseña.
  /// 
  /// 1. **Estructura Principal:** Devuelve un [Scaffold] con una [AppBar] que muestra el título.
  /// 2. **Scroll:** Utiliza un [SingleChildScrollView] para garantizar que la pantalla sea
  ///    desplazable si el teclado en pantalla o el contenido son demasiado grandes (prevención de overflow).
  /// 3. **Conexión de Widgets:** Instancia el widget presentacional [PasswordResetForm] y le pasa
  ///    los siguientes elementos que gestiona el Handler (Lógica):
  ///    * Los [TextEditingController]s (para la lectura/escritura de campos).
  ///    * El estado actual del flujo (`_currentStep`).
  ///    * Los callbacks de acción (`_requestPasswordReset` y `_confirmPasswordReset`).
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // La condición "if (currentStep == 0)" decide qué formulario mostrar.
        // Si el paso actual es 0 (primera pantalla), muestra el campo de email y el botón.
        if (currentStep == 0) ...[
          TextField( // Campo de correo electrónico.
            controller: emailController, // Controlador pasado desde el handler.
            decoration: const InputDecoration( // Decoración del campo.
              labelText: 'Correo electrónico', // Etiqueta del campo.
              border: OutlineInputBorder(), // Borde del campo.
              prefixIcon: Icon(Icons.email), // Icono al inicio del campo.
            ),
            keyboardType: TextInputType.emailAddress, // Tipo de teclado para email.
          ),
          const SizedBox(height: 24), // Espacio entre el campo y el botón.
          ElevatedButton( // Botón para solicitar el código de restablecimiento.
            // Al presionar, llama al método que el handler le pasó.
            onPressed: onRequestReset, // Callback pasado desde el handler.
            style: ElevatedButton.styleFrom( // Estilo del botón.
              minimumSize: const Size(double.infinity, 50), // Ancho completo y altura fija.
            ),
            child: const Text('Solicitar código', style: TextStyle(fontSize: 18)),// Texto del botón.
          ),
        ] else ...[ // Si el paso actual no es 0, muestra el formulario de confirmación.
          // Si el paso actual no es 0, muestra el formulario de confirmación.
          TextField(// Campo de correo electrónico (solo lectura).
            controller: emailController, // Controlador pasado desde el handler.
            decoration: const InputDecoration( // Decoración del campo.
              labelText: 'Correo electrónico', // Etiqueta del campo.
              border: OutlineInputBorder(), // Borde del campo.
              prefixIcon: Icon(Icons.email), // Icono al inicio del campo.
            ),
            readOnly: true, // El usuario no puede editar el email en este paso.
          ),
          const SizedBox(height: 16), // Espacio entre los campos.
          TextField( // Campo para el código de verificación.
            controller: codeController, // Controlador pasado desde el handler.
            decoration: const InputDecoration( // Decoración del campo.
              labelText: 'Código de verificación', // Etiqueta del campo.
              border: OutlineInputBorder(), // Borde del campo.
              prefixIcon: Icon(Icons.vpn_key), // Icono al inicio del campo.
            ),
            keyboardType: TextInputType.number, // Tipo de teclado numérico.
          ),
          const SizedBox(height: 16), // Espacio entre los campos.
          TextField( // Campo para la nueva contraseña.
            controller: newPasswordController, // Controlador pasado desde el handler.
            decoration: const InputDecoration( // Decoración del campo.
              labelText: 'Nueva contraseña', // Etiqueta del campo.
              border: OutlineInputBorder(), // Borde del campo.
              prefixIcon: Icon(Icons.lock), // Icono al inicio del campo.
            ),
            obscureText: true, // Oculta los caracteres de la contraseña.
          ),
          const SizedBox(height: 16), // Espacio entre los campos.
          TextField( // Campo para confirmar la nueva contraseña.
            controller: confirmNewPasswordController, // Controlador pasado desde el handler.
            decoration: const InputDecoration( // Decoración del campo.
              labelText: 'Confirmar nueva contraseña', // Etiqueta del campo.
              border: OutlineInputBorder(), // Borde del campo.
              prefixIcon: Icon(Icons.lock),
            ),
            obscureText: true, // Oculta los caracteres de la contraseña.
          ),
          const SizedBox(height: 24), // Espacio entre el último campo y el botón.
          ElevatedButton( // Botón para confirmar la nueva contraseña.
            // Llama al método de confirmación en el handler.
            onPressed: onConfirmReset, // Callback pasado desde el handler.
            style: ElevatedButton.styleFrom( // Estilo del botón.
              minimumSize: const Size(double.infinity, 50), // Ancho completo y altura fija.
            ),
            child: const Text('Confirmar nueva contraseña', style: TextStyle(fontSize: 18)), // Texto del botón.
          ),
        ],
      ],
    );
  }
}