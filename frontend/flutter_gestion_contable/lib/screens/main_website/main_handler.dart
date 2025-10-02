// lib/screens/main_website/main_handler.dart

import 'package:flutter/material.dart';
import 'package:flutter_gestion_contable/core/theme/app_colors.dart';
import 'package:flutter_gestion_contable/services/api_service.dart';
import 'package:flutter_gestion_contable/screens/login/login_handler.dart';
import '../clients/clients_screen.dart';
import '../add_clients/add_clients.dart';
import '../payments/payments_screen.dart';
import '../deposits/deposits_screen.dart';
import 'notification_modal.dart';
import 'package:provider/provider.dart'; // Importa el paquete aquí
import '../clients/clients_handler.dart'; // Importa el ClientsHandler también

class MainHandler extends StatefulWidget {
  const MainHandler({super.key});

  @override
  _MainHandlerState createState() => _MainHandlerState();
}

class _MainHandlerState extends State<MainHandler> {
  Widget _currentChild = const Center(child: Text('Bienvenido a la aplicación'));
  String _currentTitle = 'Bienvenido';
  Map<String, bool> _selectedMenuItem = {
    'Clientes': false,
    'Agregar Cliente': false,
    'Pagos': false,
    'Depósito': false,
    'Salir': false, 
  };

  final ApiService _apiService = ApiService();

  void _changeContent(Widget newContent, String title, String menuItem) {
    setState(() {
      _currentChild = newContent; 
      _currentTitle = title;
      _updateButtonSelection(menuItem);
    });
  }

  void _updateButtonSelection(String selectedItem) {
    _selectedMenuItem.updateAll((key, value) => false); 
    _selectedMenuItem[selectedItem] = true;
  }
  
  void _logout() async {
    await _apiService.logout();
    
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginHandler()),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 60,
            color: AppColors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _currentTitle,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => NotificationModal(),
                        );
                      },
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
          Expanded(
            child: Row(
              children: [
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
                        _changeContent(
                          // Aquí envolvemos ClientsScreen en el Provider
                          ChangeNotifierProvider(
                            // Pasamos la instancia de ApiService al ClientsHandler
                            create: (context) => ClientsHandler(_apiService), 
                            child: const ClientsScreen(),
                          ),
                          'Clientes',
                          'Clientes',
                        );
                      }),
                      _buildMenuButton('Agregar Cliente', Icons.person_add,
                          onPressed: () {
                        _changeContent(AgregarClientesContent(), 'Agregar Cliente', 'Agregar Cliente');
                      }),
                      _buildMenuButton('Pagos', Icons.payment, onPressed: () {
                        _changeContent(PaymentsScreen(), 'Pagos', 'Pagos');
                      }),
                      _buildMenuButton('Depósito', Icons.account_balance,
                          onPressed: () {
                        _changeContent(DepositsScreen(), 'Depósito', 'Depósito');
                      }),
                      const Spacer(),
                      _buildMenuButton('Salir', Icons.exit_to_app, isExit: true,
                          onPressed: _logout),
                    ],
                  ),
                ),
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

  // Widget para construir los botones del menú de la barra lateral.
  Widget _buildMenuButton(String title, IconData icon,
      {bool isExit = false, required VoidCallback onPressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: _selectedMenuItem[title] == true
                ? Colors.white
                : (isExit
                    ? const Color(0xFF792D1F)
                    : Colors.amber[200]), // ¡Corregido aquí el color!
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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