// lib/services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // La URL base para el backend. Se usa 'localhost' para el desarrollo en PC.
  static const String _baseUrl = 'http://localhost:8000';

  // Guarda el token de autenticación en el almacenamiento local del dispositivo.
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
  }

  // Obtiene el token de autenticación del almacenamiento local.
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  // Nuevo método para cerrar sesión.
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
  }

// Método para iniciar sesión, enviando el nombre de usuario y la contraseña.
Future<Map<String, dynamic>> login(String username, String password) async {
  final url = Uri.parse('$_baseUrl/auth/token');
  
  try {
    // Usa http.post directamente y envíale un Map para el cuerpo.
    final response = await http.post(
      url,
      body: {
        'username': username,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      await saveToken(data['access_token']);
      return {'success': true, 'token': data['access_token']};
    } else {
      final error = json.decode(response.body);
      return {'success': false, 'message': error['detail']};
    }
  } catch (e) {
    return {'success': false, 'message': 'No se pudo conectar al servidor. Revisa que el backend esté corriendo.'};
  }
}

  // Solicita al backend que envíe un código de reseteo de contraseña.
  Future<Map<String, dynamic>> requestPasswordReset(String email) async {
    final url = Uri.parse('$_baseUrl/auth/password-reset/request');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email}),
      );

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Código de verificación enviado.'};
      } else {
        final error = json.decode(response.body);
        return {'success': false, 'message': error['detail']};
      }
    } catch (e) {
      return {'success': false, 'message': 'No se pudo conectar al servidor. Revisa que el backend esté corriendo.'};
    }
  }

  // Confirma el reseteo de contraseña enviando el email, código y nueva contraseña.
  Future<Map<String, dynamic>> confirmPasswordReset(String email, String code, String newPassword) async {
    final url = Uri.parse('$_baseUrl/auth/password-reset/confirm');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'verification_code': code,
          'new_password': newPassword,
          'confirm_new_password': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Contraseña actualizada.'};
      } else {
        final error = json.decode(response.body);
        return {'success': false, 'message': error['detail']};
      }
    } catch (e) {
      return {'success': false, 'message': 'No se pudo conectar al servidor. Revisa que el backend esté corriendo.'};
    }
  }
}