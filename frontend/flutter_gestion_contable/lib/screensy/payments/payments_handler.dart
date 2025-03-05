// payments_handler.dart

import 'package:flutter/material.dart';

// Esta clase maneja la lógica detrás de la pantalla de pagos
class PaymentsHandler {
  // Métodos de control y estado de los checkboxes y fecha

  // Controla si se seleccionaron los clientes
  bool isClientsChecked = false;
  
  // Controla si se seleccionó el nombre completo
  bool isFullNameChecked = false;
  
  // Controla si se seleccionó la fecha
  bool isDateChecked = false;
  
  // La fecha seleccionada
  DateTime? selectedDate;

  // Función para mostrar el selector de fecha
  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),  // Fecha inicial: hoy
      firstDate: DateTime(2000),    // Fecha más antigua: 2000
      lastDate: DateTime(2101),     // Fecha más reciente: 2101
    );
    
    // Si se selecciona una fecha diferente, la actualizamos
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
    }
  }
}
