import 'package:flutter/foundation.dart'; // Para debugPrint
import 'package:flutter/material.dart'; // Para ChangeNotifier
import 'package:flutter_gestion_contable/services/api_service.dart';

class ClientsHandler with ChangeNotifier {
  final ApiService _apiService;

  List<Map<String, dynamic>> _clients = []; // Lista original de clientes
  List<Map<String, dynamic>> _filteredClients = []; // Lista de clientes después de aplicar filtros
  Map<String, bool> _selectedClients = {}; // Mapa para el estado de selección de cada cliente (ID -> bool)
  bool _isAllSelected = false; // Estado para el checkbox "Seleccionar todos"

  ClientsHandler(this._apiService);

  // Getters para acceder al estado desde la UI
  List<Map<String, dynamic>> get clients => _clients; // Podrías exponer solo _filteredClients si prefieres
  List<Map<String, dynamic>> get filteredClients => _filteredClients;
  bool get isAllSelected => _isAllSelected;
  int get selectedClientsCount => _selectedClients.values.where((selected) => selected).length;
  
  // Devuelve el cliente seleccionado si solo hay uno
  Map<String, dynamic>? get selectedClient {
    if (selectedClientsCount != 1) {
      return null;
    }
    final selectedId = _selectedClients.keys.firstWhere((id) => _selectedClients[id]!);
    return _clients.firstWhere(
      (client) => client['Cli_ID']?.toString() == selectedId,
      orElse: () => throw Exception('Cliente seleccionado no encontrado en la lista original.'),
    );
  }

  // Carga inicial de clientes
  Future<void> fetchClients() async {
    try {
      debugPrint('ClientsHandler: Iniciando fetchClients...');
      final List<dynamic> data = await _apiService.getClientes(); 
      _clients = data.cast<Map<String, dynamic>>(); // Castea la lista dinámica a List<Map<String, dynamic>>
      _filteredClients = List.from(_clients); // Reinicia filteredClients con todos los clientes
      _selectedClients.clear(); // Limpia selecciones anteriores
      _isAllSelected = false; // Restablece el estado de "seleccionar todos"

      // Inicializa el mapa de selección para todos los clientes cargados
      for (var client in _clients) {
        final clientId = client['Cli_ID']?.toString();
        if (clientId != null) {
          _selectedClients[clientId] = false;
        }
      }
      debugPrint('ClientsHandler: Clientes cargados y seleccionables inicializados. Total: ${_clients.length}');
      notifyListeners(); // Notifica a los widgets que el estado ha cambiado
    } catch (e) {
      debugPrint('ClientsHandler: Error al obtener clientes: $e');
      rethrow; // Relanza la excepción para que la UI pueda manejarla
    }
  }

  // Actualiza un cliente existente
  Future<void> updateClient(String clientId, Map<String, dynamic> updatedData) async {
    try {
      debugPrint('ClientsHandler: Intentando actualizar cliente ID: $clientId con datos: $updatedData');
      // Llama al método put genérico del ApiService
      await _apiService.put('clientes/$clientId', updatedData); 
      
      // Actualiza el cliente en las listas locales
      final index = _clients.indexWhere((client) => client['Cli_ID']?.toString() == clientId);
      if (index != -1) {
        _clients[index].addAll(updatedData); // Actualiza solo los campos proporcionados
        final filteredIndex = _filteredClients.indexWhere((client) => client['Cli_ID']?.toString() == clientId);
        if (filteredIndex != -1) {
          _filteredClients[filteredIndex].addAll(updatedData);
        }
      }
      debugPrint('ClientsHandler: Cliente ID $clientId actualizado localmente y notificado.');
      notifyListeners();
    } catch (e) {
      debugPrint('ClientsHandler: Error al actualizar cliente ID $clientId: $e');
      rethrow;
    }
  }

  // **MÉTODO DE ELIMINACIÓN DE CLIENTES SELECCIONADOS**
  Future<void> deleteSelectedClients() async {
    List<String> selectedIds = _selectedClients.entries
        .where((entry) => entry.value) // Filtra solo los IDs marcados como true
        .map((entry) => entry.key) // Obtiene solo los IDs
        .toList();

    if (selectedIds.isEmpty) {
      debugPrint('ClientsHandler: No hay clientes seleccionados para eliminar.');
      return; // No hace nada si no hay nada seleccionado
    }

    debugPrint('ClientsHandler: Intentando eliminar clientes con IDs: $selectedIds');
    try {
      for (String id in selectedIds) {
        debugPrint('ClientsHandler: Llamando a _apiService.delete para ID: $id');
        await _apiService.delete('clientes/$id'); // Llama al método DELETE del ApiService
      }

      // Después de la eliminación exitosa en el backend, actualiza las listas locales
      _clients.removeWhere((client) => selectedIds.contains(client['Cli_ID']?.toString() ?? ''));
      _filteredClients.removeWhere((client) => selectedIds.contains(client['Cli_ID']?.toString() ?? ''));
      
      // Limpia la selección y restablece el estado de "seleccionar todos"
      _selectedClients.clear();
      _isAllSelected = false;
      debugPrint('ClientsHandler: Clientes eliminados localmente y notificados. IDs: $selectedIds');
      notifyListeners(); // Notifica a los widgets que la lista ha cambiado
    } catch (e) {
      debugPrint('ClientsHandler: Error al eliminar clientes: $e');
      rethrow; // Relanza la excepción para que la UI pueda mostrar un SnackBar, etc.
    }
  }

  // Verifica si una fila está seleccionada
  bool isRowSelected(String clientId) {
    return _selectedClients[clientId] ?? false;
  }

  // Alterna el estado de selección de una fila
  void toggleRowSelection(String clientId, bool value) {
    _selectedClients[clientId] = value;
    // Actualiza _isAllSelected si todos los clientes filtrados están seleccionados
    _isAllSelected = _filteredClients.every((client) =>
        _selectedClients[client['Cli_ID']?.toString() ?? ''] == true);
    notifyListeners();
  }

  // Selecciona o deselecciona todas las filas
  void selectAll(bool value) {
    _isAllSelected = value;
    _selectedClients.clear(); // Limpia el mapa para reconstruirlo
    if (value) {
      // Si se selecciona todo, marca todos los clientes filtrados
      for (var client in _filteredClients) {
        _selectedClients[client['Cli_ID']?.toString() ?? ''] = true;
      }
    }
    debugPrint('ClientsHandler: SelectAll establecido a $value. Clientes seleccionados: ${selectedClientsCount}');
    notifyListeners();
  }

  // Filtra la lista de clientes
  void filterClients(String query, String filterBy) {
    if (query.isEmpty) {
      _filteredClients = List.from(_clients); // Si la consulta está vacía, muestra todos
    } else {
      _filteredClients = _clients
          .where((client) =>
              (client[filterBy]?.toString().toLowerCase().contains(query.toLowerCase()) ?? false))
          .toList();
    }
    // Después de filtrar, resetea las selecciones para los clientes no visibles
    _selectedClients.clear(); 
    _isAllSelected = false;
    // Inicializa _selectedClients para los clientes filtrados actuales
    for (var client in _filteredClients) {
        final clientId = client['Cli_ID']?.toString();
        if (clientId != null) {
          _selectedClients[clientId] = false;
        }
    }
    debugPrint('ClientsHandler: Clientes filtrados. Total: ${_filteredClients.length}. Selecciones reseteadas.');
    notifyListeners();
  }
}