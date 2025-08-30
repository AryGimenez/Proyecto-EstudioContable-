// class PasswordResetForm extends StatelessWidget {
//   final GlobalKey<FormState>
//       formKey; // Llave global para manejar el estado del formulario
//   final TextEditingController
//       emailController; // Controlador para el campo de correo electrónico
//   final bool
//       isVerificationCodeSent; // Indica si el código de verificación ha sido enviado
//   final VoidCallback
//       onSendCode; // Callback para enviar el código de verificación
//   final Function
//       onValidateEmail; // Callback para validar el campo de correo electrónico

//   PasswordResetForm({
//     required this.formKey, // Inicializa la llave del formulario
//     required this.emailController, // Inicializa el controlador del campo de correo electrónico
//     required this.isVerificationCodeSent, // Inicializa el estado del código de verificación
//     required this.onSendCode, // Inicializa el callback para enviar el código de verificación
//     required this.onValidateEmail, // Inicializa el callback para validar el campo de correo electrónico
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: formKey, // Asigna la llave global del formulario
//       child: Column(
//         children: [
//           _buildEmailField(), // Construye el campo de correo electrónico
//           _buildSendCodeButton(), // Construye el botón para enviar el código de verificación
//           _buildVerificationCodeField(), // Construye el campo de código de verificación
//         ],
//       ),
//     );
//   }

//   Widget _buildEmailField() {
//     // Método privado para construir el campo de correo electrónico
//     return TextFormField(
//       controller:
//           emailController, // Asigna el controlador al campo de correo electrónico
//       decoration: InputDecoration(
//         labelText:
//             'Correo Electrónico', // Etiqueta del campo de correo electrónico
//         prefixIcon: Icon(Icons.email), // Icono del campo de correo electrónico
//       ),
//       validator: (value) {
//         // Valida el valor ingresado en el campo de correo electrónico
//         if (value == null || value.isEmpty) {
//           return 'Por favor ingrese su correo electrónico';
//         } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
//           return 'Por favor ingrese un correo electrónico válido';
//         }
//         return null; // Si la validación es exitosa, retorna null
//       },
//     );
//   }

//   Widget _buildSendCodeButton() {
//     // Método privado para construir el botón de enviar código
//     return ElevatedButton(
//       onPressed:
//           onSendCode, // Llama al callback para enviar el código de verificación
//       child: Text(
//         isVerificationCodeSent
//             ? 'Reenviar Código de Verificación'
//             : 'Enviar Código de Verificación', // Texto del botón
//       ),
//     );
//   }

//   Widget _buildVerificationCodeField() {
//     // Método privado para construir el campo de código de verificación
//     return TextFormField(
//       decoration: InputDecoration(
//         labelText:
//             'Código de Verificación', // Etiqueta del campo de código de verificación
//         prefixIcon:
//             Icon(Icons.lock), // Icono del campo de código de verificación
//       ),
//       enabled:
//           isVerificationCodeSent, // Habilita el campo solo si el código de verificación ha sido enviado
//     );
//   }

//   // Método para validar el campo de correo electrónico
//   bool validateEmailField() {
//     return formKey.currentState?.validate() ??
//         false; // Valida el formulario y retorna el resultado
//   }
// }

// // -------------------------------------------------------------------------------------------------------------

// class _PasswordResetHandlerState extends State<PasswordResetHandler> {
//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();
//   final _verificationCodeController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();

//   bool _isVerificationCodeSent = false;
//   bool _isCodeVerified = false;

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _verificationCodeController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }

//   // Método para enviar el código de verificación
//   void _sendCode() {
//     final email = _emailController
//         .text; // Obtiene el valor del campo de correo electrónico
//     final emailFieldValid =
//         _emailValidator(email); // Valida el campo de correo electrónico

//     if (emailFieldValid == null) {
//       // Si el campo de correo electrónico es válido
//       setState(() {
//         _isVerificationCodeSent =
//             true; // Actualiza el estado para indicar que el código ha sido enviado
//       });
//       // Aquí envías el correo de verificación
//     } else {
//       // Si el campo de correo electrónico no es válido, muestra el mensaje de error
//       print(emailFieldValid); // Mostrar el mensaje de error en la consola
//     }
//   }

//   // Método de validación del correo electrónico
//   String? _emailValidator(String email) {
//     if (email.isEmpty) {
//       return 'Por favor ingrese su correo electrónico';
//     } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
//       return 'Por favor ingrese un correo electrónico válido';
//     }
//     return null; // Si la validación es exitosa, devuelve null
//   }

//   // Método para verificar el código de verificación
//   void _verifyCode() {
//     if (_verificationCodeController.text.isNotEmpty) {
//       // Verifica si el campo de código no está vacío
//       setState(() {
//         _isCodeVerified =
//             true; // Actualiza el estado para indicar que el código ha sido verificado
//       });
//       // Aquí manejas la lógica de verificación del código
//     }
//   }

