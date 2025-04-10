import 'package:flutter/material.dart';

class DepositsHandler extends ChangeNotifier {
  // Estado para la casilla de "Clientes"
  bool isClientsChecked = false;

  bool isImpuestoChecked = false;

  // Lista para controlar la selección de las filas
  List<bool> selectedRows = List.generate(10, (index) => false);

  // Método para alternar el estado de la casilla de "Clientes"
  void toggleClientsChecked(bool value) {
    isClientsChecked = value;
    notifyListeners(); // Notifica el cambio a la UI
  }

   void toggleImpuestoChecked(bool value) {
    isImpuestoChecked = value;
    notifyListeners(); // Notifica el cambio a la UI
  }

  // Método para alternar la selección de una fila individual
  void toggleRowSelection(int index, bool? value) {
    if (index >= 0 && index < selectedRows.length) {
      selectedRows[index] = value ?? false;
      notifyListeners(); // Notifica a la UI sobre el cambio de selección
    }
  }

  // Método para seleccionar todas las filas
  void selectAllRows() {
    selectedRows = List.generate(selectedRows.length, (_) => true);
    notifyListeners(); // Notifica a la UI sobre la selección total
  }

  // Método para deseleccionar todas las filas
  void deselectAllRows() {
    selectedRows = List.generate(selectedRows.length, (_) => false);
    notifyListeners(); // Notifica a la UI sobre la deselección total
  }

  // Método para manejar la eliminación de los elementos seleccionados
  void eliminarSeleccionados() {
    print("Eliminar elementos seleccionados");
    notifyListeners(); // Notifica a la UI que se han eliminado elementos
  }

  // Método para manejar la modificación de los elementos seleccionados
  void modificarSeleccionados() {
    print("Modificar elementos seleccionados");
    notifyListeners(); // Notifica a la UI que se han modificado elementos
  }

  // Método para agregar un nuevo depósito
  void agregarNuevo() {
    print("Agregar nuevo depósito");
    notifyListeners(); // Notifica a la UI que se ha agregado un nuevo depósito
  }

  // Método para cancelar la acción actual
  void cancelarAccion() {
    print("Acción cancelada");
    notifyListeners(); // Notifica a la UI sobre la cancelación
  }
}
