// frontend/flutter_gestion_contable/lib/screens/clients/clients_handler.dart

import 'package:flutter/foundation.dart'; // Para debugPrint
import 'package:flutter/material.dart'; // Para ChangeNotifier
import 'package:flutter_gestion_contable/services/api_service.dart';
import 'package:flutter_gestion_contable/models/cliente_modle.dart'; // Importa el modelo

class ClientsHandler with ChangeNotifier {
  List<ClienteModel> _clients = []; // Lista original de objetos ClienteModel
  List<ClienteModel> _filteredClients =
      []; // Lista filtrada de objetos ClienteModel
  final Map<int, bool> _selectedClients = {}; // Mapa ID (int) -> bool
  bool _isAllSelected = false; // Estado para el checkbox "Seleccionar todos"

  ClientsHandler();

  // Getters para acceder al estado desde la UI
  List<ClienteModel> get clients => _clients;
  List<ClienteModel> get filteredClients => _filteredClients;
  bool get isAllSelected => _isAllSelected;
  int get selectedClientsCount =>
      _selectedClients.values.where((selected) => selected).length;

  // Devuelve el cliente seleccionado si solo hay uno
  ClienteModel? get selectedClient {
    if (selectedClientsCount != 1) {
      return null;
    }
    final selectedId =
        _selectedClients.keys.firstWhere((id) => _selectedClients[id]!);
    return _clients.firstWhere(
      (client) => client.id == selectedId,
      orElse: () => throw Exception(
          'Cliente seleccionado no encontrado en la lista original.'),
    );
  }

  // Fetch clients from server
  Future<void> fetchClients() async {
    try {
      debugPrint('ClientsHandler: Iniciando fetchClients...');
      // Usamos el método getClients que ya devuelve List<ClienteModel>
      final List<ClienteModel> data = await ApiService().getClients();
      _clients = data;
      _filteredClients = List.from(_clients); // Reinicia filteredClients
      _selectedClients.clear(); // Limpia selecciones anteriores
      _isAllSelected = false;

      // Inicializa el mapa de selección para todos los clientes cargados
      for (var client in _clients) {
        _selectedClients[client.id] = false;
      }
      debugPrint(
          'ClientsHandler: Clientes cargados y seleccionables inicializados. Total: ${_clients.length}');
      notifyListeners();
    } catch (e) {
      debugPrint('ClientsHandler: Error al obtener clientes: $e');
      rethrow; // Relanza la excepción para que la UI pueda manejarla
    }
  }

  // Actualiza un cliente existente
  Future<void> updateClient(
      String clientId, Map<String, dynamic> updatedData) async {
    try {
      debugPrint(
          'ClientsHandler: Intentando actualizar cliente ID: $clientId con datos: $updatedData');
      // Llama al método put genérico del ApiService
      await ApiService().put('clientes/$clientId', updatedData);

      // NOTA: Lo ideal sería que el PUT devolviera el cliente actualizado y lo parseáramos.
      // O volver a hacer fetchClients().
      // Por ahora, recargaremos todo para simplificar y asegurar consistencia con el modelo.
      await fetchClients();

      debugPrint(
          'ClientsHandler: Cliente ID $clientId actualizado y lista recargada.');
      notifyListeners();
    } catch (e) {
      debugPrint(
          'ClientsHandler: Error al actualizar cliente ID $clientId: $e');
      rethrow;
    }
  }

