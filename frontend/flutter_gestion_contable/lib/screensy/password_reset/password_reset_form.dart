// lib/screens/login/login_form.dart

import 'package:flutter/material.dart';
import 'package:flutter_gestion_contable/core/theme/app_text_styles.dart'; // Importa la librería de Material Design de Flutter, utilizada para crear interfaces de usuario.
import 'package:flutter_gestion_contable/core/theme/app_colors.dart';
import 'package:flutter_gestion_contable/core/theme/app_styles.dart';

import 'password_reset_styles.dart';

class PasswordResetForm extends StatelessWidget {
  // Define un widget sin estado que representa un formulario de restauracion de contrasenia.
  final GlobalKey<FormState> formKey = GlobalKey<
      FormState>(); // Clave global utilizada para identificar y manejar el estado del formulario.
  final TextEditingController emailController =
      TextEditingController(); // Controlador para gestionar el texto ingresado en el campo de correo electrónico.
  final TextEditingController verificationCodeController =
      TextEditingController(); // Controlador para gestionar el texto ingresado en el campo de código de verificación.
  final TextEditingController passwordController =
      TextEditingController(); // Controlador para gestionar el texto ingresado en el campo de nueva contraseña.
  final TextEditingController confirmPasswordController =
      TextEditingController(); // Controlador para gestionar el texto ingresado en el campo de confirmación de contraseña.

  bool isVerificationCodeSent =
      false; // Bandera que indica si el código de verificación ha sido enviado.
  bool isCodeVerified =
      false; // Bandera que indica si el código de verificación ha sido verificado.

const PasswordResetForm({
  super.key,
  required this.formKey,
  required this.emailController,
  required this.verificationCodeController,
  required this.passwordController,
  required this.confirmPasswordController,
  required this.isVerificationCodeSent,
  required this.isCodeVerified,
  required this.onSendCode,
  required this.onVerifyCode,
  required this.onSubmit,
});



