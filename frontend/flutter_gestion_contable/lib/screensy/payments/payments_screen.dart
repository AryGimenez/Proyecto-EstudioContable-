import 'package:flutter/material.dart';
import 'package:flutter_gestion_contable/core/theme/app_colors.dart';
import 'payments_handler.dart'; // Importamos la clase PaymentsHandler

class PaymentsScreen extends StatefulWidget {
  const PaymentsScreen({super.key});

  @override
  _PaymentsScreenState createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  // Creamos una instancia de PaymentsHandler para gestionar el estado
  final PaymentsHandler _handler = PaymentsHandler();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(0.0), // Padding para todo el contenido
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título de la sección de filtro
            Center(
              child: Text(
                'Filtrar por', // Título del filtro
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              children: [
                // Filtro de clientes y nombre completo
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: _handler
                                .isClientsChecked, // Control de estado de 'Clientes'
                            onChanged: (bool? value) {
                              setState(() {
                                _handler.isClientsChecked =
                                    value ?? false; // Actualizamos el estado
                              });
                            },
                          ),
                          Icon(Icons.person), // Icono de persona
                          SizedBox(width: 5),
                          Text('Clientes'), // Texto del filtro
                          Spacer(), // Espaciador para que el siguiente checkbox se acomode a la derecha
                          Checkbox(
                            value: _handler
                                .isFullNameChecked, // Control de estado de 'Nombre Completo'
                            onChanged: (bool? value) {
                              setState(() {
                                _handler.isFullNameChecked =
                                    value ?? false; // Actualizamos el estado
                              });
                            },
                          ),
                          Text('Nombre completo'), // Texto del filtro
                        ],
                      ),
                      SizedBox(height: 10),
                      // Filtro de fecha
                      Row(
                        children: [
                          Checkbox(
                            value: _handler
                                .isDateChecked, // Control de estado de 'Fecha'
                            onChanged: (bool? value) {
                              setState(() {
                                _handler.isDateChecked =
                                    value ?? false; // Actualizamos el estado
                              });
                            },
                          ),
                          Text('Desde:'),
                          if (_handler.selectedDate != null)
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                "${_handler.selectedDate!.day}/${_handler.selectedDate!.month}/${_handler.selectedDate!.year}",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                            ),
                          SizedBox(width: 5),
                          // Botón para seleccionar fecha
                          IconButton(
                            icon: Icon(Icons.calendar_today),
                            onPressed: () => _handler.selectDate(
                                context), // Llamamos a la función selectDate
                          ),
                        ],
                      ),
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
                    child: Icon(
                      Icons.search,
                      size: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            // Línea de impuestos
            _buildImpuestosLine(),
            SizedBox(height: 5),
            // Tabla de datos
            _buildDataTable(),
            SizedBox(height: 5),
            // Fila con botones y expansión
            _buildActionsRow(),
            SizedBox(height: 5),
            // Fila de pagos
            _buildPagosLine(),
            SizedBox(height: 5),
            // Segunda tabla con nuevas columnas
            _buildPaymentsTable(),
            SizedBox(height: 5),
            _buildActionSmallButtons(),
            SizedBox(height: 5),
            _buildHorizontalLine(),
            SizedBox(height: 5),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  // Método para construir la línea de impuestos
  Widget _buildImpuestosLine() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(5),
      color:
          AppColors.primary, // Usamos el color primario definido en AppColors
      child: Text(
        'Impuestos',
        style: TextStyle(
            fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
        textAlign: TextAlign.center, // Centramos el texto
      ),
    );
  }

  // Método para construir la tabla
  // Método para construir la tabla
// Método para construir la tabla
// Método para construir la tabla
// Método para construir la tabla
Widget _buildDataTable() {
  return Expanded(
    child: SingleChildScrollView(
      child: SizedBox(
        width: double.infinity, // Ancho completo de la pantalla
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical, // Permite desplazamiento vertical
          child: DataTable(
            columnSpacing: 20.0,
            dataRowHeight: 24.0,
            headingRowHeight: 24.0,
            headingRowColor: MaterialStateProperty.all(AppColors.primary),
            columns: [
              DataColumn(
                label: Checkbox(
                  value: _handler.isSelectAll, // Estado global de selección
                  onChanged: (bool? value) {
                    setState(() {
                      _handler.toggleSelectAll(value ?? false); // Actualiza todos los checkboxes
                    });
                  },
                ),
              ),
              DataColumn(label: Text('Nombre')),
              DataColumn(label: Text('Cliente')),
              DataColumn(label: Text('Vencimiento')),
              DataColumn(label: Text('Monto')),
              DataColumn(label: Text('Honorario')),
            ],
            rows: List.generate(10, (index) {
              return DataRow(
                cells: [
                  DataCell(Checkbox(
                    value: _handler.selectedRows[index], // Estado de cada fila
                    onChanged: (bool? value) {
                      setState(() {
                        _handler.toggleSelection(index, value ?? false); // Cambia el estado de la fila
                      });
                    },
                  )),
                  DataCell(Text('Nombre ${index + 1}')),
                  DataCell(Text('Cliente ${index + 1}')),
                  DataCell(Text('01/01/2025')),
                  DataCell(Text('\$500')),
                  DataCell(Text('\$300')),
                ],
              );
            }),
          ),
        ),
      ),
    ),
  );
}


