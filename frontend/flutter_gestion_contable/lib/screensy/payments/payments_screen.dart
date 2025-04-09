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
  bool mostrarPagos = false;
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
                                .isDateDesdeChecked, // Control de estado de 'Fecha'
                            onChanged: (bool? value) {
                              setState(() {
                                _handler.isDateDesdeChecked =
                                    value ?? false; // Actualizamos el estado
                              });
                            },
                          ),
                          Text('Desde:'),
                          if (_handler.selectedDateDesde != null)
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                "${_handler.selectedDateDesde!.day}/${_handler.selectedDateDesde!.month}/${_handler.selectedDateDesde!.year}",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                            ),
                          SizedBox(width: 5),
                          // Botón para seleccionar fecha
                          IconButton(
                            icon: Icon(Icons.calendar_today),
                            onPressed: () => _handler.selectDateDesde(
                                context), // Llamamos a la función selectDate
                          ),
                          Spacer(),
                          Checkbox(
                            value: _handler
                                .isDateHastaChecked, // Control de estado de 'Fecha'
                            onChanged: (bool? value) {
                              setState(() {
                                _handler.isDateHastaChecked =
                                    value ?? false; // Actualizamos el estado
                              });
                            },
                          ),
                          Text('Hasta:'),
                          if (_handler.selectedDateHasta != null)
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                "${_handler.selectedDateHasta!.day}/${_handler.selectedDateHasta!.month}/${_handler.selectedDateHasta!.year}",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                            ),
                          SizedBox(width: 5),
                          // Botón para seleccionar fecha
                          IconButton(
                            icon: Icon(Icons.calendar_today),
                            onPressed: () => _handler.selectDateHasta(
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
            if (mostrarPagos) ...[
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
            ]
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
                        _handler.toggleSelectAll(
                            value ?? false); // Actualiza todos los checkboxes
                      });
                    },
                  ),
                ),
                DataColumn(label: Text('Nombre')),
                DataColumn(label: Text('Cliente')),
                DataColumn(label: Text('Vencimiento')),
                DataColumn(label: Text('Monto')),
                DataColumn(label: Text('Honorario')),
                DataColumn(label: Text('Monto Pago')),
              ],
              rows: List.generate(10, (index) {
                return DataRow(
                  cells: [
                    DataCell(Checkbox(
                      value:
                          _handler.selectedRows[index], // Estado de cada fila
                      onChanged: (bool? value) {
                        setState(() {
                          _handler.toggleSelection(index,
                              value ?? false); // Cambia el estado de la fila
                        });
                      },
                    )),
                    DataCell(Text('Nombre ${index + 1}')),
                    DataCell(Text('Cliente ${index + 1}')),
                    DataCell(Text('01/01/2025')),
                    DataCell(Text('\$500')),
                    DataCell(Text('\$300')),
                    DataCell(Text('\$400')),
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
                        _handler.toggleSelectAll2(value ??
                            false); // Cambia el estado de todos los checkboxes
                      });
                    },
                  ),
                ),
                DataColumn(label: Text('Cliente')),
                DataColumn(label: Text('Impuesto')),
                DataColumn(label: Text('Monto pago')),
                DataColumn(label: Text('Fecha de pago')),
                DataColumn(label: Text('Red de cobranza')),
                DataColumn(label: Text('Concepto')),
                DataColumn(label: Text('Editar')),
              ],
              rows: List.generate(10, (index) {
                return DataRow(
                  cells: [
                    DataCell(Checkbox(
                      value:
                          _handler.selectedRows2[index], // Estado de cada fila
                      onChanged: (bool? value) {
                        setState(() {
                          _handler.toggleSelection2(index,
                              value ?? false); // Actualiza el estado de la fila
                        });
                      },
                    )),
                    DataCell(Text('Cliente ${index + 1}')),
                    DataCell(Text('Impuesto ${index + 1}')),
                    DataCell(Text('\$300')),
                    DataCell(Text('01/01/2025')),
                    DataCell(Text('Intendencia')),
                    DataCell(Text('Concepto ${index + 1}')),
                    DataCell(
                      IconButton(
                        icon: const Icon(Icons.edit),
                        iconSize: 18,
                        onPressed: () {
                          // Agregar lógica para editar el cliente
                          // Aquí podrías abrir un formulario o un cuadro de diálogo
                        },
                      ),
                    ),
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
          onPressed: () {
            setState(() {
              _handler.agregarRegistrosSeleccionados();
            });
          },
          child: Text('Agregar'),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(30, 30),
          ),
        ),
        SizedBox(width: 10),
        // Reemplazamos ExpansionTile por ElevatedButton
        Container(
          width: 550,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: AppColors.primary,
          ),
          child: Row(
            children: [
              // Parte clickeable principal (que cambia el estado)
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      mostrarPagos =
                          true; // Mostramos u ocultamos "Pagos depositados"
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: AppColors.primary,
                    ),
                    child: Center(
                      child: Text(
                        'Armar cheque (${_handler.registrosAgregados.length})',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Parte clickeable de la flecha (solo muestra el dropdown)
              GestureDetector(
                onTapDown: (TapDownDetails details) {
                  final RenderBox overlay = Overlay.of(context)
                      .context
                      .findRenderObject() as RenderBox;

                  showMenu(
                    context: context,
                    position: RelativeRect.fromRect(
                      details.globalPosition & const Size(40, 40),
                      Offset.zero & overlay.size,
                    ),
                    items: [
                      PopupMenuItem(
                        enabled: false,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: 300,
                            minWidth: 500,
                            maxWidth: 500,
                          ),
                          child: Scrollbar(
                            thumbVisibility: true,
                            child: ListView.builder(
                              itemCount: _handler.registrosAgregados.length,
                              itemBuilder: (context, index) {
                                final itemIndex =
                                    _handler.registrosAgregados[index];
                                return ListTile(
                                  title: Text(
                                    'Registro ${itemIndex + 1}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  trailing: IconButton(
                                    icon:
                                        Icon(Icons.delete, color: Colors.white),
                                    onPressed: () {
                                      setState(() {
                                        _handler.eliminarRegistro(itemIndex);
                                      });
                                      Navigator.pop(context);
                                    },
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                    color: AppColors.primary.withOpacity(0.95),
                    elevation: 4,
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Icon(Icons.keyboard_arrow_down, color: Colors.white),
                ),
              ),
            ],
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
        'Pagos depositados',
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
