// lib/screens/clients/clients_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_gestion_contable/core/theme/app_colors.dart';
import 'package:flutter_gestion_contable/services/api_service.dart'; // ¡Mantenemos esta importación!
import 'clients_handler.dart';
import 'package:provider/provider.dart';

class ClientsScreen extends StatefulWidget {
  const ClientsScreen({super.key});

  @override
  _ClientsScreenState createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  // Mantenemos la instancia de ApiService aquí
  final ApiService _apiService = ApiService(); 

  late Future<void> _clientsFuture;

  String selectedFilter = 'Nombre';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Accede a la instancia del handler que el provider te da.
    final handler = Provider.of<ClientsHandler>(context, listen: false);
    _clientsFuture = handler.fetchClients();
  }

  void _onSearch() {
    final handler = Provider.of<ClientsHandler>(context, listen: false);
    setState(() {
      String filterKey = _getFilterKey(selectedFilter);
      handler.filterClients(_searchController.text, filterKey);
    });
  }

  void _onFilterChange(String? value) {
    final handler = Provider.of<ClientsHandler>(context, listen: false);
    setState(() {
      selectedFilter = value ?? 'Nombre';
      _onSearch();
    });
  }

  String _getFilterKey(String filter) {
    switch (filter) {
      case 'ID': return 'Cli_ID';
      case 'Nombre': return 'Cli_Nom';
      case 'Email': return 'Cli_Email';
      case 'Nacimiento': return 'Cli_FechaNac';
      case 'WhatsApp': return 'Cli_Whatsapp';
      case 'Saldo': return 'Cli_Saldo';
      case 'Contacto': return 'Cli_Contacto';
      case 'Dirección': return 'Cli_Dir';
      default: return 'Cli_Nom';
    }
  }

  void _showEditDialog(Map<String, dynamic> client) {
    final handler = Provider.of<ClientsHandler>(context, listen: false);
    final TextEditingController nameController = TextEditingController(text: client['Cli_Nom']);
    final TextEditingController emailController = TextEditingController(text: client['Cli_Email']);
    final TextEditingController dateController = TextEditingController(text: client['Cli_FechaNac']);
    final TextEditingController whatsappController = TextEditingController(text: client['Cli_Whatsapp']);
    final TextEditingController contactController = TextEditingController(text: client['Cli_Contacto']);
    final TextEditingController addressController = TextEditingController(text: client['Cli_Dir']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Cliente'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Nombre')),
                TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
                TextField(controller: dateController, decoration: const InputDecoration(labelText: 'Nacimiento' )),
                TextField(controller: whatsappController, decoration: const InputDecoration(labelText: 'WhatsApp')),
                TextField(controller: contactController, decoration: const InputDecoration(labelText: 'Contacto')),
                TextField(controller: addressController, decoration: const InputDecoration(labelText: 'Dirección')),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                final updatedData = {
                  "Cli_Nom": nameController.text,
                  "Cli_Email": emailController.text,
                  "Cli_FechaNac": dateController.text,
                  "Cli_Whatsapp": whatsappController.text,
                  "Cli_Contacto": contactController.text,
                  "Cli_Dir": addressController.text,
                };
                
                try {
                  await handler.updateClient(client['Cli_ID'].toString(), updatedData);
                  Navigator.of(context).pop();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${e.toString()}')),
                  );
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

    // 👇 Esta es la función para el diálogo de confirmación de eliminación
  void _showDeleteConfirmationDialog() {
    final handler = Provider.of<ClientsHandler>(context, listen: false);
    final int count = handler.selectedClientsCount;

    if (count == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecciona al menos un cliente para eliminar.')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: Text(
              '¿Estás seguro de que deseas eliminar $count cliente(s) seleccionado(s)? Esta acción no se puede deshacer.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Cierra el diálogo antes de eliminar
                try {
                  debugPrint('ClientsScreen: Iniciando eliminación a través del handler.');
                  await handler.deleteSelectedClients(); // Llama al handler para eliminar
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cliente(s) eliminado(s) correctamente.')),
                  );
                } catch (e) {
                  debugPrint('ClientsScreen: Error capturado al eliminar: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al eliminar: ${e.toString()}')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Color de botón de peligro
              ),
              child: const Text('Eliminar', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final handler = Provider.of<ClientsHandler>(context);

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
              child: FutureBuilder<void>(
                future: _clientsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    return ClientsTable(
                      handler: handler,
                      onRowSelected: (clientId, value) {
                        handler.toggleRowSelection(clientId, value);
                      },
                      onSelectAll: (value) {
                        handler.selectAll(value);
                      },
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 40),
            Consumer<ClientsHandler>(
              builder: (context, handler, child) {
                final bool isModifyButtonEnabled = handler.selectedClientsCount == 1;
                return ActionButtons(
                  onDelete: _showDeleteConfirmationDialog,
                  onModify: () {
                    if (isModifyButtonEnabled) {
                      _showEditDialog(handler.selectedClient!);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Por favor, selecciona un solo cliente para modificar.')),
                      );
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Clases SearchBar, ClientsTable y ActionButtons
// ... (mismas que en las respuestas anteriores)
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
                return [
                  'ID',
                  'Nombre',
                  'Email',
                  'Nacimiento',
                  'WhatsApp',
                  'Saldo',
                  'Contacto',
                  'Dirección'
                ].map((String option) {
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
  final Function(String, bool) onRowSelected;
  final Function(bool) onSelectAll;

  const ClientsTable({
    required this.handler,
    required this.onRowSelected,
    required this.onSelectAll,
  });

  double _calculateColumnWidth(List<Map<String, dynamic>> clients, String columnKey, TextStyle style) {
    double maxWidth = 0;
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: columnKey, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();
    maxWidth = textPainter.width;

    for (var client in clients) {
      final String text = client[columnKey]?.toString() ?? '';
      final TextPainter dataPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: 1,
        textDirection: TextDirection.ltr,
      )..layout();
      if (dataPainter.width > maxWidth) {
        maxWidth = dataPainter.width;
      }
    }
    return maxWidth + 30;
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle headerStyle = TextStyle(color: Colors.white, fontWeight: FontWeight.bold);
    const TextStyle cellStyle = TextStyle(color: Colors.black);

    final List<Map<String, dynamic>> clientsData = handler.filteredClients;

    final double idColumnWidth = _calculateColumnWidth(clientsData, 'Cli_ID', cellStyle);
    final double nombreColumnWidth = _calculateColumnWidth(clientsData, 'Cli_Nom', cellStyle);
    final double emailColumnWidth = _calculateColumnWidth(clientsData, 'Cli_Email', cellStyle);
    final double nacimientoColumnWidth = _calculateColumnWidth(clientsData, 'Cli_FechaNac', cellStyle);
    final double whatsappColumnWidth = _calculateColumnWidth(clientsData, 'Cli_Whatsapp', cellStyle);
    final double saldoColumnWidth = _calculateColumnWidth(clientsData, 'Cli_Saldo', cellStyle);
    final double contactoColumnWidth = _calculateColumnWidth(clientsData, 'Cli_Contacto', cellStyle);
    final double direccionColumnWidth = _calculateColumnWidth(clientsData, 'Cli_Dir', cellStyle);
    
    const double checkboxHeaderColumnWidth = 50; 
    const double editIconColumnWidth = 60; 

    final double minTableWidth = checkboxHeaderColumnWidth + 
        idColumnWidth +
        nombreColumnWidth +
        emailColumnWidth +
        nacimientoColumnWidth +
        whatsappColumnWidth +
        saldoColumnWidth +
        contactoColumnWidth +
        direccionColumnWidth +
        editIconColumnWidth;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double tableWidth = constraints.maxWidth > minTableWidth
            ? constraints.maxWidth
            : minTableWidth;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: tableWidth),
            child: DataTable(
              columnSpacing: 10.0,
              dataRowHeight: 40.0,
              headingRowHeight: 40.0,
              headingRowColor: MaterialStateProperty.all(AppColors.primary),
              showCheckboxColumn: true,
              columns: [
                const DataColumn(label: SizedBox.shrink()),
                DataColumn(label: SizedBox(width: idColumnWidth, child: const Text('ID', style: headerStyle))),
                DataColumn(label: SizedBox(width: nombreColumnWidth, child: const Text('Nombre', style: headerStyle))),
                DataColumn(label: SizedBox(width: emailColumnWidth, child: const Text('Email', style: headerStyle))),
                DataColumn(label: SizedBox(width: nacimientoColumnWidth, child: const Text('Nacimiento', style: headerStyle))),
                DataColumn(label: SizedBox(width: whatsappColumnWidth, child: const Text('WhatsApp', style: headerStyle))),
                DataColumn(label: SizedBox(width: saldoColumnWidth, child: const Text('Saldo', style: headerStyle))),
                DataColumn(label: SizedBox(width: contactoColumnWidth, child: const Text('Contacto', style: headerStyle))),
                DataColumn(label: SizedBox(width: direccionColumnWidth, child: const Text('Dirección', style: headerStyle))),
                const DataColumn(label: SizedBox.shrink()), 
              ],
              rows: handler.filteredClients.isNotEmpty
                  ? List.generate(
                      handler.filteredClients.length,
                      (index) {
                        final client = handler.filteredClients[index];
                        final clientId = client['Cli_ID'].toString();
                        final isSelected = handler.isRowSelected(clientId);

                        return DataRow(
                          selected: isSelected,
                          onSelectChanged: (value) {
                            onRowSelected(clientId, value ?? false);
                          },
                          cells: [
                            DataCell(const SizedBox(width: checkboxHeaderColumnWidth - 10)), 
                            DataCell(SizedBox(width: idColumnWidth, child: Text(client['Cli_ID']?.toString() ?? '', style: cellStyle))),
                            DataCell(SizedBox(width: nombreColumnWidth, child: Text(client['Cli_Nom'] ?? '', style: cellStyle))),
                            DataCell(SizedBox(width: emailColumnWidth, child: Text(client['Cli_Email'] ?? '', style: cellStyle))),
                            DataCell(SizedBox(width: nacimientoColumnWidth, child: Text(client['Cli_FechaNac']?.toString().split(' ')[0] ?? '', style: cellStyle))),
                            DataCell(SizedBox(width: whatsappColumnWidth, child: Text(client['Cli_Whatsapp'] ?? '', style: cellStyle))),
                            DataCell(SizedBox(width: saldoColumnWidth, child: Text('\$${client['Cli_Saldo']?.toStringAsFixed(2) ?? '0.00'}', style: cellStyle))),
                            DataCell(SizedBox(width: contactoColumnWidth, child: Text(client['Cli_Contacto'] ?? '', style: cellStyle))),
                            DataCell(SizedBox(width: direccionColumnWidth, child: Text(client['Cli_Dir'] ?? '', style: cellStyle))),
                            const DataCell(SizedBox.shrink()),
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
                        DataCell(Text('')),
                        DataCell(Text('')),
                      ]),
                    ],
            ),
          ),
        );
      },
    );
  }
}

class ActionButtons extends StatelessWidget {
  final VoidCallback onDelete;
  final VoidCallback onModify;

  const ActionButtons({
    super.key,
    required this.onDelete,
    required this.onModify,
  });

  @override
  Widget build(BuildContext context) {
    final handler = Provider.of<ClientsHandler>(context);

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
            onPressed: handler.selectedClientsCount == 1 ? onModify : null,
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