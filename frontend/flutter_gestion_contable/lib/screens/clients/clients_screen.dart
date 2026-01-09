// frontend/flutter_gestion_contable/lib/screens/clients/clients_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_gestion_contable/core/theme/app_colors.dart';
import 'clients_handler.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gestion_contable/models/cliente_modle.dart'; // Import model
import 'package:flutter_gestion_contable/screens/clients/clients_table.dart';

/// Clase principal del widget para la pantalla de gestión de clientes.
///
/// Este widget con estado (StatefulWidget) es responsable de la composición
/// general de la interfaz de la vista de clientes, incluyendo:
/// 1. La barra de búsqueda y filtros ([SearchBar]).
/// 2. La tabla de datos de clientes ([ClientsTable]).
/// 3. Los botones de acción (Agregar, Modificar, Eliminar) ([ActionButtons]).
///
/// `ClientsScreen` accede a [ClientsHandler] a través de [Provider] para:
/// - Iniciar la carga de datos ([fetchClients]) en el [initState].
/// - Acceder al estado de la lista de clientes.
/// - Llamar a métodos de acción (filtrar, agregar, editar, eliminar) a través de sus callbacks.
///
/// La gestión del estado de la tabla (selección de filas, datos filtrados) es
/// delegada completamente al [ClientsHandler], lo que mantiene esta clase
/// enfocada en la presentación y la interacción del usuario (UI).
class ClientsScreen extends StatefulWidget {
  const ClientsScreen({super.key});

  @override
  _ClientsScreenState createState() => _ClientsScreenState();
}

//  /// Método para construir el widget.
//  /// * Muestra la barra de búsqueda y filtros, la tabla de clientes y los botones de acción.
class _ClientsScreenState extends State<ClientsScreen> {
  // Mantenemos la instancia de ApiService aquí

  late Future<void> _clientsFuture; // Futuro para la carga inicial de clientes.

  String selectedFilter = 'Nombre'; // Filtro seleccionado para la búsqueda.
  final TextEditingController _searchController =
      TextEditingController(); // Controlador para el campo de búsqueda.

  /// Método para inicializar el estado del widget.
  /// * Inicializa el futuro para la carga inicial de clientes.
  /// * Accede a la instancia del handler que el provider te da.
  /// * Llama al método [fetchClients] para cargar los datos de clientes.
  @override
  void initState() {
    super.initState(); // Inicializa el estado del widget.
    final handler = Provider.of<ClientsHandler>(context,
        listen:
            false); // Accede a la instancia del handler que el provider te da.
    // <!> Borrar
    _clientsFuture = handler
        .fetchClients(); // Llama al método [fetchClients] para cargar los datos de clientes.
  }

  /// Método para manejar la búsqueda de clientes.
  /// * Accede a la instancia del handler que el provider te da.
  /// * Llama al método [filterClients] para filtrar los clientes.
  void _onSearch() {
    final handler = Provider.of<ClientsHandler>(context,
        listen:
            false); // Accede a la instancia del handler que el provider te da.
    setState(() {
      String filterKey = _getFilterKey(
          selectedFilter); // Obtiene la llave del filtro seleccionado.
      handler.filterClients(_searchController.text,
          filterKey); // Llama al método [filterClients] para filtrar los clientes.
    });
  }

  /// Método para manejar el cambio de filtro.
  /// * Accede a la instancia del handler que el provider te da.
  /// * Llama al método [filterClients] para filtrar los clientes.
  void _onFilterChange(String? value) {
    // <!> Esto creo qeu no ace nada solo actualiza el estado Revisar
    final handler = Provider.of<ClientsHandler>(context,
        listen:
            false); // Accede a la instancia del handler que el provider te da.
    setState(() {
      // Actualiza el estado del widget.
      selectedFilter = value ?? 'Nombre'; // Actualiza el filtro seleccionado.
      _onSearch(); // Llama al método [_onSearch] para filtrar los clientes.
    });
  }

  //<!> Borrar
  /// Método para obtener la llave del filtro seleccionado.
  /// * Recibe el filtro seleccionado.
  /// * Devuelve la llave del filtro.
  // <!> Esto lo quiero cambiar para que mande un objeto tipo filtro o algo por el estilo
  // y no tener que haer referencia a las columnas inventar algo

