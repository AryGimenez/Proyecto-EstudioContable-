class ClientsHandler {
  Map<int, bool> _selectedRows = {};
  bool _isAllSelected = false;

  final List<Map<String, String>> _clients = List.generate(10, (index) {
    return {
      'Nombre': 'Cliente $index',
      'Email': 'cliente$index@email.com',
      'Nacimiento': '01/01/2000',
      'WhatsApp': '+598 98 123 456',
      'Montos del Mes': '\$3,500',
      'Contacto': '+598 98 123 456',
      'Dirección': 'Calle X',
    };
  });

  List<Map<String, String>> filteredClients = [];

  ClientsHandler() {
    filteredClients = List.from(_clients); // Copiar la lista original
  }

  Map<int, bool> getSelectedRows() => _selectedRows;
  bool get isAllSelected => _isAllSelected;

  void toggleRowSelection(int index, bool value) {
    _selectedRows[index] = value;
    _isAllSelected = _selectedRows.length == _clients.length &&
        _selectedRows.values.every((isSelected) => isSelected);
  }

  void selectAll(bool value) {
    _isAllSelected = value;
    _selectedRows.clear();
    for (int i = 0; i < filteredClients.length; i++) {
      _selectedRows[i] = value;
    }
  }

  void filterClients(String query, String filterBy) {
    if (query.isEmpty) {
      filteredClients = List.from(_clients); // Reset to all clients
    } else {
      filteredClients = _clients
          .where((client) => client[filterBy]!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  // Actualizamos la eliminación de clientes
  void deleteSelectedClients(Function() updateUI) {
    List<int> selectedIndexes = _selectedRows.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    selectedIndexes.sort((a, b) => b.compareTo(a)); // Sort in descending order to avoid index shifting
    for (int index in selectedIndexes) {
      if (index < filteredClients.length) {
        _clients.removeAt(index); // Eliminar del original
        filteredClients.removeAt(index); // Eliminar de los filtrados
      }
    }

    // Clear the selection after deletion
    _selectedRows.clear();
    _isAllSelected = false;

    // Llamar a updateUI para actualizar la interfaz
    updateUI();
  }
}
