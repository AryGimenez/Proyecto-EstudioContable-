// frontend/flutter_gestion_contable/lib/screens/password_reset/password_reset_handler.dart

import 'package:flutter/material.dart';
import 'package:flutter_gestion_contable/services/api_service.dart';
import 'package:flutter_gestion_contable/screens/password_reset/password_reset_form.dart'; 

/// Widget con estado (Stateful) que actúa como el **Handler** (Manejador) de la pantalla
/// de restablecimiento de contraseña.
///
/// **Responsabilidades Clave:**
/// 1. **Manejo de Lógica de Negocio:** Contiene la lógica de validación y el flujo 
///    de dos pasos (solicitud y confirmación).
/// 2. **Gestión del Estado:** Almacena el estado interno, como los controladores de texto
///    y el paso actual del flujo (`_currentStep`).
/// 3. **Comunicación con la API:** Interactúa con [ApiService] para realizar las 
///    operaciones asíncronas de reseteo.
/// 4. **Orquestación:** Pasa todos los datos y métodos de acción al widget de formulario ([PasswordResetForm]).
class PasswordResetHandler extends StatefulWidget {
  
  // <!> Esto no se si es nesesiario pero por lo que entendi 
  // <!> por lo que enteidi es para reutilisar el componentes 
  // <!> Tengo que profunndisar
  const PasswordResetHandler({super.key}); 

  // Define la clase de estado que contiene toda la lógica de negocio y variables
  // mutables (controladores, paso actual, etc.) de la pantalla de reseteo.
  // Esta clase se mantiene viva mientras el widget está montado.
  @override
  State<PasswordResetHandler> createState() => _PasswordResetHandlerState();
}

/// Estado asociado al [PasswordResetHandler].
///
/// Esta clase es el **cerebro** de la pantalla de reseteo, ya que gestiona todo el 
/// estado mutable y la lógica de negocio.
///
/// **Responsabilidades:**
/// 1. **Controladores:** Almacena los [TextEditingController]s para leer los datos 
///    de los campos del formulario.
/// 2. **Flujo de Pasos:** Mantiene la variable `_currentStep` para controlar si se 
///    muestra el formulario de solicitud (Paso 0) o el de confirmación (Paso 1).
/// 3. **Validación y Lógica:** Implementa los métodos de validación, realiza las 
///    llamadas asíncronas a la [ApiService], y actualiza la interfaz mediante [setState].
/// 4. **Limpieza:** Implementa el método [dispose] para liberar recursos.
class _PasswordResetHandlerState extends State<PasswordResetHandler> {
  // Controladores para obtener el texto de los campos del formulario.
  final _emailController = TextEditingController(); // Controldaor email
  final _codeController = TextEditingController(); // Controlador Codigo de verificacion
  final _newPasswordController = TextEditingController(); // Controlador Nueva contraseña
  final _confirmNewPasswordController = TextEditingController(); // Controlador Confirmar contraseña
  

  
  int _currentStep = 0; // Variable de estado que controla qué "paso" del formulario se muestra (0 para email, 1 para código).

