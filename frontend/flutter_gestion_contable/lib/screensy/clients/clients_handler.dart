class ClientsHandler {
  Map<int, bool> _selectedRows = {};
  bool _isAllSelected = false;

  Map<int, bool> getSelectedRows() => _selectedRows;
  bool get isAllSelected => _isAllSelected;

  void toggleRowSelection(int index, bool value) {
    _selectedRows[index] = value;
    _isAllSelected = _selectedRows.length == 10 && _selectedRows.values.every((isSelected) => isSelected);
  }

  void selectAll(bool value) {
    _isAllSelected = value;
    for (int i = 0; i < 10; i++) {
      _selectedRows[i] = value;
    }
  }
}
