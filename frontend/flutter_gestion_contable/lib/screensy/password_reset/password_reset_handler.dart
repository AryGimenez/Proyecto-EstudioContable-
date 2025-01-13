// lib/screens/password_reset/password_reset_handler.dart

import 'package:flutter/material.dart';
import 'password_reset_form.dart';

class PasswordResetHandler extends StatefulWidget {
  const PasswordResetHandler({super.key});

  @override
  _PasswordResetHandlerState createState() => _PasswordResetHandlerState();
}

class _PasswordResetHandlerState extends State<PasswordResetHandler> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _verificationCodeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isVerificationCodeSent = false;
  bool _isCodeVerified = false;

  @override
  void dispose() {
    _emailController.dispose();
    _verificationCodeController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _sendCode() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isVerificationCodeSent = true;
      });
      // Aquí envías el correo de verificación.
    }
  }

  void _verifyCode() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isCodeVerified = true;
      });
      // Aquí manejas la lógica de verificación del código.
    }
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      // Aquí manejas el restablecimiento de la contraseña.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Restablecer Contraseña')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
        ),
      ),
    );
  }
}