  String _getFilterKey(String filter) {
    switch (filter) {
      case 'ID':
        return 'id'; // Llave para el filtro por ID.
      case 'Nombre':
        return 'nombre'; // Llave para el filtro por nombre.
      case 'Email':
        return 'email'; // Llave para el filtro por email.
      case 'Nacimiento':
        return 'fechaNac'; // Llave para el filtro por nacimiento.
      case 'WhatsApp':
        return 'whatsapp'; // Llave para el filtro por WhatsApp.
      case 'Saldo':
        return 'saldo'; // Llave para el filtro por saldo.
      case 'Contacto':
        return 'contacto'; // Llave para el filtro por contacto.
      case 'Dirección':
        return 'direccion'; // Llave para el filtro por dirección.
      default:
        return 'nombre'; // Llave por defecto para el filtro por nombre.
    }
  }

  /// Método para mostrar el diálogo de edición de cliente.
  /// * Recibe los datos del cliente a editar.
  /// * Muestra un formulario con los datos del cliente.
  /// * Permite editar los datos del cliente.
  /// * Llama al método [updateClient] para actualizar los datos del cliente.
  // <!> Me gustaria saber si aca manda un formulario nuevo o que hace
  void _showEditDialog(ClienteModel client) {
    final handler = Provider.of<ClientsHandler>(context, listen: false);
    final TextEditingController nameController =
        TextEditingController(text: client.nombre);
    final TextEditingController emailController =
        TextEditingController(text: client.email ?? '');
    final TextEditingController dateController =
        TextEditingController(text: client.fechaNacimiento.toString());
    final TextEditingController whatsappController =
        TextEditingController(text: client.whatsapp);
    final TextEditingController contactController =
        TextEditingController(text: client.datoContacto ?? '');
    final TextEditingController addressController =
        TextEditingController(text: client.direccion ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Cliente'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              // Nombre de la columna de la tabla
              children: [
                TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Nombre')),
                TextField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email')),
                TextField(
                    controller: dateController,
                    decoration: const InputDecoration(labelText: 'Nacimiento')),
                TextField(
                    controller: whatsappController,
                    decoration: const InputDecoration(labelText: 'WhatsApp')),
                TextField(
                    controller: contactController,
                    decoration: const InputDecoration(labelText: 'Contacto')),
                TextField(
                    controller: addressController,
                    decoration: const InputDecoration(labelText: 'Dirección')),
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
                  "Cli_FechNas": dateController.text,
                  "Cli_Whatsapp": whatsappController.text,
                  "Cli_DatoContacto": contactController.text,
                  "Cli_Dir": addressController.text,
                };

                try {
                  await handler.updateClient(client.id.toString(), updatedData);
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
        const SnackBar(
            content: Text(
                'Por favor, selecciona al menos un cliente para eliminar.')),
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
                Navigator.of(context)
                    .pop(); // Cierra el diálogo antes de eliminar
                try {
                  debugPrint(
                      'ClientsScreen: Iniciando eliminación a través del handler.');
                  await handler
                      .deleteSelectedClients(); // Llama al handler para eliminar
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text('Cliente(s) eliminado(s) correctamente.')),
                  );
                } catch (e) {
                  debugPrint('ClientsScreen: Error capturado al eliminar: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Error al eliminar: ${e.toString()}')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Color de botón de peligro
              ),
              child:
                  const Text('Eliminar', style: TextStyle(color: Colors.white)),
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
                final bool isModifyButtonEnabled =
                    handler.selectedClientsCount == 1;
                return ActionButtons(
                  onDelete: _showDeleteConfirmationDialog,
                  onModify: () {
                    if (isModifyButtonEnabled) {
                      _showEditDialog(handler.selectedClient!);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'Por favor, selecciona un solo cliente para modificar.')),
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
    super.key,
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

///
///

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
            label:
                const Text('Eliminar', style: TextStyle(color: Colors.white)),
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
            label:
                const Text('Modificar', style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }
}