  @override
  Widget build(BuildContext context) {
    // Construye el widget principal que representa el formulario.
      return Center(
        // Centra el contenido en el ejes horizontal y vertical
        child: SingleChildSEnviarcrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: formMaxWidth, // Ajusta este valor según tu necesidad
            ),
            child: Padding(
              padding: formPadding, // Espaciado horizontal para el contenido, este valor está en password_reset_style.dart
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // Centra los elementos verticalmente
                children: [
                  Text( // Título del formulario
                    'Reseteador de Contraseña', 
                    style: AppTextStyles.headline1, // Estilo H1
                  ),
                  verticalSpaceLarge, // Espaciado entre el título y el formulario, definido en login_Styles.dart
                  
                  Form(
                    key: formKey, // Asocia la clave del formulario para manejar su estado (por ejemplo, validaciones)
                    child: Column(
                      children: [
                        _buildEmailField(), // Campo de texto para el correo electrónico
                        verticalSpaceSmall, // Espaciado entre campos de texto
                        _buildSendCodeButton(), // Botón para enviar el código de verificación
                        verticalSpaceMedium, // Espaciado antes del campo de código de verificación
                        _buildVerificationCodeField(), // Campo de texto para el código de verificación
                        verticalSpaceSmall, // Espaciado entre campos de texto
                        _buildVerifyCodeButton(), // Botón para verificar el código
                        verticalSpaceMedium, // Espaciado antes de los campos de nueva contraseña
                        _buildPasswordField(), // Campo de texto para la nueva contraseña
                        verticalSpaceSmall, // Espaciado entre campos de texto
                        _buildConfirmPasswordField(), // Campo de texto para confirmar la nueva contraseña
                        verticalSpaceMedium, // Espaciado antes del botón de cambiar contraseña
                        _buildResetPasswordButton(), // Botón para cambiar la contraseña
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
  }

  Widget _buildEmailField() {
    // Método privado que construye el campo de texto para el correo electrónico.
    return TextFormField(
      controller: emailController, // Vincula el campo de texto con el controlador para gestionar su contenido.
      decoration: InputDecoration(
        labelText: 'Correo Electrónico', // Etiqueta que indica al usuario qué debe ingresar en el campo.
        prefixIcon: Icon(Icons.email), // Icono de correo que aparece al inicio del campo de texto como referencia visual.
      ),
      validator: (value) {
        // Validador que verifica si el campo de correo contiene texto válido.
        if (value == null || value.isEmpty) {
          // Si el valor está vacío o es nulo, muestra un mensaje de error.
          return 'Por favor ingrese su correo electrónico';
        } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          // Si el valor no coincide con un patrón de correo válido, muestra un mensaje de error.
          return 'Por favor ingrese un correo electrónico válido';
        }
        return null; // Si el valor es válido, no retorna ningún error.
      },
    );
  }
    
  Widget _buildSendCodeButton() {
    // Método privado que construye el botón para enviar el código de verificación.
    return ElevatedButton(
      onPressed: () {
        if (formKey.currentState!.validate()) {
          setState(() {
            isVerificationCodeSent = true; // Actualiza la bandera para indicar que el código ha sido enviado.
          });
          // Aquí envías el correo de verificación.
        }
      },
      child: Text(
        isVerificationCodeSent ? 'Reenviar Código de Verificación' : 
        'Enviar Código de Verificación'), // Texto que aparece dentro del botón.
    );
  }


  Widget _buildVerificationCodeField() {
    // Método privado que construye el campo de texto para el código de verificación.
    return TextFormField(
      controller: verificationCodeController, // Vincula el campo de texto con el controlador para gestionar su contenido.
      decoration: InputDecoration(
        labelText: 'Código de Verificación', // Etiqueta que indica al usuario que debe ingresar el código de verificación.
        prefixIcon: Icon(Icons.lock), // Icono de candado que aparece al inicio del campo de texto como referencia visual.
      ),
      validator: (value) {
        // Validador que verifica si el campo de código contiene texto válido.
        if (value == null || value.isEmpty) {
          // Si el valor está vacío o es nulo, muestra un mensaje de error.
          return 'Por favor ingrese el código de verificación';
        }
        return null; // Si el valor es válido, no retorna ningún error.
      },
      enabled: isVerificationCodeSent, // Deshabilita el campo si el código no se ha enviado.
    );
  }


  Widget _buildVerifyCodeButton() {
    // Método privado que construye el botón para verificar el código de verificación.
    return ElevatedButton(
      onPressed: isVerificationCodeSent ? () {
        if (formKey.currentState!.validate()) {
          setState(() {
            isCodeVerified = true; // Actualiza la bandera para indicar que el código ha sido verificado.
          });
          // Aquí manejas la lógica de verificación del código.
        }
      } : null, // Deshabilita el botón si el código no se ha enviado.
      child: Text('Verificar Código'), // Texto que aparece dentro del botón.
    );
  }


  Widget _buildPasswordField() {
    // Método privado que construye el campo de texto para la nueva contraseña.
    return TextFormField(
      controller: passwordController, // Vincula el campo de texto con el controlador para gestionar su contenido.
      decoration: InputDecoration(
        labelText: 'Nueva Contraseña', // Etiqueta que indica al usuario que debe ingresar su nueva contraseña.
        prefixIcon: Icon(Icons.lock), // Icono de candado que aparece al inicio del campo como referencia visual.
      ),
      obscureText: true, // Oculta el texto del campo para mayor seguridad.
      validator: (value) {
        // Validador que verifica si el campo de nueva contraseña contiene texto válido.
        if (value == null || value.isEmpty) {
          // Si el valor está vacío o es nulo, muestra un mensaje de error.
          return 'Por favor ingrese su nueva contraseña';
        }
        return null; // Si el valor es válido, no retorna ningún error.
      },
      enabled: isCodeVerified, // Deshabilita el campo si el código no se ha verificado.
    );
  }


  Widget _buildConfirmPasswordField() {
    // Método privado que construye el campo de texto para confirmar la nueva contraseña.
    return TextFormField(
      controller: confirmPasswordController, // Vincula el campo de texto con el controlador para gestionar su contenido.
      decoration: InputDecoration(
        labelText: 'Confirmar Nueva Contraseña', // Etiqueta que indica al usuario que debe confirmar su nueva contraseña.
        prefixIcon: Icon(Icons.lock), // Icono de candado que aparece al inicio del campo como referencia visual.
      ),
      obscureText: true, // Oculta el texto del campo para mayor seguridad.
      validator: (value) {
        // Validador que verifica si el campo de confirmación contiene texto válido.
        if (value == null || value.isEmpty) {
          // Si el valor está vacío o es nulo, muestra un mensaje de error.
          return 'Por favor confirme su nueva contraseña';
        } else if (value != passwordController.text) {
          // Si las contraseñas no coinciden, muestra un mensaje de error.
          return 'Las contraseñas no coinciden';
        }
        return null; // Si el valor es válido, no retorna ningún error.
      },
      enabled: isCodeVerified; // Deshabildf
  };

  
    
}
