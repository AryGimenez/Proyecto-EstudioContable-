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
  String selectedFilter = 'Nombre'; // Filtro por defecto
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchBar(
              controller: _searchController,
              selectedFilter: selectedFilter,
              onSearch: _onSearch,
              onFilterChange: _onFilterChange,
            ),
            const SizedBox(height: 10),
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
            ActionButtons(
              handler: _handler,
              onDelete: () {
                setState(() {
                  _handler.deleteSelectedClients(() {
                    setState(() {}); // Actualizamos la interfaz de usuario después de eliminar
                  });
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void _onSearch() {
    setState(() {
      _handler.filterClients(_searchController.text, selectedFilter);
    });
  }

  void _onFilterChange(String? value) {
    setState(() {
      selectedFilter = value ?? 'Nombre';
    });
  }
}

class SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String selectedFilter;
  final VoidCallback onSearch;
  final Function(String?) onFilterChange;

  const SearchBar({
    required this.controller,
    required this.selectedFilter,
    required this.onSearch,
    required this.onFilterChange,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: 'Buscar por $selectedFilter',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(width: 5),
        SizedBox(
          width: 40,
          height: 40,
          child: ElevatedButton(
            onPressed: onSearch,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              backgroundColor: AppColors.primary,
              padding: EdgeInsets.zero,
            ),
            child: const Center(
              child: Icon(Icons.search, color: Colors.white),
            ),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 40,
          height: 40,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: PopupMenuButton<String>(
              onSelected: onFilterChange,
              itemBuilder: (BuildContext context) {
                return ['Nombre', 'Email', 'Nacimiento', 'WhatsApp', 'Montos del Mes', 'Contacto', 'Dirección']
                    .map((String option) {
                  return PopupMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList();
              },
              icon: const Icon(Icons.filter_alt_outlined, color: Colors.white),
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
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
    return SingleChildScrollView(
      child: SizedBox(
        width: double.infinity,
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
            const DataColumn(label: Text('Editar')),  // Columna para el ícono de editar
          ],
          rows: handler.filteredClients.isNotEmpty
              ? List.generate(
                  handler.filteredClients.length,
                  (index) {
                    final client = handler.filteredClients[index];

                    return DataRow(
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
                        DataCell(Text(client['Nombre'] ?? '')),
                        DataCell(Text(client['Email'] ?? '')),
                        DataCell(Text(client['Nacimiento'] ?? '')),
                        DataCell(Text(client['WhatsApp'] ?? '')),
                        DataCell(Text(client['Montos del Mes'] ?? '')),
                        DataCell(Text(client['Contacto'] ?? '')),
                        DataCell(Text(client['Dirección'] ?? '')),
                        DataCell(
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              // Agregar lógica para editar el cliente
                              // Aquí podrías abrir un formulario o un cuadro de diálogo
                            },
                          ),
                        ), // Icono de editar
                      ],
                    );
                  },
                )
              : [
                  const DataRow(cells: [
                    DataCell(Text('No se encontraron clientes', style: TextStyle(fontStyle: FontStyle.italic))),
                    DataCell(Text('')),
                    DataCell(Text('')),
                    DataCell(Text('')),
                    DataCell(Text('')),
                    DataCell(Text('')),
                    DataCell(Text('')),
                    DataCell(Text('')),
                    DataCell(Text('')), // Columna vacía para "Acción"
                  ]), // Mensaje de "No se encontraron clientes"
                ],
        ),
      ),
    );
  }
}


class ActionButtons extends StatelessWidget {
  final ClientsHandler handler;
  final VoidCallback onDelete;

  const ActionButtons({
    required this.handler,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 150,
          child: ElevatedButton.icon(
            onPressed: onDelete,
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