  // **MÉTODO DE ELIMINACIÓN DE CLIENTES SELECCIONADOS**
  Future<void> deleteSelectedClients() async {
    List<int> selectedIds = _selectedClients.entries
        .where((entry) => entry.value) // Filtra solo los IDs marcados como true
        .map((entry) => entry.key) // Obtiene solo los IDs
        .toList();
    // Si no hay IDs seleccionados, no hacemos nada
    if (selectedIds.isEmpty) {
      debugPrint(
          'ClientsHandler: No hay clientes seleccionados para eliminar.');
      return;
    }

    debugPrint(
        'ClientsHandler: Intentando eliminar clientes con IDs: $selectedIds');
    try {
      for (int id in selectedIds) {
        debugPrint(
            'ClientsHandler: Llamando a ApiService().delete para ID: $id');

        // <!> Esto tendria que cambiarlo para qeu funcione
        // tendria que agregar un elminar cliete en app_service
        await ApiService().delete('clientes/$id');
      }

      // <!> Esto tendria que cambiarlo para qeu funcione
      // Actualiza las listas locales eliminando los modelos
      _clients.removeWhere((client) => selectedIds.contains(client.id));
      _filteredClients.removeWhere((client) => selectedIds.contains(client.id));

      // Limpia la selección y restablece el estado de "seleccionar todos"
      _selectedClients.clear();
      _isAllSelected = false;
      debugPrint(
          'ClientsHandler: Clientes eliminados localmente y notificados. IDs: $selectedIds');
      notifyListeners(); // Notifica a los widgets que la lista ha cambiado
    } catch (e) {
      debugPrint('ClientsHandler: Error al eliminar clientes: $e');
      rethrow; // Relanza la excepción para que la UI pueda mostrar un SnackBar, etc.
    }
  }

  // Verifica si una fila está seleccionada
  bool isRowSelected(int clientId) {
    return _selectedClients[clientId] ?? false;
  }

  // Alterna el estado de selección de una fila
  void toggleRowSelection(int clientId, bool value) {
    _selectedClients[clientId] = value;
    // Actualiza _isAllSelected si todos los clientes filtrados están seleccionados
    _isAllSelected =
        _filteredClients.every((client) => _selectedClients[client.id] == true);
    notifyListeners();
  }

  // Selecciona o deselecciona todas las filas
  void selectAll(bool value) {
    _isAllSelected = value;
    _selectedClients.clear(); // Limpia el mapa para reconstruirlo
    if (value) {
      // Si se selecciona todo, marca todos los clientes filtrados
      for (var client in _filteredClients) {
        _selectedClients[client.id] = true;
      }
    }
    debugPrint(
        'ClientsHandler: SelectAll establecido a $value. Clientes seleccionados: $selectedClientsCount');
    notifyListeners();
  }

  Future<void> addClient(Map<String, dynamic> newClientData) async {
    // Si la pantalla de agregar clientes hace el POST directamente,
    // este método solo necesitaría recargar la lista.
    await fetchClients(); // Recarga la lista para que el nuevo cliente aparezca
  }

  // Filtra la lista de clientes
  // <!> Hay que cambiar esto para que no pida los nombres
  // de el blakend
  void filterClients(String query, String filterBy) {
    if (query.isEmpty) {
      _filteredClients = List.from(_clients);
    } else {
      _filteredClients = _clients.where((client) {
        String? valueToCheck;
        // Mapeamos las llaves a propiedades del modelo
        switch (filterBy) {
          case 'id':
            valueToCheck = client.id.toString();
            break;
          case 'nombre':
            valueToCheck = client.nombre;
            break;
          case 'email':
            valueToCheck = client.email;
            break;
          case 'fechaNac':
            valueToCheck = client.fechaNacimiento.toString();
            break;
          case 'whatsapp':
            valueToCheck = client.whatsapp;
            break;
          case 'saldo':
            valueToCheck = client.saldo.toString();
            break;
          case 'contacto':
            valueToCheck = client.datoContacto;
            break;
          case 'direccion':
            valueToCheck = client.direccion;
            break;
          default:
            valueToCheck = client.nombre;
        }
        return valueToCheck?.toLowerCase().contains(query.toLowerCase()) ??
            false;
      }).toList();
    }
    // Después de filtrar, resetea las selecciones para los clientes no visibles
    _selectedClients.clear();
    _isAllSelected = false;
    // Inicializa _selectedClients para los clientes filtrados actuales
    for (var client in _filteredClients) {
      _selectedClients[client.id] = false;
    }
    debugPrint(
        'ClientsHandler: Clientes filtrados. Total: ${_filteredClients.length}. Selecciones reseteadas.');
    notifyListeners();
  }
}
