import 'package:flutter/material.dart';
import 'package:flutter_gestion_contable/core/theme/app_colors.dart';
import 'payments_handler.dart';  // Importamos la clase PaymentsHandler

class PaymentsScreen extends StatefulWidget {
  const PaymentsScreen({super.key});

  @override
  _PaymentsScreenState createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  final PaymentsHandler _handler = PaymentsHandler();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Filtrar por',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
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
                          Spacer(),
                          Checkbox(
                            value: _handler.isFullNameChecked,
                            onChanged: (bool? value) {
                              setState(() {
                                _handler.isFullNameChecked = value ?? false;
                              });
                            },
                          ),
                          Text('Nombre completo'),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Checkbox(
                            value: _handler.isDateChecked,
                            onChanged: (bool? value) {
                              setState(() {
                                _handler.isDateChecked = value ?? false;
                              });
                            },
                          ),
                          Text('Desde:'),
                          if (_handler.selectedDate != null)
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                "${_handler.selectedDate!.day}/${_handler.selectedDate!.month}/${_handler.selectedDate!.year}",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                            ),
                          SizedBox(width: 5),
                          IconButton(
                            icon: Icon(Icons.calendar_today),
                            onPressed: () => _handler.selectDate(context),
                          ),
                        ],
                      ),
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
                      padding: WidgetStateProperty.all(EdgeInsets.zero),
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
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(5),
              color: AppColors.primary,
              child: Text(
                'Impuestos',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(8.0),
                ),
                child: DataTable(
                  headingRowColor: MaterialStateProperty.all(AppColors.primary),
                  columns: [
                    DataColumn(
                      label: Row(
                        children: [
                          Checkbox(
                            value: _handler.isSelectAll,
                            onChanged: (bool? value) {
                              setState(() {
                                _handler.toggleSelectAll(value ?? false);
                              });
                            },
                          ),
                          Text('Seleccionar todo'),
                        ],
                      ),
                    ),
                    DataColumn(label: Text('Nombre')),
                    DataColumn(label: Text('Cliente')),
                    DataColumn(label: Text('Vencimiento')),
                    DataColumn(label: Text('Monto')),
                    DataColumn(label: Text('Honorario')),
                  ],
                  rows: List.generate(3, (index) {
                    return DataRow(
                      cells: [
                        DataCell(
                          Checkbox(
                            value: _handler.selectedRows[index],
                            onChanged: (bool? value) {
                              setState(() {
                                _handler.toggleSelection(index, value ?? false);
                              });
                            },
                          ),
                        ),
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
          ],
        ),
      ),
    );
  }
}
