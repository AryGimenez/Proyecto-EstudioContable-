// Codigo generado IA para la comunicacion con el server luego trabajo con eso

import 'package:http/http.dart'
    as http; // Importa la biblioteca HTTP para realizar solicitudes.
import 'dart:convert'; // Importa la biblioteca para trabajar con JSON.

class ApiService {
  final String baseUrl; // La URL base de la API.

  ApiService(
      {required this.baseUrl}); // Constructor que inicializa la URL base.

  // Método para enviar el código de verificación.
  Future<void> sendVerificationCode(String email) async {
    final response = await http.post(
      // Realiza una solicitud POST.
      Uri.parse(
          '$baseUrl/send-code'), // Construye la URL completa para la solicitud.
      body: json.encode(
          {'email': email}), // Codifica el cuerpo de la solicitud como JSON.
      headers: {
        'Content-Type': 'application/json'
      }, // Establece el encabezado de contenido como JSON.
    );

    if (response.statusCode != 200) {
      // Verifica si la solicitud fue exitosa.
      throw Exception(
          'Failed to send verification code'); // Lanza una excepción si la solicitud falla.
    }
  }

  // Método para verificar el código de verificación.
  Future<void> verifyCode(String code) async {
    final response = await http.post(
      // Realiza una solicitud POST.
      Uri.parse(
          '$baseUrl/verify-code'), // Construye la URL completa para la solicitud.
      body: json.encode(
          {'code': code}), // Codifica el cuerpo de la solicitud como JSON.
      headers: {
        'Content-Type': 'application/json'
      }, // Establece el encabezado de contenido como JSON.
    );

    if (response.statusCode != 200) {
      // Verifica si la solicitud fue exitosa.
      throw Exception(
          'Failed to verify code'); // Lanza una excepción si la solicitud falla.
    }
  }

  // Método para restablecer la contraseña.
  Future<void> resetPassword(String password) async {
    final response = await http.post(
      // Realiza una solicitud POST.
      Uri.parse(
          '$baseUrl/reset-password'), // Construye la URL completa para la solicitud.
      body: json.encode({
        'password': password
      }), // Codifica el cuerpo de la solicitud como JSON.
      headers: {
        'Content-Type': 'application/json'
      }, // Establece el encabezado de contenido como JSON.
    );

    if (response.statusCode != 200) {
      // Verifica si la solicitud fue exitosa.
      throw Exception(
          'Failed to reset password'); // Lanza una excepción si la solicitud falla.
    }
  }
}
