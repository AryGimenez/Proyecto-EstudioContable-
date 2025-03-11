import 'package:flutter/material.dart';
import 'package:flutter_gestion_contable/core/theme/app_colors.dart';
import 'deposits_handler.dart'; // Asegúrate de importar tu handler

class DepositsScreen extends StatefulWidget {
  const DepositsScreen({super.key});

  @override
  _DepositsScreenState createState() => _DepositsScreenState();
}

class _DepositsScreenState extends State<DepositsScreen> {
  final DepositsHandler _handler = DepositsHandler(); // Instancia de DepositsHandler para manejar el estado

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Filtrar por',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      // Casilla de verificación para "Clientes"
                      Checkbox(
                        value: _handler.isClientsChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            _handler.toggleClientsChecked(value ?? false); // Llamamos al método del handler para cambiar el estado de "Clientes"
                          });
                        },
                      ),
                      Icon(Icons.person),
                      SizedBox(width: 5),
                      Text('Clientes'),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                // Botón de búsqueda
                SizedBox(
                  width: 40,
                  height: 80,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                    ),
                    child: Icon(Icons.search, size: 24, color: Colors.white),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            _buildImpuestosPagarLine(), // Línea para "Impuestos a Pagar"
            SizedBox(height: 10),
            _buildDataTableWithTotal(), // Función para mostrar la tabla con los totales
            SizedBox(height: 10),
            _buildMontoDelChequeLine(), // Línea para mostrar el monto del cheque
            SizedBox(height: 10),
            _buildActionButtonsRow(), // Fila con botones de acción: Eliminar y Modificar
            SizedBox(height: 10),
            _buildHorizontalLine(), // Línea horizontal de separación
            SizedBox(height: 10),
            _buildActionButtonsRow2(), // Fila con botones de acción: Agregar Nuevo y Cancelar
          ],
        ),
      ),
    );
  }

  // Función que construye la tabla con los totales
  Widget _buildDataTableWithTotal() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 200,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: _buildDataTable(), // Llamada a la función que crea la tabla de datos
          ),
        ),
        SizedBox(height: 10),
        _buildMoneyRow(), // Fila con los totales de montos
      ],
    );
  }

  // Fila con los totales de montos (Ejemplo de dinero)
  Widget _buildMoneyRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(
          children: [
            Icon(Icons.attach_money, color: AppColors.primary),
            Text('3000',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        Row(
          children: [
            Icon(Icons.attach_money, color: AppColors.primary),
            Text('3000',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  // Función que construye la línea para "Impuestos a Pagar"
  Widget _buildImpuestosPagarLine() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(5),
      color: AppColors.primary,
      child: Text(
        'Impuestos a Pagar',
        style: TextStyle(
            fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );
  }

  // Función que construye la línea para "Monto del Cheque"
  Widget _buildMontoDelChequeLine() {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(5),
          color: AppColors.primary,
          child: Text(
            'Monto del Cheque',
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
        Positioned(
          right: 350,
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.attach_money, color: AppColors.primary),
                  Text(
                    '30,000',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              )),
        ),
      ],
    );
  }

  // Función que construye la tabla de datos
  Widget _buildDataTable() {
    return SizedBox(
      width: double.infinity,
      child: DataTable(
        columnSpacing: 20.0,
        dataRowHeight: 24.0,
        headingRowHeight: 24.0,
        headingRowColor: MaterialStateProperty.all(AppColors.primary),
        columns: [
          // Columna para la casilla de verificación de seleccionar/deseleccionar todas las filas
          DataColumn(
            label: Row(
              children: [
                Checkbox(
                  value: _handler.selectedRows.every((selected) => selected),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value ?? false) {
                        _handler.selectAllRows(); // Selecciona todas las filas si se marca la casilla
                      } else {
                        _handler.deselectAllRows(); // Deselecciona todas las filas si se desmarca la casilla
                      }
                    });
                  },
                ),
              ],
            ),
          ),
          DataColumn(label: Text('Impuesto')),
          DataColumn(label: Text('Monto')),
          DataColumn(label: Text('Honorario')),
          DataColumn(label: Text('Vencimiento')),
        ],
        rows: List.generate(10, (index) {
          return DataRow(
            cells: [
              DataCell(
                // Casilla de verificación para cada fila
                Checkbox(
                  value: _handler.selectedRows[index],
                  onChanged: (bool? value) {
                    setState(() {
                      _handler.toggleRowSelection(index, value); // Llamamos al método para alternar la selección de la fila
                    });
                  },
                ),
              ),
              DataCell(Text('Impuesto ${index + 1}')),
              DataCell(Text('\$500')),
              DataCell(Text('\$300')),
              DataCell(Text('01/01/2025')),
            ],
          );
        }),
      ),
    );
  }

  // Fila con los botones de acción "Eliminar" y "Modificar"
  Widget _buildActionButtonsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 100,
          height: 35,
          child: ElevatedButton(
            onPressed: () {
              _handler.eliminarSeleccionados(); // Llamamos al método para eliminar los elementos seleccionados
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: EdgeInsets.zero,
            ),
            child: Text(
              'Eliminar',
              style: TextStyle(fontSize: 12),
            ),
          ),
        ),
        SizedBox(
          width: 100,
          height: 35,
          child: ElevatedButton(
            onPressed: () {
              _handler.modificarSeleccionados(); // Llamamos al método para modificar los elementos seleccionados
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: EdgeInsets.zero,
            ),
            child: Text(
              'Modificar',
              style: TextStyle(fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }

  // Línea horizontal de separación
  Widget _buildHorizontalLine() {
    return Divider(
      color: AppColors.primary,
      height: 2,
    );
  }

  // Fila con los botones de acción "Agregar Nuevo" y "Cancelar"
  Widget _buildActionButtonsRow2() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 100,
          height: 35,
          child: ElevatedButton(
            onPressed: () {
              _handler.agregarNuevo(); // Llamamos al método para agregar un nuevo depósito
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: EdgeInsets.zero,
            ),
            child: Text(
              'Agregar Nuevo',
              style: TextStyle(fontSize: 12),
            ),
          ),
        ),
        SizedBox(
          width: 100,
          height: 35,
          child: ElevatedButton(
            onPressed: () {
              _handler.cancelarAccion(); // Llamamos al método para cancelar la acción
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: EdgeInsets.zero,
            ),
            child: Text(
              'Cancelar',
              style: TextStyle(fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }
}
