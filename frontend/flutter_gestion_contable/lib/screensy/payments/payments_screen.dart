// payments_screen.dart

import 'package:flutter/material.dart';
import 'payments_handler.dart';  // Importamos la clase PaymentsHandler

// La clase principal para la pantalla de pagos
class PaymentsScreen extends StatefulWidget {
  @override
  _PaymentsScreenState createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  // Creamos una instancia de PaymentsHandler para gestionar la lógica
  final PaymentsHandler _handler = PaymentsHandler();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // El cuerpo de la pantalla
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título centrado
            Center(
              child: Text(
                'Filtrar por',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20), // Espacio entre el título y los inputs

            // Row para los primeros controles (Clientes, Nombre completo)
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          // Checkbox de "Clientes"
                          Checkbox(
                            value: _handler.isClientsChecked, // Estado del checkbox
                            onChanged: (bool? value) {
                              setState(() {
                                _handler.isClientsChecked = value ?? false; // Actualiza el estado
                              });
                            },
                          ),
                          Icon(Icons.person), // Ícono de persona
                          SizedBox(width: 5),
                          Text('Clientes'), // Texto "Clientes"
                          Spacer(),
                          
                          // Checkbox de "Nombre completo"
                          Checkbox(
                            value: _handler.isFullNameChecked, // Estado del checkbox
                            onChanged: (bool? value) {
                              setState(() {
                                _handler.isFullNameChecked = value ?? false; // Actualiza el estado
                              });
                            },
                          ),
                          Text('Nombre completo'), // Texto "Nombre completo"
                        ],
                      ),
                      SizedBox(height: 10), // Espacio entre los dos checkboxes

                      // Row para la fecha (Desde)
                      Row(
                        children: [
                          // Checkbox de "Desde"
                          Checkbox(
                            value: _handler.isDateChecked, // Estado del checkbox
                            onChanged: (bool? value) {
                              setState(() {
                                _handler.isDateChecked = value ?? false; // Actualiza el estado
                              });
                            },
                          ),
                          Text('Desde:'), // Texto "Desde:"
                          
                          // Mostrar la fecha seleccionada, si la hay
                          if (_handler.selectedDate != null)
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                "${_handler.selectedDate!.day}/${_handler.selectedDate!.month}/${_handler.selectedDate!.year}",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                            ),
                          SizedBox(width: 5), // Espacio entre la fecha y el ícono
                          
                          // Ícono para seleccionar la fecha
                          IconButton(
                            icon: Icon(Icons.calendar_today),
                            onPressed: () => _handler.selectDate(context), // Llama a la función selectDate
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                SizedBox(width: 10), // Espacio entre los inputs y el botón
                
                // Contenedor con el botón de búsqueda
                Container(
                  width: 40, // Ancho fijo del botón
                  height: 80, // Altura fija del botón
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      padding: WidgetStateProperty.all(EdgeInsets.zero),
                    ),
                    child: Icon(
                      Icons.search, // Ícono de búsqueda
                      size: 24,
                      color: Colors.white, // Color blanco del ícono
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20), // Espacio después del Row si es necesario
          ],
        ),
      ),
    );
  }
}
