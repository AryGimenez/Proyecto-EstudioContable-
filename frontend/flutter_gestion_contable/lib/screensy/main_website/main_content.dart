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
            color: AppColors
                .primary, // Color de fondo de la barra superior (debe estar definido en AppColors)
            padding: const EdgeInsets.symmetric(
                horizontal: 20), // Espaciado horizontal
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
                    // Icono de notificación
                    IconButton(
                      icon:
                          const Icon(Icons.notifications, color: Colors.white),
                      onPressed: () {}, // Acción del botón de notificación
                    ),
                    // Icono de menú
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
                      const Text(
                        'Lorena Gimenez', // Nombre del usuario
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      const SizedBox(height: 20),
                      // Botones del menú lateral que permiten la navegación
                      _buildMenuButton(
                          'Clientes', Icons.people), // Botón "Clientes"
                      _buildMenuButton('Agregar Cliente',
                          Icons.person_add), // Botón "Agregar Cliente"
                      _buildMenuButton('Pagos', Icons.payment), // Botón "Pagos"
                      _buildMenuButton('Depósito',
                          Icons.account_balance), // Botón "Depósito"
                      const Spacer(), // Espacio vacío para alinear el botón "Salir" en la parte inferior
                      // Botón "Salir" con color especial
                      _buildMenuButton('Salir', Icons.exit_to_app,
                          isExit: true),
                    ],
                  ),
                ),

                // Sección principal con la tabla de clientes
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(
                        20), // Espaciado alrededor de la sección
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Barra de búsqueda que permite filtrar los resultados
                        Container(
                          height: 30,
                          margin: const EdgeInsets.only(
                              bottom:
                                  5), // Reducido el espacio extra debajo de la barra de búsqueda
                          child: Row(
                            children: [
                              const Text(
                                'Buscar:',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight:
                                        FontWeight.bold), // Etiqueta "Buscar"
                              ),
                              const SizedBox(
                                  width:
                                      10), // Espaciado entre la etiqueta y el campo de texto
                              Expanded(
                                child: TextField(
                                  style: const TextStyle(
                                      fontSize:
                                          12), // Estilo del texto en el campo
                                  decoration: const InputDecoration(
                                    border:
                                        OutlineInputBorder(), // Borde del campo de texto
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                  width:
                                      10), // Espaciado entre el campo de texto y el icono de búsqueda
                              // Botón de búsqueda
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors
                                      .primary, // Color de fondo del botón
                                  borderRadius: BorderRadius.circular(
                                      5), // Bordes redondeados
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.search, size: 18),
                                  onPressed:
                                      () {}, // Acción del botón de búsqueda
                                  color: Colors.white,
                                  padding:
                                      EdgeInsets.zero, // Sin padding adicional
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Tabla con los datos de los clientes
                        Expanded(
                          child: SingleChildScrollView(
                            child: DataTable(
                              columnSpacing: 12, // Espaciado entre las columnas
                              dataRowMinHeight:
                                  40, // Altura mínima de las filas
                              dataRowMaxHeight:
                                  45, // Altura máxima de las filas
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
                                                selectedRows[index] = value ??
                                                    false; // Actualizar estado de selección
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

                        const SizedBox(
                            height:
                                40), // Espacio adicional antes de los botones

                        // Botones "Eliminar" y "Modificar"
                        Row(
                          mainAxisAlignment: MainAxisAlignment
                              .spaceBetween, // Distribución entre los botones
                          children: [
                            // Botón "Eliminar" con un ancho fijo
                            SizedBox(
                              width: 150,
                              child: ElevatedButton.icon(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors
                                      .primary, // Color de fondo del botón
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                ),
                                icon: const Icon(Icons.delete,
                                    color: Colors.white), // Icono del botón
                                label: const Text('Eliminar',
                                    style: TextStyle(
                                        color: Colors
                                            .white)), // Etiqueta del botón
                              ),
                            ),
                            // Botón "Modificar" con un ancho fijo y alineado a la derecha
                            SizedBox(
                              width: 150,
                              child: ElevatedButton.icon(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors
                                      .primary, // Color de fondo del botón
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
        width: 200, // Ancho fijo para los botones del menú
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: isExit
                ? Color(0xFF792D1F)
                : Colors.amber[200], // Color diferente para el botón "Salir"
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)), // Bordes redondeados
          ),
          onPressed: () {},
          icon: Icon(icon,
              color: isExit
                  ? Colors.white
                  : AppColors.primary), // Color del icono según si es "Salir"
          label: Text(
            title,
            style: TextStyle(
                color: isExit
                    ? Colors.white
                    : AppColors.primary), // Color del texto
          ),
        ),
      ),
    );
  }
}
