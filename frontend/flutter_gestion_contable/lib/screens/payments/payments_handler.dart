import 'package:flutter/material.dart';

class PaymentsHandler {
  // Variables para manejar el estado de los filtros
  bool isClientsChecked = false; // Filtro para clientes
  bool isFullNameChecked = false; // Filtro para nombre completo
  bool isDateChecked = false; // Filtro para fecha
  DateTime? selectedDate; // Fecha seleccionada

  // Lista para manejar la selección de las filas en la tabla
  List<bool> selectedRows = [false, false, false, false, false, false, false, false, false, false]; // Estado de los checkboxes para las filas, la longitud de esta lista puede variar
  List<bool> selectedRows2 = [false, false, false, false, false, false, false, false, false, false]; // Estado de los checkboxes para las filas, la longitud de esta lista puede variar
  // Checkbox global para seleccionar todos los registros
  bool isSelectAll = false;
  bool isSelectAll2 = false;

  // Función para mostrar el selector de fecha
  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      selectedDate = picked; // Actualizamos la fecha seleccionada
    }
  }

  // Cambiar el estado del checkbox de una fila
  void toggleSelection(int index, bool value) {
    selectedRows[index] = value; // Actualizamos la selección de la fila
    // Si alguna fila es desmarcada, el "Seleccionar Todos" debe desmarcarse
    if (selectedRows.contains(false)) {
      isSelectAll = false;
    } else {
      isSelectAll = true;
    }
  }

    void toggleSelection2(int index, bool value) {
    selectedRows2[index] = value; // Actualizamos la selección de la fila
    // Si alguna fila es desmarcada, el "Seleccionar Todos" debe desmarcarse
    if (selectedRows2.contains(false)) {
      isSelectAll2 = false;
    } else {
      isSelectAll2 = true;
    }
  }

  // Cambiar el estado del checkbox global
  void toggleSelectAll(bool value) {
    isSelectAll = value; // Actualizamos el checkbox global
    // Actualiza todos los checkboxes de las filas al mismo estado del checkbox global
    selectedRows = List.filled(selectedRows.length, value);
  }

  void toggleSelectAll2(bool value) {
    isSelectAll2 = value; // Actualizamos el checkbox global
    // Actualiza todos los checkboxes de las filas al mismo estado del checkbox global
    selectedRows2 = List.filled(selectedRows2.length, value);
  }

  // Funciones de los filtros
  void toggleClientsFilter(bool value) {
    isClientsChecked = value; // Actualizamos el estado del filtro de clientes
  }

  void toggleFullNameFilter(bool value) {
    isFullNameChecked = value; // Actualizamos el estado del filtro de nombre completo
  }

  void toggleDateFilter(bool value) {
    isDateChecked = value; // Actualizamos el estado del filtro de fecha
  }
}
