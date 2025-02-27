import 'package:flutter/material.dart';
import 'package:flutter_gestion_contable/core/theme/app_colors.dart';

class ClientsScreen extends StatefulWidget {
  @override
  _ClientsScreenState createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  Map<int, bool> selectedRows = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Barra de búsqueda
            Container(
              height: 30,
              margin: const EdgeInsets.only(bottom: 5),
              child: Row(
                children: [
                  const Text('Buscar:',
                      style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 10),
                  const SizedBox(
                    width: 400,
                    child: TextField(
                      style: TextStyle(fontSize: 12),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary, // Fondo del IconButton
                      borderRadius: BorderRadius.circular(10), // Bordes redondeados
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.search, color: Colors.white),
                      onPressed: () {},
                      padding: EdgeInsets.zero, // Para eliminar el padding
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary, // Fondo del IconButton
                      borderRadius: BorderRadius.circular(10), // Bordes redondeados
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.search, color: Colors.white),
                      onPressed: () {},
                      padding: EdgeInsets.zero, // Para eliminar el padding
                    ),
                  ),
                ],
              ),
            ),

            // Tabla con los datos de los clientes
            Expanded(
              child: SingleChildScrollView(
                child: DataTable(
                  columnSpacing: 12,
                  dataRowMinHeight: 40,
                  dataRowMaxHeight: 45,
                  columns: const [
                    DataColumn(label: Text('Sel.')),
                    DataColumn(label: Text('Nombre')),
                    DataColumn(label: Text('Email')),
                    DataColumn(label: Text('Nacimiento')),
                    DataColumn(label: Text('WhatsApp')),
                    DataColumn(label: Text('Montos del Mes')),
                    DataColumn(label: Text('Contacto')),
                    DataColumn(label: Text('Dirección')),
                  ],
                  rows: List.generate(
                    10,
                    (index) => DataRow(
                      selected: selectedRows[index] ?? false,
                      cells: [
                        DataCell(
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              child: Checkbox(
                                value: selectedRows[index] ?? false,
                                onChanged: (bool? value) {
                                  setState(() {
                                    selectedRows[index] = value ?? false;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        DataCell(Text('Cliente $index')),
                        DataCell(Text('cliente$index@email.com')),
                        DataCell(Text('01/01/2000')),
                        DataCell(Text('+598 98 123 456')),
                        DataCell(Text('\$3,500')),
                        DataCell(Text('+598 98 123 456')),
                        DataCell(Text('calle x')),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Botones "Eliminar" y "Modificar"
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 150,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    icon: const Icon(Icons.delete, color: Colors.white),
                    label: const Text('Eliminar', style: TextStyle(color: Colors.white)),
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    icon: const Icon(Icons.edit, color: Colors.white),
                    label: const Text('Modificar', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

