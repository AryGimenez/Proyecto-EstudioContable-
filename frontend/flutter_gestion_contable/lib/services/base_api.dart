// frontend/flutter_gestion_contable/lib/services/base_api.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

/// [BaseApi] es una clase abstracta que actúa como la "Columna Vertebral"
/// de la infraestructura de red de la aplicación.
///
/// Su propósito es centralizar la lógica de bajo nivel para las peticiones HTTP,
/// permitiendo que los módulos específicos (Clientes, Auth, etc.) se enfoquen
/// únicamente en la lógica de negocio.
///
/// Implementa el patrón **Template Method**, donde define la estructura
/// de las peticiones (headers, tokens, manejo de errores) pero delega la
/// definición de la URL base a sus subclases.
///
/// Características principales:
/// * **Gestión de Sesión:** Maneja la persistencia y recuperación del Token.
/// * **Estandarización:** Unifica el formato de las cabeceras (JSON, Auth).
/// * **Robustez:** Proporciona un manejador de respuestas común para capturar
///   errores del servidor (404, 500, etc.) de forma genérica.
abstract class BaseApi {
  // Obligamos a que quien herede esta clase defina la URL base
  String get baseUrl;

  /// Variable para almacenar el token de autenticación en memoria,
  /// este es usado para validarme con el backend en cada petición.
  @protected
  String? token;

  /// Persiste el token de autenticación tanto en el almacenamiento local
  /// del dispositivo como en la instancia actual en memoria.
  ///
  /// Utiliza [SharedPreferences] para que el token sobreviva a los reinicios
  /// de la aplicación (Persistencia). Además, actualiza la propiedad [token]
  /// de la clase para que las peticiones HTTP inmediatas ya dispongan
  /// de la credencial actualizada (Estado en memoria).
  ///
  /// [token]: El JWT o string de acceso proporcionado por el backend.
  Future<void> saveToken(String pToken) async {
    final prefs = await SharedPreferences.getInstance();
    // Guardar en el almacenamiento físico (disco)
    await prefs.setString('access_token', pToken);
    token = pToken;
  }

  /// Recupera el token de acceso desde el almacenamiento persistente del dispositivo.
  ///
  /// Utiliza [SharedPreferences] para leer el valor asociado a la clave 'access_token'.
  /// Este método es fundamental durante el inicio de la aplicación para restaurar
  /// la sesión del usuario sin obligarlo a loguearse nuevamente.
  ///
  /// Devuelve un [String] con el token si existe, o [null] si el usuario no ha
  /// iniciado sesión o el token ha sido eliminado.
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  // --- CABECERAS (HEADERS) ---

