import 'package:flutter/material.dart';
import 'main_styles.dart';
import '../clients/clients_screen.dart';

class MainHandler extends StatefulWidget {
  const MainHandler({Key? key}) : super(key: key);

  @override
  _MainHandlerState createState() => _MainHandlerState();
}

class _MainHandlerState extends State<MainHandler> {
  // Variable para almacenar el widget que se mostrará en el área principal
  Widget _currentChild = Center(child: Text('Bienvenido a la aplicación')); // Widget por defecto

  // Método para cambiar el contenido dinámicamente
  void _changeContent(Widget newContent) {
    setState(() {
      _currentChild = newContent;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Barra superior
          Container(
            height: 60,
            color: AppColors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Título', // Se cambiará según la pantalla
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
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
                // Barra lateral
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
                      _buildMenuButton('Clientes', Icons.people, onPressed: () {
                        _changeContent(ClientsScreen()); // Cambiar al widget de Clientes
                      }),
                      _buildMenuButton('Agregar Cliente', Icons.person_add, onPressed: () {
                        _changeContent(Center(child: Text('Agregar Cliente')));
                      }),
                      _buildMenuButton('Pagos', Icons.payment, onPressed: () {
                        _changeContent(Center(child: Text('Pagos')));
                      }),
                      _buildMenuButton('Depósito', Icons.account_balance, onPressed: () {
                        _changeContent(Center(child: Text('Depósito')));
                      }),
                      const Spacer(),
                      _buildMenuButton('Salir', Icons.exit_to_app, isExit: true, onPressed: () {
                        // Acción de salir
                      }),
                    ],
                  ),
                ),

                // Contenido principal (cambia según la pantalla)
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: _currentChild,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Botón de la barra lateral
  Widget _buildMenuButton(String title, IconData icon, {bool isExit = false, required VoidCallback onPressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: SizedBox(
        width: double.infinity, // Se ajusta al ancho del contenedor
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: isExit ? const Color(0xFF792D1F) : Colors.amber[200],
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: onPressed,
          icon: Icon(icon, color: isExit ? Colors.white : AppColors.primary),
          label: Text(title,
              style: TextStyle(color: isExit ? Colors.white : AppColors.primary)),
        ),
      ),
    );
  }
}
