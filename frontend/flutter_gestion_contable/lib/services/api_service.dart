// lib/services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart'; // Para debugPrint
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String _baseUrl; // Variable privada y final

  String? _token;

  // Constructor corregido
  ApiService({String baseUrl = 'http://127.0.0.1:8000'}) : _baseUrl = baseUrl {
    _initToken();
  }

  Future<void> _initToken() async {
    _token = await getToken();
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
    _token = token;
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }


  // Metodo para cerrar sesion con el boton salir
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    _token = null;
  }

  // Manejador de headers para no duplicar código, ahora siempre espera ser Future
  Future<Map<String, String>> _getHeaders({bool useToken = true}) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (useToken) {
      if (_token == null) {
        await _initToken(); // Asegurarse de que el token esté cargado si es null
       debugPrint('ApiService: Token recargado: $_token'); // Depuración
      }
      if (_token != null) {
        headers['Authorization'] = 'Bearer $_token';
       debugPrint('ApiService: Authorization Header añadido: Bearer $_token'); // Depuración
      } else {
        debugPrint('ApiService: ERROR: Token es nulo, no se pudo añadir Authorization Header.'); // Depuración
      }
    }
    return headers;
  }

  Future<Map<String, dynamic>> login(String username, String password) async {
    final url = Uri.parse('$_baseUrl/auth/token');
    try {
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

  // **MÉTODOS GENÉRICOS (GET, POST, PUT, DELETE)**
  // Todos ahora usan _getHeaders para la autenticación y _handleResponse.

  Future<dynamic> post(String endpoint, Map<String, dynamic> data, {bool useToken = true}) async {
    final url = Uri.parse('$_baseUrl/$endpoint');
    final headers = await _getHeaders(useToken: useToken);
    debugPrint('ApiService POST: URL=$url, Headers=$headers, Body=${json.encode(data)}');
    try {
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(data),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Fallo en la conexión al servidor para POST $endpoint: $e');
    }
  }

  Future<dynamic> get(String endpoint, {bool useToken = true}) async {
    final url = Uri.parse('$_baseUrl/$endpoint');
    final headers = await _getHeaders(useToken: useToken);
    debugPrint('ApiService GET: URL=$url, Headers=$headers');
    try {
      final response = await http.get(
        url,
        headers: headers,
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Fallo en la conexión al servidor para GET $endpoint: $e');
    }
  }

  Future<dynamic> put(String endpoint, Map<String, dynamic> data, {bool useToken = true}) async {
    final url = Uri.parse('$_baseUrl/$endpoint');
    final headers = await _getHeaders(useToken: useToken);
    debugPrint('ApiService PUT: URL=$url, Headers=$headers, Body=${json.encode(data)}');
    try {
      final response = await http.put(
        url,
        headers: headers,
        body: jsonEncode(data),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Fallo en la conexión al servidor para PUT $endpoint: $e');
    }
  }

  // MÉTODO DELETE FINAL Y CORREGIDO
   Future<dynamic> delete(String endpoint, {bool useToken = true}) async {
    final fullUrl = '$_baseUrl/$endpoint';
    final headers = await _getHeaders(useToken: useToken); // ¡Aquí se obtienen los headers con el token!
    debugPrint('ApiService DELETE: URL=$fullUrl, Headers=$headers'); 
    try {
      final response = await http.delete(
        Uri.parse(fullUrl),
        headers: headers, // ¡Aquí se pasan los headers obtenidos!
      );
      // ESTA LÍNEA ES CLAVE, DEBERÍA IMPRIMIRSE
      debugPrint('ApiService DELETE: Respuesta para $fullUrl - Status: ${response.statusCode}, Body: ${response.body}'); 
      return _handleResponse(response);
    } catch (e) {
      debugPrint('ApiService DELETE: ¡Excepción capturada ANTES de imprimir la respuesta del servidor!: $e'); // Nuevo debugPrint
      throw Exception('Fallo en la conexión al servidor para DELETE $endpoint: $e');
    }
  }

  // Manejador de respuestas
  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isNotEmpty && response.headers['content-type']?.contains('application/json') == true) {
        return json.decode(response.body);
      }
      return {'message': 'Operación exitosa', 'statusCode': response.statusCode};
    } else {
      String errorMessage = 'Error ${response.statusCode}: ${response.reasonPhrase}';
      if (response.body.isNotEmpty) {
        try {
          final errorBody = json.decode(response.body);
          errorMessage = errorBody['message'] ?? errorBody['detail'] ?? errorMessage;
        } catch (e) {
          // Si el cuerpo no es JSON, usa el mensaje HTTP
        }
      }
      throw Exception(errorMessage);
    }
  }

  // **MÉTODOS ESPECÍFICOS PARA CLIENTES**
  // Ahora usan los métodos genéricos (get, post, put, delete)

  Future<List<dynamic>> getClientes() async {
    // Aquí el endpoint es solo 'clientes' porque el método get ya agrega _baseUrl
    return await get('clientes'); 
  }

  // Si necesitas un método para crear un cliente específico
  Future<Map<String, dynamic>> createClient(Map<String, dynamic> clientData) async {
    return await post('clientes', clientData);
  }

  // Método de actualización de cliente, usado en ClientsHandler
  // Este ya lo tienes implementado en ClientsHandler y llama al put genérico.
  // No necesitas redefinirlo aquí a menos que quieras una capa específica.

  // Métodos de reseteo de contraseña
  Future<Map<String, dynamic>> requestPasswordReset(String email) async {
    try {
      await post('auth/password-reset/request', {'email': email}, useToken: false); // No requiere token
      return {'success': true, 'message': 'Código de verificación enviado.'};
    } catch (e) {
      return {'success': false, 'message': e.toString().replaceFirst('Exception: ', '')};
    }
  }

  Future<Map<String, dynamic>> confirmPasswordReset(String email, String code, String newPassword) async {
    try {
      await post(
        'auth/password-reset/confirm',
        {
          'email': email,
          'verification_code': code,
          'new_password': newPassword,
          'confirm_new_password': newPassword,
        },
        useToken: false // No requiere token
      );
      return {'success': true, 'message': 'Contraseña actualizada.'};
    } catch (e) {
      return {'success': false, 'message': e.toString().replaceFirst('Exception: ', '')};
    }
  }
}