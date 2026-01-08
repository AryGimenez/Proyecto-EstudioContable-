// lib/services/modules/clients_module.dart
import 'package:flutter_gestion_contable/models/cliente_modle.dart';

import '../base_api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// Módulo especializado en la gestión de clientes.
/// 
/// Al usar [mixin] sobre [BaseApi], este módulo gana superpoderes:
/// puede usar los métodos [get], [post], [put] y [delete] de forma directa.
/// 
/// Este patrón permite separar las funcionalidades por lógica de negocio
/// (clientes, facturas, productos) en archivos distintos sin perder la 
/// conexión con la base de red.
mixin ClientsModule on BaseApi {



  /// Obtiene la lista de clientes desde el servidor.
  /// 
  /// Retorna una lista de [ClienteModel] con la información de todos los clientes.
  Future<List<ClienteModel>> getClients() async {
  try {
    final response = await http.get(Uri.parse('$baseUrl/clientes'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      
      // La construcción la hacemos AQUÍ
      return data.map((json) => ClienteModel.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar clientes');
    }
  } catch (e) {
    print('Error en ApiService: $e');
    return []; // Devolvemos lista vacía en caso de error
  }
}
}