//   // Método para restablecer la contraseña
//   void _submitForm() {
//     if (_formKey.currentState?.validate() ?? false) {
//       // Aquí manejas el restablecimiento de la contraseña
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Restablecer Contraseña')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: PasswordResetForm(
//           formKey: _formKey,
//           emailController: _emailController,
//           verificationCodeController: _verificationCodeController,
//           passwordController: _passwordController,
//           confirmPasswordController: _confirmPasswordController,
//           isVerificationCodeSent: _isVerificationCodeSent,
//           isCodeVerified: _isCodeVerified,
//           onSendCode: _sendCode,
//           onVerifyCode: _verifyCode,
//           onSubmit: _submitForm,
//         ),
//       ),
//     );
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:flutter_gestion_contable/core/theme/app_text_styles.dart';
// import 'package:flutter_gestion_contable/core/theme/app_colors.dart';
// import 'package:flutter_gestion_contable/core/theme/app_styles.dart';

// import 'password_reset_styles.dart';

// class PasswordResetForm extends StatelessWidget {
//   // ... (resto de tu código)

//   // Método para construir un TextFormField personalizado con validación
//   Widget _buildTextFormField({
//     required TextEditingController controller,
//     required String labelText,
//     required String? Function(String?) validator,
//     IconData? prefixIcon,
//     bool obscureText = false,
//     bool enabled = true,
//   }) {
//     return TextFormField(
//       controller: controller,
//       decoration: InputDecoration(
//         labelText: labelText,
//         prefixIcon: Icon(prefixIcon),
//         errorStyle: TextStyle(
//           color: Colors.red, // Color del mensaje de error
//           fontSize: 12, // Tamaño de la fuente del mensaje de error
//         ),
//       ),
//       obscureText: obscureText,
//       enabled: enabled,
//       validator: validator,
//     );
//   }

//   // ... (resto de tus métodos)

//   @override
//   Widget build(BuildContext context) {
//     // ... (resto de tu código)

//     return Column(
//       children: [
//         _buildTextFormField(
//           controller: emailController,
//           labelText: 'Correo Electrónico',
//           prefixIcon: Icons.email,
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return 'Por favor ingrese su correo electrónico';
//             }
//             // ... otras validaciones
//           },
//         ),
//         // ... otros TextFormField
//       ],
//     );
//   }
// }


// -----------

// void validarCampo(TextFormField textField) {
//   final formState = textField.formKey.currentState;
//   if (formState != null) {
//     formState.validate();
//   }
// }

// class _PasswordResetHandlerState extends State<PasswordResetHandler> {
//   // ... (resto de tu código)

//   final _emailError = ValueNotifier<String?>(null);

//   // ...

//   Widget _buildEmailField() {
//     return TextFormField(
//       controller: emailController,
//       decoration: InputDecoration(
//         labelText: 'Correo Electrónico',
//         prefixIcon: Icon(Icons.email),
//         errorText: _emailError.value, // Mostrar el mensaje de error
//       ),
//       validator: (value) {
//         // Validador que verifica si el campo de correo contiene texto válido.
//         if (value == null || value.isEmpty) {
//           _emailError.value = 'Por favor ingrese su correo electrónico';
//         } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
//           _emailError.value = 'Por favor ingrese un correo electrónico válido';
//         } else {
//           _emailError.value = null; // Limpiar el mensaje de error si es válido
//         }
//         return null; // Retornamos null para que el formulario no se marque como inválido
//       },
//       onChanged: (value) {
//         // Validar el campo en tiempo real
//         _formKey.currentState?.validate();
//       },
//     );
//   }
// }


// ---------------

// class _PasswordResetHandlerState extends State<PasswordResetHandler> {
//   final _formKey = GlobalKey<FormState>(); // Llave global para manejar el estado del formulario
//   final _emailController = TextEditingController(); // Controlador para el campo de correo electrónico

//   bool _isVerificationCodeSent = false; // Indica si el código de verificación ha sido enviado

//   void _sendCode() {
//     // Valida el campo de correo electrónico llamando al método de validación del formulario
//     if (_formKey.currentState?.validate() ?? false) {
//       setState(() {
//         _isVerificationCodeSent = true; // Actualiza el estado para indicar que el código ha sido enviado
//       });
//       // Aquí envías el correo de verificación
//     }
//   }

//   // Método de validación del campo de correo electrónico
//   String? _validateEmail(String? email) {
//     if (email == null || email.isEmpty) {
//       return 'Por favor ingrese su correo electrónico';
//     } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
//       return 'Por favor ingrese un correo electrónico válido';
//     }
//     return null; // Si la validación es exitosa, retorna null
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Restablecer Contraseña')), // Título de la aplicación
//       body: Padding(
//         padding: const EdgeInsets.all(16.0), // Padding alrededor del cuerpo del formulario
//         child: PasswordResetForm(
//           formKey: _formKey, // Pasa la llave del formulario
//           emailController: _emailController, // Pasa el controlador del campo de correo electrónico
//           isVerificationCodeSent: _isVerificationCodeSent, // Pasa el estado del código de verificación
//           onSendCode: _sendCode, // Pasa el callback para enviar el código de verificación
//           onValidateEmail: _validateEmail, // Pasa el método de validación del campo de correo electrónico
//         ),
//       ),
//     );
//   }
// }
