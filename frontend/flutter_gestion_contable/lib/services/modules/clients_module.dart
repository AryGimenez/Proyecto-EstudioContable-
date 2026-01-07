// lib/services/modules/clients_module.dart
import '../base_api.dart';

/// Módulo especializado en la gestión de clientes.
/// 
/// Al usar [mixin] sobre [BaseApi], este módulo gana superpoderes:
/// puede usar los métodos [get], [post], [put] y [delete] de forma directa.
/// 
/// Este patrón permite separar las funcionalidades por lógica de negocio
/// (clientes, facturas, productos) en archivos distintos sin perder la 
/// conexión con la base de red.
mixin ClientsModule on BaseApi {
  Future<List<dynamic>> getClientes() async {
    return await get('clientes');
  }

  /// Registra un nuevo cliente en el sistema.
  /// 
  /// [clientData]: Un mapa con la información (ej: {'nombre': 'Ana', 'RUT': '1234'}).
  /// 
  /// Envía los datos mediante una petición POST. 
  /// Retorna un [Map] con el cliente creado (incluyendo el ID generado por el servidor).
  Future<Map<String, dynamic>> createClient(Map<String, dynamic> clientData) async {
    return await post('clientes', clientData); // Aquí 'post' toma el mapa, lo hace JSON y lo envía al backend.
  }
}