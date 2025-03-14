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
    filteredClients = List.from(_clients);
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
    for (int i = 0; i < _clients.length; i++) {
      _selectedRows[i] = value;
    }
  }

  void filterClients(String query, String filterBy) {
    if (query.isEmpty) {
      filteredClients = List.from(_clients);
    } else {
      filteredClients = _clients
          .where((client) => client[filterBy]!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }
}
