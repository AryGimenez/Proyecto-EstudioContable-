import 'package:flutter/material.dart';
import 'main_handler.dart';
import 'main_styles.dart';

class ClientsScreen extends StatefulWidget {
  @override
  _ClientsScreenState createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  Map<int, bool> selectedRows =
      {}; // Mapa para almacenar las filas seleccionadas en la tabla

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Barra superior que contiene el título y los iconos de notificación y menú
          Container(
            height: 60, // Altura de la barra superior
            color: AppColors.primary, // Color de fondo de la barra superior
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment
                  .spaceBetween, // Distribuye los elementos de manera espaciosa
              children: [
                const Text(
                  'Clientes', // Título de la barra superior
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                // Contenedor que contiene los iconos de notificación y menú
                Row(
                  children: [
                    // Botón de notificación reemplazado por ElevatedButton.icon
                    ElevatedButton.icon(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Color(0xFF792D1F), // Color personalizado #792D1F
                        padding: EdgeInsets.zero, // Elimina el padding extra
                        minimumSize: const Size(120,
                            40), // Ancho mayor que alto para fondo rectangular
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(8), // Bordes redondeados
                        ),
                      ),
                      icon: const Icon(Icons.notifications,
                          color: Colors.white), // Icono del botón
                      label: const SizedBox.shrink(), // Oculta el texto
                    ),
                    const SizedBox(width: 10), // Espacio entre los botones
                    // Icono de menú (se mantiene igual)
                    IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white),
                      onPressed: () {}, // Acción del botón de menú
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Contenedor expandido que contiene la barra lateral y la sección principal con la tabla
          Expanded(
            child: Row(
              children: [
                // Barra lateral con el menú de navegación
                Container(
                  width: 250, // Ancho de la barra lateral
                  color:
                      AppColors.primary, // Color de fondo de la barra lateral
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      const CircleAvatar(
                        radius: 40, // Tamaño de la foto de perfil
                        backgroundColor: Colors.white,
                        child:
                            Icon(Icons.person, size: 40, color: Colors.brown),
                      ),
                      const SizedBox(height: 10),
                      const Text('Lorena Gimenez',
                          style: TextStyle(color: Colors.white, fontSize: 18)),
                      const SizedBox(height: 20),
                      _buildMenuButton('Clientes', Icons.people),
                      _buildMenuButton('Agregar Cliente', Icons.person_add),
                      _buildMenuButton('Pagos', Icons.payment),
                      _buildMenuButton('Depósito', Icons.account_balance),
                      const Spacer(),
                      _buildMenuButton('Salir', Icons.exit_to_app,
                          isExit: true),
                    ],
                  ),
                ),

                // Sección principal con la tabla de clientes
                Expanded(
                  child: Padding(
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
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(width: 10),
                              const SizedBox(
                                width: 400,
                                child: TextField(
                                  style: TextStyle(fontSize: 12),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.primary, // Fondo del IconButton
                                  borderRadius: BorderRadius.circular(
                                      10), // Bordes redondeados
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.search,
                                      color: Colors
                                          .white), // Icono dentro del botón
                                  onPressed: () {},
                                  padding: EdgeInsets
                                      .zero, // Para eliminar el padding
                                ),
                              ),
                              SizedBox(width: 10),
                              Container(
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.primary, // Fondo del IconButton
                                  borderRadius: BorderRadius.circular(
                                      10), // Bordes redondeados
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.search,
                                      color: Colors
                                          .white), // Icono dentro del botón
                                  onPressed: () {},
                                  padding: EdgeInsets
                                      .zero, // Para eliminar el padding
                                ),
                              )
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
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: Checkbox(
                                            value: selectedRows[index] ?? false,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                selectedRows[index] =
                                                    value ?? false;
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                ),
                                icon: const Icon(Icons.delete,
                                    color: Colors.white),
                                label: const Text('Eliminar',
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ),
                            SizedBox(
                              width: 150,
                              child: ElevatedButton.icon(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                ),
                                icon:
                                    const Icon(Icons.edit, color: Colors.white),
                                label: const Text('Modificar',
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Método que construye los botones del menú lateral con iconos y texto
  Widget _buildMenuButton(String title, IconData icon, {bool isExit = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        width: 200,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                isExit ? const Color(0xFF792D1F) : Colors.amber[200],
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: () {},
          icon: Icon(icon, color: isExit ? Colors.white : AppColors.primary),
          label: Text(title,
              style:
                  TextStyle(color: isExit ? Colors.white : AppColors.primary)),
        ),
      ),
    );
  }
}
