import 'package:flutter/material.dart';
import 'main_styles.dart';  // Importa los estilos personalizados
import '../clients/clients_screen.dart';  // Pantalla de clientes
import '../add_clients/add_clients.dart';  // Pantalla de agregar cliente
import '../payments/payments_screen.dart';  // Pantalla de pagos
import '../deposits/deposits_screen.dart';

class MainHandler extends StatefulWidget {
  const MainHandler({super.key});

  @override
  _MainHandlerState createState() => _MainHandlerState();
}

class _MainHandlerState extends State<MainHandler> {
  // Variable para almacenar el widget que se mostrará en el área principal
  Widget _currentChild = Center(child: Text('Bienvenido a la aplicación')); // Widget por defecto

  // Variable para almacenar el título de la pantalla actual
  String _currentTitle = 'Bienvenido';

  // Método para cambiar el contenido dinámicamente y actualizar el título
  void _changeContent(Widget newContent, String title) {
    setState(() {
      _currentChild = newContent;  // Cambia el contenido
      _currentTitle = title;  // Cambia el título
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Barra superior que contiene el título y botones de notificación y menú
          Container(
            height: 60,
            color: AppColors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Título dinámico que cambia según la pantalla seleccionada
                Text(
                  _currentTitle,  // Muestra el título actualizado
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    // Botón de notificaciones
                    ElevatedButton.icon(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF792D1F),
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(120, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: const Icon(Icons.notifications, color: Colors.white),
                      label: const SizedBox.shrink(),
                    ),
                    const SizedBox(width: 10),
                    // Botón de menú
                    IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Contenedor principal con barra lateral y contenido dinámico
          Expanded(
            child: Row(
              children: [
                // Barra lateral con menú de navegación
                Container(
                  width: 250,
                  color: AppColors.primary,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      const CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, size: 40, color: Colors.brown),
                      ),
                      const SizedBox(height: 10),
                      const Text('Lorena Giménez',
                          style: TextStyle(color: Colors.white, fontSize: 18)),
                      const SizedBox(height: 20),
                      // Botones de menú que cambian el contenido y el título
                      _buildMenuButton('Clientes', Icons.people, onPressed: () {
                        _changeContent(ClientsScreen(), 'Clientes'); // Cambiar al widget de Clientes y actualizar título
                      }),
                      _buildMenuButton('Agregar Cliente', Icons.person_add, onPressed: () {
                        _changeContent(AgregarClientesContent(), 'Agregar Cliente'); // Cambiar al widget de Agregar Cliente
                      }),
                      _buildMenuButton('Pagos', Icons.payment, onPressed: () {
                        _changeContent(PaymentsScreen(), 'Pagos'); // Cambiar al widget de Pagos y actualizar título
                      }),
                      _buildMenuButton('Depósito', Icons.account_balance, onPressed: () {
                        _changeContent(DepositsScreen(), 'Depósito'); // Cambiar al widget de Depósito
                      }),
                      const Spacer(),
                      // Botón de salir
                      _buildMenuButton('Salir', Icons.exit_to_app, isExit: true, onPressed: () {
                        // Acción de salir
                      }),
                    ],
                  ),
                ),

                // Contenido principal que cambia dependiendo de la pantalla seleccionada
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: _currentChild,  // Aquí se muestra el widget actual
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Botón de la barra lateral que se usa para cambiar de pantalla
  Widget _buildMenuButton(String title, IconData icon, {bool isExit = false, required VoidCallback onPressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: SizedBox(
        width: double.infinity, // Se ajusta al ancho del contenedor
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: isExit ? const Color(0xFF792D1F) : Colors.amber[200],  // Cambia el color si es el botón de salir
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: onPressed,  // Acción que se ejecuta al presionar el botón
          icon: Icon(icon, color: isExit ? Colors.white : AppColors.primary),
          label: Text(title,  // Texto del botón
              style: TextStyle(color: isExit ? Colors.white : AppColors.primary)),
        ),
      ),
    );
  }
}
