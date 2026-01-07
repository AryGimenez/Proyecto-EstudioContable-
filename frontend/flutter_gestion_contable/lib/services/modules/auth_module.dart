// frontend/flutter_gestion_contable/lib/services/modules/auth_module.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../base_api.dart'; // Crearemos este para compartir el baseUrl y token


/// Módulo encargado de la autenticación y seguridad.
/// 
/// Gestiona el ciclo de vida de la sesión, incluyendo el inicio de sesión
/// y la recuperación de credenciales. Al extender de [BaseApi], utiliza
/// su infraestructura para realizar las peticiones al backend.
mixin AuthModule on BaseApi {

  /// Inicia sesión en el sistema y almacena el token de acceso.
  /// 
  /// [username] y [password]: Credenciales del usuario.
  /// 
  /// Este método es especial porque maneja su propia lógica de respuesta:
  /// 1. Envía las credenciales al endpoint de autenticación.
  /// 2. Si el éxito es 200, extrae el 'access_token' y lo guarda localmente
  ///    usando el método [saveToken].
  /// 3. Retorna un mapa con el estado de la operación para que la UI 
  ///    sepa si debe navegar al Home o mostrar un error.
  Future<Map<String, dynamic>> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/auth/token');
    try {
      final response = await http.post(
        url,
        body: {'username': username, 'password': password},
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
      return {'success': false, 'message': 'Error de conexión con el servidor.'};
    }
  }

  Future<Map<String, dynamic>> requestPasswordReset(String email) async {
    try {
      await post('auth/password-reset/request', {'email': email}, useToken: false);
      return {'success': true, 'message': 'Código enviado.'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}