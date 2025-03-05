import 'package:flutter/material.dart';

class PaymentsHandler {
  bool isClientsChecked = false;
  bool isFullNameChecked = false;
  bool isDateChecked = false;
  DateTime? selectedDate;

  // Lista para manejar la selección de las filas
  List<bool> selectedRows = [false, false, false]; // Estado de los checkboxes para 3 filas

  // Checkbox global para seleccionar todos los registros
  bool isSelectAll = false;

  // Función para mostrar el selector de fecha
  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
    }
  }

  // Cambiar el estado del checkbox de una fila
  void toggleSelection(int index, bool value) {
    selectedRows[index] = value;
    // Si alguna fila es desmarcada, el "Seleccionar Todos" debe desmarcarse
    if (selectedRows.contains(false)) {
      isSelectAll = false;
    } else {
      isSelectAll = true;
    }
  }

  // Cambiar el estado del checkbox global
  void toggleSelectAll(bool value) {
    isSelectAll = value;
    // Actualiza todos los checkboxes de las filas al mismo estado del checkbox global
    selectedRows = List.filled(selectedRows.length, value);
  }
}
