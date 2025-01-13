import 'package:flutter/material.dart'; // Importa el paquete de Flutter para utilizar widgets.
import 'package:flutter_gestion_contable/core/theme/app_text_styles.dart'; // Importa estilos de texto personalizados.
import 'package:flutter_gestion_contable/core/theme/app_colors.dart'; // Importa colores personalizados.
import 'login_styles.dart'; // Importa estilos específicos para el login.

class PasswordResetForm extends StatelessWidget {
  // Define el widget PasswordResetForm como un StatelessWidget.
  final GlobalKey<FormState>
      formKey; // Llave global para identificar el formulario y su estado.
  final TextEditingController
      emailController; // Controlador para el campo de correo electrónico.
  final TextEditingController
      verificationCodeController; // Controlador para el campo del código de verificación.
  final TextEditingController
      passwordController; // Controlador para el campo de la nueva contraseña.
  final TextEditingController
      confirmPasswordController; // Controlador para el campo de confirmación de la nueva contraseña.
  final bool
      isVerificationCodeSent; // Variable que indica si el código de verificación ha sido enviado.
  final bool
      isCodeVerified; // Variable que indica si el código ha sido verificado.
  final VoidCallback
      onSendCode; // Callback para enviar el código de verificación.
  final VoidCallback
      onVerifyCode; // Callback para verificar el código de verificación.
  final VoidCallback onSubmit; // Callback para restablecer la contraseña.

