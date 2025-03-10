import 'package:flutter/material.dart';

class DepositsHandler extends ChangeNotifier {
  bool isClientsChecked = false;

  // Lista para controlar la selección de las filas
  List<bool> selectedRows = List.generate(10, (index) => false); // Aquí puedes tener cualquier cantidad de filas

  // Método para seleccionar una fila individual
  void toggleRowSelection(int index, bool? value) {
    if (index >= 0 && index < selectedRows.length) {
      selectedRows[index] = value ?? false;
      notifyListeners(); // Notificamos que el estado ha cambiado
    }
  }

  // Método para seleccionar todas las filas
  void selectAllRows() {
    selectedRows = List.generate(selectedRows.length, (_) => true);
    notifyListeners(); // Notificamos que el estado ha cambiado
  }

  // Método para deseleccionar todas las filas
  void deselectAllRows() {
    selectedRows = List.generate(selectedRows.length, (_) => false);
    notifyListeners(); // Notificamos que el estado ha cambiado
  }
}