  /// Método para el primer paso del flujo: **solicitar un código de reseteo** al backend.
  /// 
  /// Este método realiza las siguientes acciones de forma asíncrona:
  /// 1. **Validación Inicial:** Verifica que el campo de correo electrónico no esté vacío 
  ///    y tenga un formato básico de email.
  /// 2. **Llamada a la API:** Llama al método `requestPasswordReset` de [ApiService].
  /// 3. **Manejo del Estado:** Si la respuesta de la API es exitosa:
  ///    - Llama a [setState] para **cambiar `_currentStep` a 1**, lo que renderiza 
  ///      el formulario de confirmación ([PasswordResetForm]).
  ///    - Muestra un [SnackBar] de éxito.
  /// 4. **Manejo de Errores:** Si falla, muestra el mensaje de error de la API.
  void _requestPasswordReset() async {
    final email = _emailController.text; // Obtiene el texto del campo de correo electrónico.
    if (email.isEmpty || !email.contains('@')) { // Valida si el correo electrónico está vacío o no contiene '@'.
      _showSnackBar('Por favor, ingrese un correo válido.'); // Muestra un mensaje de error si el correo no es válido.
      return;
    }

    final result = await ApiService().requestPasswordReset(email); // Llama al método del ApiService para enviar la solicitud al backend.
    
    if (mounted) { // Verifica si el widget sigue montado antes de actualizar el estado.
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

  /// Método para el segundo paso del flujo: **confirmar el reseteo de contraseña** con el backend.
  ///
  /// Este método se encarga de:  
  /// 1. **Validaciones Locales:** Verifica que el código y ambos campos de contraseña no estén vacíos.
  /// 2. **Validación de Coincidencia:** Asegura que la nueva contraseña y su confirmación sean idénticas.
  /// 3. **Llamada a la API:** Envía el email, el código de verificación y la nueva contraseña a 
  ///    `ApiService.confirmPasswordReset`.
  /// 4. **Resultado Exitoso:** Si la API responde con éxito, navega de regreso a la pantalla anterior (generalmente Login)   
  ///    y muestra un mensaje de éxito.
  /// 5. **Manejo de Errores:** Si las validaciones locales o la llamada a la API fallan, muestra el [SnackBar] 
  ///    con el mensaje de error correspondiente.
  void _confirmPasswordReset() async {
    final email = _emailController.text; // Obtiene el texto del campo de correo electrónico.
    final code = _codeController.text; // Obtiene el texto del campo de código de verificación.
    final newPassword = _newPasswordController.text; // Obtiene el texto del campo de nueva contraseña.
    final confirmPassword = _confirmNewPasswordController.text; // Obtiene el texto del campo de confirmar contraseña.

    // Validación de campos vacíos.
    if (code.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      _showSnackBar('Por favor, complete todos los campos.');
      return;
    }

    // Validación de coincidencia de contraseñas.
    if (newPassword != confirmPassword) {
      _showSnackBar('Las contraseñas no coinciden.');
      return;
    }

    // Llama al método del ApiService para confirmar el reseteo con el backend.
    // final result = await ApiService().confirmPasswordReset(email, code, newPassword);

    final result = null;


    // Verifica si el widget sigue montado antes de actualizar el estado.
    if (mounted) {
      if (result['success']) { // Verifica si la confirmación fue exitosa.
        Navigator.of(context).pop(); // Si la confirmación es exitosa, regresa a la pantalla anterior (login).
        _showSnackBar('Contraseña actualizada con éxito.');
      } else {
        _showSnackBar(result['message'] ?? 'Error al actualizar la contraseña.');
      }
    }
  }

  /// Método auxiliar para **mostrar mensajes de retroalimentación** al usuario 
  /// mediante un [SnackBar].
  ///
  /// Este método proporciona una forma consistente de notificar al usuario sobre:
  /// 1. Errores de validación locales (ej. campos vacíos, contraseñas no coinciden).
  /// 2. Resultados de llamadas a la API (éxito o error).
  ///
  /// @param message La cadena de texto que se mostrará en el SnackBar.
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  /// Método para construir la interfaz de usuario de la pantalla de restablecimiento de contraseña.
  ///
  /// Este método se encarga de:
  /// 1. **Proporcionar la estructura básica** de la pantalla utilizando un [Scaffold].
  /// 2. **Incluir un [AppBar]** con el título "Restablecer Contraseña".
  /// 3. **Permitir el desplazamiento** del contenido si es necesario mediante un [SingleChildScrollView].
  /// 4. **Incorporar el formulario de restablecimiento** ([PasswordResetForm]) con los campos necesarios.
  @override
  Widget build(BuildContext context) {
    
    return Scaffold( // Scaffold proporciona la estructura básica de la pantalla.
      appBar: AppBar( // AppBar incluye un título para la pantalla.
        title: const Text('Restablecer Contraseña'), 
      ),
     
      body: SingleChildScrollView(  // SingleChildScrollView permite que la pantalla sea desplazable si el contenido es muy grande.
        child: Padding( // Padding agrega espacio alrededor del formulario para mejorar la legibilidad.
          padding: const EdgeInsets.all(16.0), // Añade 16.0 de espacio en todos los lados.
          child: PasswordResetForm(  // Envía todos los controladores y métodos al widget del formulario.
            currentStep: _currentStep, // Pasa el estado actual del paso del formulario.
            emailController: _emailController, // Pasa el controlador de texto para el correo electrónico.
            codeController: _codeController, // Pasa el controlador de texto para el código de verificación.
            newPasswordController: _newPasswordController, // Pasa el controlador de texto para la nueva contraseña.
            confirmNewPasswordController: _confirmNewPasswordController, // Pasa el controlador de texto para confirmar la nueva contraseña.
            onRequestReset: _requestPasswordReset, // Pasa el método para solicitar el restablecimiento de contraseña.
            onConfirmReset: _confirmPasswordReset, // Pasa el método para confirmar el restablecimiento de contraseña.
          ),
        ),
      ),
    );
  }
  
  /// Método llamado cuando este objeto [State] es eliminado permanentemente del árbol
  /// de widgets (por ejemplo, al navegar fuera de la pantalla de reseteo).
  ///
  /// Es fundamental para **liberar los recursos** asociados a los [TextEditingController]s 
  /// para prevenir fugas de memoria en la aplicación.
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