  PasswordResetForm({
    // Constructor sin `const` porque las variables no pueden ser finales.
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
    // Construye la interfaz de usuario del formulario.
    return Center(
      // Centra el contenido en la pantalla.
      child: SingleChildScrollView(
        // Permite el desplazamiento cuando el contenido es grande.
        child: ConstrainedBox(
          // Constriñe el tamaño del contenido.
          constraints: BoxConstraints(
            maxWidth: 400, // Define el ancho máximo del formulario.
          ),
          child: Padding(
            padding: formPadding, // Define el padding del formulario.
            child: Column(
              mainAxisAlignment: MainAxisAlignment
                  .center, // Alinea el contenido en el centro verticalmente.
              children: [
                Text(
                  'Reseteador de Contraseña',
                  style: AppTextStyles
                      .headline4, // Estilo de texto del encabezado.
                ),
                verticalSpaceMedium, // Espaciado vertical.
                Form(
                  key:
                      formKey, // Llave para identificar el estado del formulario.
                  child: Column(
                    children: [
                      _buildEmailField(), // Campo de correo electrónico.
                      verticalSpaceSmall, // Espaciado vertical pequeño.
                      _buildSendCodeButton(), // Botón para enviar el código de verificación.
                      verticalSpaceMedium, // Espaciado vertical mediano.
                      _buildVerificationCodeField(), // Campo para el código de verificación.
                      verticalSpaceSmall, // Espaciado vertical pequeño.
                      _buildVerifyCodeButton(), // Botón para verificar el código.
                      verticalSpaceMedium, // Espaciado vertical mediano.
                      _buildPasswordField(), // Campo para la nueva contraseña.
                      verticalSpaceSmall, // Espaciado vertical pequeño.
                      _buildConfirmPasswordField(), // Campo para confirmar la nueva contraseña.
                      verticalSpaceMedium, // Espaciado vertical mediano.
                      _buildResetPasswordButton(), // Botón para restablecer la contraseña.
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
    // Construye el campo de correo electrónico.
    return TextFormField(
      controller:
          emailController, // Controlador del campo de correo electrónico.
      decoration: InputDecoration(
        labelText: 'Correo Electrónico', // Etiqueta del campo.
        prefixIcon: Icon(Icons.email), // Icono de prefijo.
      ),
      validator: (value) {
        // Valida el campo de correo electrónico.
        if (value == null || value.isEmpty) {
          return 'Por favor ingrese su correo electrónico'; // Mensaje de error si el campo está vacío.
        } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return 'Por favor ingrese un correo electrónico válido'; // Mensaje de error si el formato del correo es incorrecto.
        }
        return null; // Validación exitosa.
      },
    );
  }

  Widget _buildSendCodeButton() {
    // Construye el botón para enviar el código de verificación.
    return ElevatedButton(
      onPressed: onSendCode, // Llama al callback para enviar el código.
      child: Text(
        isVerificationCodeSent
            ? 'Reenviar Código de Verificación'
            : 'Enviar Código de Verificación', // Cambia el texto según el estado.
      ),
    );
  }

  Widget _buildVerificationCodeField() {
    // Construye el campo para el código de verificación.
    return TextFormField(
      controller:
          verificationCodeController, // Controlador del campo del código de verificación.
      decoration: InputDecoration(
        labelText: 'Código de Verificación', // Etiqueta del campo.
        prefixIcon: Icon(Icons.lock), // Icono de prefijo.
      ),
      validator: (value) {
        // Valida el campo del código de verificación.
        if (value == null || value.isEmpty) {
          return 'Por favor ingrese el código de verificación'; // Mensaje de error si el campo está vacío.
        }
        return null; // Validación exitosa.
      },
      enabled:
          isVerificationCodeSent, // Habilita el campo solo si el código ha sido enviado.
    );
  }

  Widget _buildVerifyCodeButton() {
    // Construye el botón para verificar el código.
    return ElevatedButton(
      onPressed: isVerificationCodeSent
          ? onVerifyCode
          : null, // Llama al callback para verificar el código si el código ha sido enviado.
      child: Text('Verificar Código'),
    );
  }

  Widget _buildPasswordField() {
    // Construye el campo para la nueva contraseña.
    return TextFormField(
      controller:
          passwordController, // Controlador del campo de la nueva contraseña.
      decoration: InputDecoration(
        labelText: 'Nueva Contraseña', // Etiqueta del campo.
        prefixIcon: Icon(Icons.lock), // Icono de prefijo.
      ),
      obscureText: true, // Oculta el texto para que no se vea la contraseña.
      validator: (value) {
        // Valida el campo de la nueva contraseña.
        if (value == null || value.isEmpty) {
          return 'Por favor ingrese su nueva contraseña'; // Mensaje de error si el campo está vacío.
        }
        return null; // Validación exitosa.
      },
      enabled:
          isCodeVerified, // Habilita el campo solo si el código ha sido verificado.
    );
  }

  Widget _buildConfirmPasswordField() {
    // Construye el campo para confirmar la nueva contraseña.
    return TextFormField(
      controller:
          confirmPasswordController, // Controlador del campo de confirmación de la nueva contraseña.
      decoration: InputDecoration(
        labelText: 'Confirmar Nueva Contraseña', // Etiqueta del campo.
        prefixIcon: Icon(Icons.lock), // Icono de prefijo.
      ),
      obscureText: true, // Oculta el texto para que no se vea la contraseña.
      validator: (value) {
        // Valida el campo de confirmación de la nueva contraseña.
        if (value == null || value.isEmpty) {
          return 'Por favor confirme su nueva contraseña'; // Mensaje de error si el campo está vacío.
        } else if (value != passwordController.text) {
          return 'Las contraseñas no coinciden'; // Mensaje de error si las contraseñas no coinciden.
        }
        return null; // Validación exitosa.
      },
      enabled:
          isCodeVerified, // Habilita el campo solo si el código ha sido verificado.
    );
  }

  Widget _buildResetPasswordButton() {
    // Construye el botón para restablecer la contraseña.
    return ElevatedButton(
      onPressed: isCodeVerified
          ? onSubmit
          : null, // Llama al callback para restablecer la contraseña si el código ha sido verificado.
      child: Text('Cambiar Contraseña'),
    );
  }
}





-----------------




class PasswordResetForm extends StatelessWidget {
  // Campos y constructor...

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: formPadding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Reseteador de Contraseña', style: AppTextStyles.headline4),
                verticalSpaceMedium,
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      _buildEmailField(),
                      verticalSpaceSmall,
                      _buildSendCodeButton(),
                      // Otros campos y botones...
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

  Widget _buildSendCodeButton() {
    return ElevatedButton(
      onPressed: onSendCode, // Llama al método de PasswordResetHandler.
      child: Text(
        isVerificationCodeSent ? 'Reenviar Código de Verificación' : 'Enviar Código de Verificación',
      ),
    );
  }

  // Otros métodos de construcción de widgets...
}