Widget _buildPaymentsTable() {
  return Expanded(
    child: SingleChildScrollView(
      child: SizedBox(
        width: double.infinity, // Ancho completo de la pantalla
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical, // Desplazamiento vertical
          child: DataTable(
            columnSpacing: 20.0,
            dataRowHeight: 24.0,
            headingRowHeight: 24.0,
            headingRowColor: MaterialStateProperty.all(AppColors.primary),
            columns: [
              DataColumn(
                label: Checkbox(
                  value: _handler.isSelectAll2, // Estado global de selección
                  onChanged: (bool? value) {
                    setState(() {
                      _handler.toggleSelectAll2(value ?? false); // Cambia el estado de todos los checkboxes
                    });
                  },
                ),
              ),
              DataColumn(label: Text('Nombre')),
              DataColumn(label: Text('Pago')),
              DataColumn(label: Text('Monto')),
              DataColumn(label: Text('Fecha')),
              DataColumn(label: Text('Comentario')),
            ],
            rows: List.generate(10, (index) {
              return DataRow(
                cells: [
                  DataCell(Checkbox(
                    value: _handler.selectedRows2[index], // Estado de cada fila
                    onChanged: (bool? value) {
                      setState(() {
                        _handler.toggleSelection2(index, value ?? false); // Actualiza el estado de la fila
                      });
                    },
                  )),
                  DataCell(Text('Pago ${index + 1}')),
                  DataCell(Text('Pago ${index + 1}')),
                  DataCell(Text('\$300')),
                  DataCell(Text('01/01/2025')),
                  DataCell(Text('Comentario ${index + 1}')),
                ],
              );
            }),
          ),
        ),
      ),
    ),
  );
}



  // Método para construir la fila de acciones (botón de agregar y expansión)
  Widget _buildActionsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment
          .spaceBetween, // Acomoda los elementos en los extremos
      children: [
        ElevatedButton(
          onPressed: () {},
          child: Text('Agregar'),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(30, 30), // Tamaño mínimo del botón
          ),
        ),
        SizedBox(width: 10),
        // Reemplazamos ExpansionTile por ElevatedButton
        Container(
          width: 550, // Ancho del contenedor con 300 de ancho
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0), // Bordes redondeados
            color: AppColors.primary, // Usamos el color primario
          ),
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              minimumSize: Size(550, 35),
              backgroundColor: AppColors.primary,
              padding: EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Centra el contenido
              children: [
                Text(
                  'Armar cheque', // Texto del botón
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 5), // Espaciado entre el icono y el texto
                Icon(Icons.keyboard_arrow_down,
                    color: Colors.white), // Icono de flecha
              ],
            ),
          ),
        ),
        SizedBox(width: 10),
        Row(
          children: [
            Icon(Icons.attach_money, color: Colors.green), // Icono de dinero
            SizedBox(width: 5),
            Text('30,000',
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold)), // Monto
          ],
        ),
      ],
    );
  }

  // Método para construir la fila de pagos
  Widget _buildPagosLine() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(5),
      color: AppColors.primary, // Usamos el color primario
      child: Text(
        'Pagos',
        style: TextStyle(
            fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
        textAlign: TextAlign.center, // Centramos el texto
      ),
    );
  }

  Widget _buildActionSmallButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
          width: 80, // Ancho reducido
          height: 30, // Alto reducido
          child: ElevatedButton(
            onPressed: () {
              // Acción para eliminar
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: EdgeInsets.zero, // Elimina el padding extra
            ),
            child: Text(
              'Eliminar',
              style: TextStyle(fontSize: 12), // Texto más pequeño
            ),
          ),
        ),
        SizedBox(
          width: 80, // Ancho reducido
          height: 30, // Alto reducido
          child: ElevatedButton(
            onPressed: () {
              // Acción para modificar
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: EdgeInsets.zero, // Elimina el padding extra
            ),
            child: Text(
              'Modificar',
              style: TextStyle(fontSize: 12), // Texto más pequeño
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 100, // Ancho reducido
          height: 35, // Alto reducido
          child: ElevatedButton(
            onPressed: () {
              // Acción para eliminar
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: EdgeInsets.zero, // Elimina el padding extra
            ),
            child: Text(
              'Cancelar',
              style: TextStyle(fontSize: 12), // Texto más pequeño
            ),
          ),
        ),
        SizedBox(
          width: 100, // Ancho reducido
          height: 35, // Alto reducido
          child: ElevatedButton(
            onPressed: () {
              // Acción para modificar
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: EdgeInsets.zero, // Elimina el padding extra
            ),
            child: Text(
              'Agregar',
              style: TextStyle(fontSize: 12), // Texto más pequeño
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHorizontalLine() {
    return Divider(
      color: AppColors.primary, // Color de la línea
      thickness: 1, // Grosor de la línea
      height: 20, // Espaciado vertical
    );
  }

  // Método para construir la segunda tabla con las nuevas 
  
}
