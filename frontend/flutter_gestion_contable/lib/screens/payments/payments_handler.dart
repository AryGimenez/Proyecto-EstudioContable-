// frontend/flutter_gestion_contable/lib/screens/payments/payments_handler.dart

import 'package:flutter/material.dart';
import 'package:flutter_gestion_contable/services/api_service.dart';

/// Clase que maneja el estado, la lógica de la UI y las interacciones
/// para la pantalla de Pagos.
///
/// **IMPORTANTE:** Extiende [ChangeNotifier] para poder ser utilizada con
/// [ChangeNotifierProvider] y notificar a los widgets cuando el estado interno
/// (filtros, selecciones) cambie.
class PaymentsHandler extends ChangeNotifier {
  // Variables para manejar el estado de los filtros
  bool isClientsChecked = false; // Filtro para clientes
  bool isFullNameChecked = false; // Filtro para nombre completo
  bool isDateChecked = false; // Filtro para fecha
  DateTime? selectedDate; // Fecha seleccionada

  // Listas para almacenar los datos reales
  List<Map<String, dynamic>> impuestos = [];
  List<Map<String, dynamic>> pagos = [];

  // Listas filtradas para mostrar
  List<Map<String, dynamic>> filteredImpuestos = [];
  List<Map<String, dynamic>> filteredPagos = [];

  // Listas para manejar la selección de las filas en la tabla
  List<bool> selectedRows =
      []; // Estado de los checkboxes para las filas de impuestos
  List<bool> selectedRows2 =
      []; // Estado de los checkboxes para las filas de pagos

  // Checkbox global para seleccionar todos los registros
  bool isSelectAll = false;
  bool isSelectAll2 = false;

  // Constructor
  PaymentsHandler() {
    fetchData();
  }

  // Método para obtener datos del backend
  Future<void> fetchData() async {
    try {
      // Obtener impuestos
      final impuestosData = null;
      impuestos = List<Map<String, dynamic>>.from(impuestosData);
      filteredImpuestos = List<Map<String, dynamic>>.from(impuestosData);
      selectedRows = List.filled(impuestos.length, false);

      // Obtener pagos
      final pagosData = null;
      pagos = List<Map<String, dynamic>>.from(pagosData);
      filteredPagos = List<Map<String, dynamic>>.from(pagosData);
      selectedRows2 = List.filled(pagos.length, false);
    } catch (e) {
      print('Error al obtener datos: $e');
      // Inicializar con listas vacías en caso de error
      impuestos = [];
      pagos = [];
      filteredImpuestos = [];
      filteredPagos = [];
      selectedRows = [];
      selectedRows2 = [];
    }
  }

