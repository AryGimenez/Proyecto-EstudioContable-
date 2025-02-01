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

  // constante utilizasa para guardar el mensaje cuando el usurio no ingresa correo
  static const String REQUIRE_EMAI_ERROR_MESSAG =
      'Por favor ingrese su correo electrónico';

  // constante utilizada para Guardar el mensjae de error al colocar un email sin el formato apropiado.
  static const String EMAIL_INCORRECT_ERROR_MENSGE =
      'Por favor ingrese un correo electrónico válido';

  // Mensaje de error que va a mostrar el campo de texto email
  String? emailErrorMensaje = null;

  static const String CODE_VER_ERROR_MENSAJE =
      'Por favor ingrese el código de verificación';

  // Mensaje de error que va a mostra cuando el texto de codigo verificacion no es correcto
  String? codeVerErrorMensaje = null;

  static const String PASSWORD_ERROR_MESSAG =
      'Por favor ingrese su nueva contraseña';

  /// Mensaje de error que va a mostrar cuando el campo de pasword esta ma l
  String? passwordErroMensaje = null;

  static const String CONFIR_PASSWORD_ERROR_MENSAG =
      'Por favor confirme su nueva contraseña';

  static const String CONFIR_PASSWORD_ERROR_MENSAG_2 =
      'Las contraseñas no coinciden';

  /// Mensaje de error que va a mostra rcuando el campo de confirmar pasword no es correcto
  String? configPasswordErrorMensaje = null;

  @override
  void dispose() {
    _emailController
        .dispose(); // Libera los recursos utilizados por los controladores cuando el widget es destruido
    _verificationCodeController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// Metodo que evalua si el email ingresado cumple los parametro y dispara el erro
  /// el error en el TextFormatFile email
  bool _emailValidator() {
    String email = _emailController.text;
    bool xRespuesta = false;
    if (email == null || email.isEmpty) {
      emailErrorMensaje = REQUIRE_EMAI_ERROR_MESSAG;
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      emailErrorMensaje = EMAIL_INCORRECT_ERROR_MENSGE;
    } else {
      emailErrorMensaje = null;
      xRespuesta = true;
    }
    _formKey.currentState?.validate();

    return xRespuesta; // Si la validación es exitosa, retorna null
  }

  // Metodo para pasar por al PasswordResetFrom para la validacion de email
  String? _validateEmail(String? email) {
    return emailErrorMensaje;
  }

  /// Metodo disaprado cuando presiono el boton enviar codigo validacion
  void _sendCode() {
    if (_emailValidator()) {
      setState(() {
        _isVerificationCodeSent =
            true; // Actualiza el estado para indicar que el código ha sido verificado
      });
      // Aquí manejas la lógica de verificación del código
    }

    // // Metodo que se lanza cuando se presiona el boton enviar codigo
    // if (_formKey.currentState?.validate() ?? false) {
    //   setState(() {
    //     _isVerificationCodeSent =
    //         true; // Actualiza el estado para indicar que el código ha sido enviado
    //   });
    //   // Aquí envías el correo de verificación
    // }
  }

  /// Metodo utilizado para validar el codigo de validacion y en caso de erro mandar
  /// dispara el evento validation en el control
  bool _codeVerifiedValidator() {
    String? value = _verificationCodeController.text;
    bool xRespuesta = false;

    // Validador que verifica si el campo de código contiene texto válido.
    if (value == null || value.isEmpty) {
      // Si el valor está vacío o es nulo, muestra un mensaje de error.
      codeVerErrorMensaje = CODE_VER_ERROR_MENSAJE;
    } else {
      xRespuesta = true;
      codeVerErrorMensaje = null;
    }

    _formKey.currentState
        ?.validate(); // lanza el evento validate en el formulario PaswordResetFrom
    return xRespuesta; // Si el valor es válido, no retorna ningún error.
  }

  /// Metodo para pasar por al PasswordResetFrom para la validacion campo codigo
  /// validacion
  String? _validateCodeVerified(String? codeVer) {
    return codeVerErrorMensaje;
  }

  /// Metoo que se lanza cuando preciona el botton Verificar Codigo
  void _verifyCode() {
    if (_codeVerifiedValidator()) {
      // Falta Codigo Valiacion
      setState(() {
        _isCodeVerified =
            true; // Avilita el ingreso de los campos password y confirmar password
      });
    }

    // Codigo anterior hay que sacarlo cuando corrobore que esta bien
    // _isEmailValidator = true;

    // if (_validateEmail(_emailController.text) != null) {
    //   setState(() {
    //     _isCodeVerified =
    //         true; // Actualiza el estado para indicar que el código ha sido verificado
    //   });
    //   // Aquí manejas la lógica de verificación del código
    // } else {
    //   _formKey.currentState?.validate();
    //   _isCodeVerified = false;
    // }
  }

  bool _passwordValidator() {
    String? value = _passwordController.text;
    bool xRespuesta = false;

    if (value == null || value.isEmpty) {
      // si el valor esta vasio o es nulo, muestar un mensaje de error
      passwordErroMensaje = PASSWORD_ERROR_MESSAG;
    } else {
      passwordErroMensaje = null;
      xRespuesta = true;
    }
    _formKey.currentState
        ?.validate(); // lanza el evento validar en el formulario ResetPasword
    return xRespuesta;
  }

  /// Metodo que se lanza cuando valida el campo Password
  String? _validatePassword(String? mPassword) {
    return passwordErroMensaje;
  }

  bool _passwordConfirmValidator() {
    String? value = _confirmPasswordController.text;
    bool xRespuesta = false;

    if (value == null || value.isEmpty) {
      // si el valor esta vasio o es nulo, muestar un mensaje de error
      configPasswordErrorMensaje = CONFIR_PASSWORD_ERROR_MENSAG;
    } else if (value != _passwordController.text) {
      configPasswordErrorMensaje = CONFIR_PASSWORD_ERROR_MENSAG_2;
    } else {
      configPasswordErrorMensaje = null;
      xRespuesta = true;
    }
    _formKey.currentState
        ?.validate(); // lanza el evento validar en el formulario ResetPasword
    return xRespuesta;
  }

  /// Metodo que se lanza cuando se presiona el boton de Resetear Contrasenia
  void _submitForm() {
    if (_passwordConfirmValidator()) {}
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
            onValidateEmail: _validateEmail),
      ),
    );
  }
}
