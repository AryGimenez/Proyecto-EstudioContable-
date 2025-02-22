import 'package:flutter/material.dart';
import 'main_handler.dart'; // Importa la pantalla principal donde se manejan los datos
import 'main_styles.dart'; // Importa los estilos personalizados

class ClientsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold( // Scaffold es el contenedor principal de la pantalla
      body: Column( // Coloca los elementos verticalmente
        children: [
          // Barra superior
          Container(
            height: 60, // Altura de la barra
            color: AppColors.primary, // Color de fondo de la barra
            padding: const EdgeInsets.symmetric(horizontal: 20), // Padding horizontal
            child: Row( // Distribuye los elementos de manera horizontal
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Espacio entre los elementos
              children: [
                const Text(
                  'Clientes', // Título de la barra
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    // Icono de notificación
                    IconButton(
                      icon: const Icon(Icons.notifications, color: Colors.white),
                      onPressed: () {}, // Acción al presionar (vacío por ahora)
                    ),
                    // Icono de menú
                    IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white),
                      onPressed: () {}, // Acción al presionar (vacío por ahora)
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded( // Expande el siguiente contenido para que ocupe todo el espacio disponible
            child: Row( // Contenido en una fila (barra lateral + contenido principal)
              children: [
                // Barra lateral
                Container(
                  width: 250, // Ancho de la barra lateral
                  color: AppColors.primary, // Color de fondo de la barra lateral
                  child: Column( // Elementos de la barra lateral en columna
                    children: [
                      const SizedBox(height: 20), // Espacio vacío al inicio
                      const CircleAvatar(
                        radius: 40, // Tamaño de la imagen de perfil
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, size: 40, color: Colors.brown), // Icono de persona
                      ),
                      const SizedBox(height: 10), // Espacio vacío
                      const Text(
                        'Lorena Gimenez', // Nombre del usuario
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      const SizedBox(height: 20), // Espacio vacío
                      // Botones del menú lateral
                      _buildMenuButton('Clientes', Icons.people),
                      _buildMenuButton('Agregar Cliente', Icons.person_add),
                      _buildMenuButton('Pagos', Icons.payment),
                      _buildMenuButton('Depósito', Icons.account_balance),
                      const Spacer(), // Espacio vacío para empujar el botón 'Salir' hacia abajo
                      _buildMenuButton('Salir', Icons.exit_to_app, isExit: true), // Botón de salida
                    ],
                  ),
                ),

                // Contenido principal
                Expanded(
                  child: Container(
                    color: Colors.white, // Fondo blanco para el contenido principal
                    padding: const EdgeInsets.all(20), // Padding alrededor del contenido
                    child: Column( // Elementos del contenido principal en columna
                      children: [
                        // Barra de búsqueda y filtros
                        Row(
                          children: [
                            const Text(
                              'Buscar:',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 10), // Espacio vacío
                            Expanded(
                              child: TextField( // Campo de texto para búsqueda
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(), // Borde alrededor del campo
                                ),
                              ),
                            ),
                            const SizedBox(width: 10), // Espacio vacío
                            // Botón de búsqueda con fondo
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.primary, // Fondo del botón
                                borderRadius: BorderRadius.circular(10), // Bordes redondeados
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.search), // Icono de búsqueda
                                onPressed: () {}, // Acción al presionar (vacío por ahora)
                                color: Colors.white, // Color del ícono
                              ),
                            ),
                            // Otro botón de búsqueda (parecido al anterior)
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.primary, // Fondo del botón
                                borderRadius: BorderRadius.circular(10), // Bordes redondeados
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.search), // Icono de búsqueda
                                onPressed: () {}, // Acción al presionar (vacío por ahora)
                                color: Colors.white, // Color del ícono
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 10), // Espacio vacío

                        // Tabla de clientes
                        Expanded(
                          child: SingleChildScrollView( // Permite hacer scroll en la tabla
                            child: DataTable( // Tabla de datos
                              columns: const [
                                DataColumn(label: Text('Nombre Apellido')), // Columna de nombre
                                DataColumn(label: Text('Email')), // Columna de email
                                DataColumn(label: Text('Nacimiento')), // Columna de nacimiento
                                DataColumn(label: Text('WhatsApp')), // Columna de WhatsApp
                                DataColumn(label: Text('Monto del Mes')), // Columna de monto mensual
                              ],
                              rows: List.generate( // Genera las filas de la tabla
                                10, // 10 filas de ejemplo
                                (index) => DataRow(cells: [
                                  DataCell(Text('Cliente \$index')), // Nombre del cliente
                                  DataCell(Text('cliente\$index@email.com')), // Email del cliente
                                  DataCell(Text('01/01/2000')), // Fecha de nacimiento
                                  DataCell(Text('+598 98 123 456')), // WhatsApp del cliente
                                  DataCell(Text('\$3,500')), // Monto mensual
                                ]),
                              ),
                            ),
                          ),
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

  // Método para construir los botones del menú lateral
  Widget _buildMenuButton(String title, IconData icon, {bool isExit = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8), // Espacio vertical entre los botones
      child: ElevatedButton.icon( // Botón con ícono
        style: ElevatedButton.styleFrom(
          backgroundColor: isExit ? Colors.red : Colors.amber[200], // Color de fondo
          foregroundColor: Colors.black, // Color del texto
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Padding del botón
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), // Bordes redondeados
        ),
        onPressed: () {}, // Acción al presionar (vacío por ahora)
        icon: Icon(icon), // Icono del botón
        label: Text(title), // Texto del botón
      ),
    );
  }
}