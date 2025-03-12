import 'package:flutter/material.dart';
import 'package:flutter_gestion_contable/core/theme/app_colors.dart';
import 'clients_handler.dart';

class ClientsScreen extends StatefulWidget {
  const ClientsScreen({super.key});

  @override
  _ClientsScreenState createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  final ClientsHandler _handler = ClientsHandler();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchBar(),
            Expanded(
              child: ClientsTable(
                handler: _handler,
                onRowSelected: (index, value) {
                  setState(() {
                    _handler.toggleRowSelection(index, value);
                  });
                },
                onSelectAll: (value) {
                  setState(() {
                    _handler.selectAll(value);
                  });
                },
              ),
            ),
            const SizedBox(height: 40),
            ActionButtons(),
          ],
        ),
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Campo de búsqueda
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              labelText: 'Buscar Cliente',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        // Botones a la derecha
        Row(
          children: [
            // Primer botón
            SizedBox(
              width: 40, // Tamaño cuadrado para el botón
              height: 40,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: AppColors.primary,
                ),
                child: Icon(Icons.filter_list, color: Colors.white),
              ),
            ),
            const SizedBox(width: 10), // Espacio entre los botones
            // Segundo botón
            SizedBox(
              width: 40, // Tamaño cuadrado para el botón
              height: 40,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: AppColors.primary,
                ),
                child: Icon(Icons.clear, color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class ClientsTable extends StatelessWidget {
  final ClientsHandler handler;
  final Function(int, bool) onRowSelected;
  final Function(bool) onSelectAll;

  const ClientsTable({
    required this.handler,
    required this.onRowSelected,
    required this.onSelectAll,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: DataTable(
              columnSpacing: 20.0,
              dataRowHeight: 40.0,
              headingRowHeight: 40.0,
              headingRowColor: MaterialStateProperty.all(AppColors.primary),
              columns: [
                DataColumn(
                  label: Checkbox(
                    value: handler.isAllSelected,
                    onChanged: (bool? value) {
                      onSelectAll(value ?? false);
                    },
                  ),
                ),
                const DataColumn(label: Text('Nombre')),
                const DataColumn(label: Text('Email')),
                const DataColumn(label: Text('Nacimiento')),
                const DataColumn(label: Text('WhatsApp')),
                const DataColumn(label: Text('Montos del Mes')),
                const DataColumn(label: Text('Contacto')),
                const DataColumn(label: Text('Dirección')),
              ],
              rows: List.generate(
                10,
                (index) => DataRow(
                  selected: handler.getSelectedRows()[index] ?? false,
                  cells: [
                    DataCell(
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Checkbox(
                            value: handler.getSelectedRows()[index] ?? false,
                            onChanged: (bool? value) {
                              onRowSelected(index, value ?? false);
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
      ),
    );
  }
}

class ActionButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}