  /// Genera las cabeceras (headers) estandarizadas para las peticiones HTTP.
  ///
  /// Este método asegura que todas las peticiones utilicen el formato JSON por defecto.
  /// Si [useToken] es verdadero, intenta adjuntar el token de autenticación
  /// bajo el esquema 'Bearer'.
  ///
  /// Lógica de recuperación:
  /// 1. Si la variable [token] en memoria es nula, intenta recuperarla del almacenamiento local.
  /// 2. Si se encuentra un token, se añade al header 'Authorization'.
  /// 3. Si no se encuentra y la petición requiere autenticación, emite una advertencia en consola.
  ///
  /// [useToken]: Define si la petición debe incluir credenciales de seguridad.
  /// Retorna un [Map] con las cabeceras listas para ser usadas por el cliente HTTP.
  Future<Map<String, String>> _getHeaders({bool useToken = true}) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (useToken) {
      // Si el token no está en memoria, intentamos traerlo de SharedPreferences
      token ??= await getToken();
      // Si tenemos un token, lo añadimos al header
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      } else {
        debugPrint(
            'BaseApi Warning: Se intentó una petición con token pero no se encontró ninguno.');
      }
    }
    return headers;
  }

  /// Prepara la infraestructura necesaria para una petición HTTP.
  ///
  /// Este método realiza dos tareas críticas:
  /// 1. Construye la [Uri] oficial combinando la base con el endpoint.
  /// 2. Genera el mapa de cabeceras (headers) gestionando el token de seguridad.
  ///
  /// Centralizar esto evita la repetición de lógica y comentarios en los métodos
  /// GET, POST, PUT y DELETE.
  Future<_RequestConfig> _prepareRequest(String endpoint,
      {bool useToken = true}) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final headers = await _getHeaders(useToken: useToken);

    return _RequestConfig(url, headers);
  }

  /// Realiza una petición de lectura (GET) al servidor de forma asíncrona.
  ///
  /// Este método actúa como un envoltorio (wrapper) de alto nivel sobre el cliente HTTP.
  /// Se encarga de la resolución de la URL, la inyección automática de credenciales
  /// y la gestión centralizada de excepciones de red.
  ///
  /// Parámetros:
  /// * [endpoint]: Segmento final de la URL que identifica el recurso (ej. 'clientes').
  /// * [useToken]: Determina si se debe adjuntar el encabezado de autorización.
  ///   Por defecto es `true`.
  ///
  /// Flujo de ejecución:
  /// 1. Construye la URI completa concatenando [baseUrl] y [endpoint].
  /// 2. Solicita las cabeceras necesarias (incluyendo el JWT si corresponde).
  /// 3. Ejecuta la llamada asíncrona y espera la respuesta del servidor.
  /// 4. Procesa el resultado mediante [_handleResponse] para validar códigos de estado.
  ///
  /// Lanza una [Exception] si el servidor es inalcanzable o hay errores de resolución DNS.
  Future<dynamic> get(String endpoint, {bool useToken = true}) async {
    final config = await _prepareRequest(endpoint, useToken: useToken);
    try {
      final response = await http.get(config.url, headers: config.headers);
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Fallo en GET $endpoint: $e');
    }
  }

  /// Realiza una petición de escritura (POST) para enviar datos al servidor.
  ///
  /// Este método se utiliza para crear nuevos recursos. A diferencia de [get],
  /// este incluye un "cuerpo" (body) en la petición que contiene la información
  /// que el servidor debe procesar.
  ///
  /// Parámetros:
  /// * [endpoint]: La ruta destino (ej. 'clientes/guardar').
  /// * [data]: Un mapa de Dart con la información (ej. {'nombre': 'Juan'}).
  ///   Este mapa se convierte automáticamente a formato JSON.
  /// * [useToken]: Indica si se requiere enviar credenciales de seguridad.
  ///
  /// Flujo de ejecución:
  /// 1. Llama a [_prepareRequest] para obtener la URL y los Headers unificados.
  /// 2. Transforma el mapa [data] en una cadena de texto JSON mediante [json.encode].
  /// 3. Envía la petición y espera la respuesta del servidor.
  /// 4. Valida el resultado (ej. 201 Created) a través de [_handleResponse].
  Future<dynamic> post(String endpoint, Map<String, dynamic> data,
      {bool useToken = true}) async {
    final config = await _prepareRequest(endpoint, useToken: useToken);
    try {
      final response = await http.post(
        config.url,
        headers: config.headers,
        body: json.encode(data),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Fallo en POST $endpoint: $e');
    }
  }

  /// Realiza una petición de actualización (PUT) al servidor.
  ///
  /// Se utiliza para modificar un recurso existente de forma integral.
  /// Al igual que el [post], este método envía un cuerpo (body) en formato JSON
  /// con la información actualizada.
  ///
  /// Parámetros:
  /// * [endpoint]: La ruta del recurso a modificar (ej. 'clientes/1').
  /// * [data]: El mapa con los nuevos datos del recurso.
  /// * [useToken]: Define si se requiere el encabezado de autorización.
  ///
  /// Flujo de ejecución:
  /// 1. Prepara la URL y Headers mediante [_prepareRequest].
  /// 2. Serializa el mapa [data] a una cadena JSON.
  /// 3. Ejecuta la llamada HTTP PUT.
  /// 4. Procesa la respuesta del servidor mediante [_handleResponse].
  Future<dynamic> put(String endpoint, Map<String, dynamic> data,
      {bool useToken = true}) async {
    final config = await _prepareRequest(endpoint, useToken: useToken);
    try {
      final response = await http.put(
        config.url,
        headers: config.headers,
        body: json.encode(data),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Fallo en PUT $endpoint: $e');
    }
  }

  /// Realiza una petición de eliminación (DELETE) al servidor.
  ///
  /// Se utiliza para remover de forma permanente un recurso específico.
  /// Al igual que el [get], generalmente no requiere un cuerpo (body) ya que
  /// el recurso se identifica directamente a través de la URL.
  ///
  /// Parámetros:
  /// * [endpoint]: La ruta del recurso a eliminar (ej. 'clientes/1').
  /// * [useToken]: Define si se requiere el encabezado de autorización.
  ///
  /// Flujo de ejecución:
  /// 1. Prepara la URL y Headers mediante [_prepareRequest].
  /// 2. Ejecuta la llamada HTTP DELETE hacia el servidor.
  /// 3. Procesa el resultado mediante [_handleResponse].
  ///
  /// Lanza una [Exception] si hay problemas de red o si el servidor
  /// rechaza la petición por falta de permisos.
  Future<dynamic> delete(String endpoint, {bool useToken = true}) async {
    final config = await _prepareRequest(endpoint, useToken: useToken);
    try {
      final response = await http.delete(config.url, headers: config.headers);
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Fallo en DELETE $endpoint: $e');
    }
  }

  /// Procesa la respuesta del servidor y la transforma en datos utilizables.
  ///
  /// Este método centraliza la lógica de validación de códigos de estado HTTP.
  /// Se encarga de:
  /// 1. Verificar si la petición fue exitosa (rango 200-299).
  /// 2. Decodificar el cuerpo de la respuesta de JSON a un objeto Dart.
  /// 3. Gestionar respuestas vacías o sin formato JSON.
  /// 4. Extraer mensajes de error específicos enviados por el backend (Python).
  ///
  /// [response]: El objeto completo recibido del cliente HTTP.
  ///
  /// Retorna un [dynamic] que puede ser un [Map], [List] o un mensaje de éxito.
  /// Lanza una [Exception] con detalles del error si la respuesta no es exitosa.
  dynamic _handleResponse(http.Response response) {
    // Imprime en consola para facilitar el rastreo (debug) durante el desarrollo
    debugPrint(
        'BaseApi Response: [${response.statusCode}] ${response.request?.url}');

    // Rango 200: Éxito (OK, Created, Accepted, No Content)
    if (response.statusCode >= 200 && response.statusCode < 300) {
      // Si hay contenido y el servidor confirma que es JSON, lo decodificamos
      if (response.body.trim().isNotEmpty && // determina que el contenido no está vacío
          response.headers['content-type']?.contains('application/json') == true) { // verifica que el content-type sea JSON
        return json.decode(response.body);
      }
      return {
        'message': 'Operación exitosa',
        'statusCode': response.statusCode
      };
    } else { // Manejo de errores servidor
      String errorMessage =
          'Error ${response.statusCode}: ${response.reasonPhrase}';
      if (response.body.trim().isNotEmpty) { // Si el cuerpo no está vacío, intentamos extraer un mensaje más específico
        try {
          final errorBody = json.decode(response.body); // Decodifica el cuerpo JSON
          // Intenta obtener un mensaje específico del backend
          // Siempre y cuando el valor no sea nulo o vacío 
          errorMessage =
              '${errorBody['message'] ?? ''} ${errorBody['detail'] ?? ''}'.trim() ?? errorMessage;
        } catch (_) {}
      }
      throw Exception(errorMessage);
    }
  }
}

/// Clase auxiliar para encapsular la configuración de una petición HTTP.
class _RequestConfig {
  /// Convierte la cadena de texto de la URL en un objeto Uri estructurado.
  /// Esto permite que la librería HTTP maneje correctamente los puertos,
  /// caracteres especiales y la jerarquía de rutas del servidor.
  final Uri url;

  /// Mapa de cabeceras (headers) que serán enviadas junto con la petición HTTP.
  final Map<String, String>? headers;

  _RequestConfig(this.url, this.headers);
}
