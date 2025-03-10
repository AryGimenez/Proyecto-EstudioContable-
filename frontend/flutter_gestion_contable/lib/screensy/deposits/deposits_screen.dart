import 'package:flutter/material.dart';
import 'package:flutter_gestion_contable/core/theme/app_colors.dart';
import 'deposits_handler.dart'; // Importamos la clase DepositsHandler

class DepositsScreen extends StatefulWidget {
  const DepositsScreen({super.key});

  @override
  _DepositsScreenState createState() => _DepositsScreenState();
}

class _DepositsScreenState extends State<DepositsScreen> {
  final DepositsHandler _handler = DepositsHandler();

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
                      Checkbox(
                        value: _handler.isClientsChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            _handler.isClientsChecked = value ?? false;
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
            _buildImpuestosPagarLine(),
            SizedBox(height: 5),
            _buildDataTable(),
          ],
        ),
      ),
    );
  }

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

  Widget _buildDataTable() {
    return Expanded(
      child: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical, // Permitir scroll vertical
            child: DataTable(
              columnSpacing: 20.0,
              dataRowHeight: 24.0,
              headingRowHeight: 24.0,
              headingRowColor: MaterialStateProperty.all(AppColors.primary),
              columns: [
                DataColumn(
                  label: Row(
                    children: [
                      Checkbox(
                        value:
                            _handler.selectedRows.every((selected) => selected),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value ?? false) {
                              _handler.selectAllRows();
                            } else {
                              _handler.deselectAllRows();
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
                // Puedes tener más de 5 filas
                return DataRow(
                  cells: [
                    DataCell(
                      Checkbox(
                        value: _handler.selectedRows[index],
                        onChanged: (bool? value) {
                          setState(() {
                            _handler.toggleRowSelection(index, value);
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
          ),
        ),
      ),
    );
  }
}
