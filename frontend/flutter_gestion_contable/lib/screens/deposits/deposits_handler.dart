// frontend/flutter_gestion_contable/lib/screens/deposits/deposits_handler.dart

import 'package:flutter/material.dart'; // Importa la librería fundamental de Flutter para usar el tipo 'ChangeNotifier' y 'bool'.

/// Clase que actúa como el manejador del estado para la vista de Depósitos (DepositsHandler).
///
/// Extiende 'ChangeNotifier' para permitir que los widgets de Flutter se suscriban
/// a los cambios en el estado (ej. al seleccionar una fila o un checkbox) y se
/// reconstruyan automáticamente con los nuevos datos. Es una implementación del
/// patrón Provider para el manejo de la lógica de UI y datos.
class DepositsHandler extends ChangeNotifier {
  
  /// Estado para la casilla de "Clientes" (probablemente un checkbox maestro).
  /// Controla si se están mostrando u operando solo los clientes.
  bool isClientsChecked = false;

  /// Lista booleana para controlar la selección de las filas en una tabla (DataTable).
  /// Inicializa una lista de 10 elementos, todos en 'false' (no seleccionados).
  List<bool> selectedRows = List.generate(10, (index) => false);

  /// Método para alternar el estado de la casilla de "Clientes"
  void toggleClientsChecked(bool value) {
    isClientsChecked = value;
    notifyListeners(); // Notifica el cambio a la UI
  }

  /// Método para alternar el estado de selección de una fila individual
  /// en la lista de datos, basándose en su índice.
  ///
  /// Primero verifica que el 'index' esté dentro de los límites válidos
  /// de la lista 'selectedRows' antes de actualizar el valor.
  /// El parámetro 'value' (bool?) puede ser nulo, en cuyo caso se asume 'false'.
  /// Finalmente, notifica a la interfaz de usuario para que actualice la visualización
  /// del checkbox de la fila.
  void toggleRowSelection(int index, bool? value) {
    if (index >= 0 && index < selectedRows.length) { // Verifica que el índice esté dentro de los límites de la lista para evitar errores.
      selectedRows[index] = value ?? false; // Actualiza el estado de selección de la fila específica.
      notifyListeners(); // Notifica el cambio a la UI
    }
  }

  /// Método para seleccionar todas las filas de datos visibles en la tabla.
  ///
  /// Itera sobre la lista de control de selección y establece todos los valores
  /// a 'true'. Típicamente es disparado por un checkbox de "Seleccionar Todo"
  /// y luego notifica a la interfaz de usuario para que se actualice visualmente.
  void selectAllRows() {
    selectedRows = List.generate(selectedRows.length, (_) => true);
    notifyListeners(); // Notifica a la UI sobre la selección total
  }

  /// Método para deseleccionar todas las filas de datos de la tabla.
  ///
  /// Itera sobre la lista de control de selección y establece todos los valores
  /// a 'false'. Esta función se llama típicamente para limpiar la selección
  /// actual, y luego notifica a la interfaz de usuario para reflejar el cambio.
  void deselectAllRows() {
    selectedRows = List.generate(selectedRows.length, (_) => false);
    notifyListeners(); // Notifica a la UI sobre la deselección total
  }

  /// Método que inicia el proceso de eliminación de los elementos que han sido
  /// marcados como seleccionados en la lista de 'selectedRows'.
  ///
  /// Este método ejecuta la lógica de negocio real (ej. llamar a una API
  /// o eliminar datos de la base de datos) y, tras la acción,
  /// notifica a la UI que la lista de datos ha cambiado.
  void eliminarSeleccionados() {
    print("Eliminar elementos seleccionados");
    notifyListeners(); // Notifica a la UI que se han eliminado elementos
  }

  /// Método que inicia el proceso de modificación de los elementos
  /// que han sido marcados como seleccionados en la lista de 'selectedRows'.
  ///
  /// Este método ejecuta la lógica para abrir una interfaz de edición,
  /// pre-cargar los datos de los elementos seleccionados (si es uno),
  /// o notifica a la UI que se ha iniciado un flujo de modificación masiva.
  void modificarSeleccionados() {
    print("Modificar elementos seleccionados");
    notifyListeners(); // Notifica a la UI que se han modificado elementos
  }

  /// Método que inicia el flujo para agregar un nuevo elemento a la lista
  /// (en este caso, un nuevo depósito o registro).
  ///
  /// Este método ejecuta la lógica de navegación (por ejemplo, empujar una nueva
  /// pantalla de formulario) o abre un diálogo para que el usuario pueda ingresar
  /// los datos de un nuevo registro, y luego notifica a la UI si es necesario
  /// actualizar la lista.
  void agregarNuevo() {
    print("Agregar nuevo depósito");
    notifyListeners(); // Notifica a la UI que se ha agregado un nuevo depósito
  }

  /// Método que maneja la lógica de cancelar cualquier acción o proceso que esté
  /// actualmente en curso o en espera de confirmación.
  ///
  /// Típicamente se utiliza para limpiar formularios, descartar cambios
  /// no guardados en el estado, o salir de un modo de edición/selección,
  /// notificando luego a la UI para que regrese a su estado base.
  void cancelarAccion() {
    print("Acción cancelada");
    notifyListeners(); // Notifica a la UI sobre la cancelación
  }
}