  /// Muestra un selector de fecha modal ([showDatePicker]) al usuario.
  ///
  /// Una vez que el usuario selecciona una fecha, esta función:
  /// 1. Almacena la nueva fecha en la variable [selectedDate].
  /// 2. Llama a [notifyListeners()] para reconstruir cualquier widget (ej. un campo de texto)
  ///    que dependa de [selectedDate] y refleje el cambio en la UI.
  ///
  /// @param context El contexto del widget actual, necesario para mostrar el diálogo modal.
  /// @returns Un [Future<void>] que se completa cuando se cierra el selector de fecha.
  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      // Mostramos el selector de fecha
      context:
          context, // Contexto del widget actual, necesario para mostrar el diálogo modal
      initialDate:
          DateTime.now(), // Fecha inicial seleccionada, por defecto hoy
      firstDate: DateTime(2000), // Fecha mínima seleccionable
      lastDate: DateTime(2101), // Fecha máxima seleccionable
    );

    if (picked != null && picked != selectedDate) {
      // Si la fecha seleccionada es diferente a la actual
      selectedDate = picked; // Actualizamos la fecha seleccionada
    }
  }

  /// Cambia el estado de selección de un registro (fila) en la primera tabla.
  ///
  /// Este método realiza tres acciones principales:
  /// 1. **Actualiza** el valor booleano en el índice [index] de la lista [selectedRows].
  /// 2. **Sincroniza** el estado de [isSelectAll]: Si al menos una fila es desmarcada
  ///    ([selectedRows] contiene `false`), el checkbox global [isSelectAll] se desmarca.
  ///    Si todas están marcadas, [isSelectAll] se marca.
  /// 3. **Notifica** a los *widgets* (como la tabla y el checkbox global) para que
  ///    se reconstruyan y reflejen el nuevo estado.
  ///
  /// @param index El índice de la fila en la tabla cuya selección se va a cambiar.
  /// @param value El nuevo estado booleano para la fila (`true` para seleccionada, `false` para deseleccionada).
  void toggleSelection(int index, bool value) {
    selectedRows[index] = value; // Actualizamos la selección de la fila
    if (selectedRows.contains(false)) {
      // Si al menos una fila está desmarcada
      isSelectAll = false; // Desmarcamos el checkbox global
    } else {
      isSelectAll = true; // Marcamos el checkbox global
    }
  }

  /// Cambia el estado de selección de un registro (fila) en la segunda tabla.
  ///
  /// Este método es similar a [toggleSelection], pero opera sobre la segunda tabla
  /// y sus respectivas variables de estado ([selectedRows2], [isSelectAll2]).
  ///
  /// @param index El índice de la fila en la segunda tabla cuya selección se va a cambiar.
  /// @param value El nuevo estado booleano para la fila (`true` para seleccionada, `false` para deseleccionada).
  void toggleSelection2(int index, bool value) {
    selectedRows2[index] = value; // Actualizamos la selección de la fila
    if (selectedRows2.contains(false)) {
      // Si al menos una fila está desmarcada
      isSelectAll2 = false; // Desmarcamos el checkbox global
    } else {
      isSelectAll2 = true;
    }
  }

  /// Cambia el estado del checkbox global para seleccionar o deseleccionar todas las filas de la primera tabla.
  ///
  /// Este método actualiza:
  /// 1. **[isSelectAll]**: Establece su valor a [value].
  /// 2. **[selectedRows]**: Llena la lista con [value], marcando o desmarcando todas las filas.
  ///
  /// @param value El nuevo estado booleano para el checkbox global (`true` para seleccionar todas, `false` para deseleccionar todas).
  void toggleSelectAll(bool value) {
    isSelectAll = value; // Actualizamos el checkbox global
    selectedRows = List.filled(selectedRows.length,
        value); // Actualiza todos los checkboxes de las filas al mismo estado del checkbox global
  }

  /// Cambia el estado del checkbox global para seleccionar o deseleccionar todas las filas de la segunda tabla.
  ///
  /// Este método actualiza:
  /// 1. **[isSelectAll2]**: Establece su valor a [value].
  /// 2. **[selectedRows2]**: Llena la lista con [value], marcando o desmarcando todas las filas.
  ///
  /// @param value El nuevo estado booleano para el checkbox global (`true` para seleccionar todas, `false` para deseleccionar todas).
  void toggleSelectAll2(bool value) {
    isSelectAll2 = value; // Actualizamos el checkbox global
    selectedRows2 = List.filled(selectedRows2.length,
        value); // Actualiza todos los checkboxes de las filas al mismo estado del checkbox global
  }

  /// Cambia el estado del filtro de clientes.
  ///
  /// Este método actualiza:
  /// 1. **[isClientsChecked]**: Establece su valor a [value].
  ///
  /// @param value El nuevo estado booleano para el filtro de clientes (`true` para activar, `false` para desactivar).
  void toggleClientsFilter(bool value) {
    isClientsChecked = value; // Actualizamos el estado del filtro de clientes
  }

  /// Cambia el estado del filtro de nombre completo.
  ///
  /// Este método actualiza:
  /// 1. **[isFullNameChecked]**: Establece su valor a [value].
  ///
  /// @param value El nuevo estado booleano para el filtro de nombre completo (`true` para activar, `false` para desactivar).
  void toggleFullNameFilter(bool value) {
    isFullNameChecked =
        value; // Actualizamos el estado del filtro de nombre completo
  }

  /// Cambia el estado del filtro de fecha.
  ///
  /// Este método actualiza:
  /// 1. **[isDateChecked]**: Establece su valor a [value].
  ///
  /// @param value El nuevo estado booleano para el filtro de fecha (`true` para activar, `false` para desactivar).
  void toggleDateFilter(bool value) {
    isDateChecked = value; // Actualizamos el estado del filtro de fecha
  }
}
