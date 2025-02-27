import 'package:flutter/material.dart';
import 'main_styles.dart';

class MainScreen extends StatelessWidget {
  final Widget child;

  const MainScreen({required this.child, Key? key}) : super(key: key);

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
                      _buildMenuButton('Clientes', Icons.people),
                      _buildMenuButton('Agregar Cliente', Icons.person_add),
                      _buildMenuButton('Pagos', Icons.payment),
                      _buildMenuButton('Depósito', Icons.account_balance),
                      const Spacer(),
                      _buildMenuButton('Salir', Icons.exit_to_app, isExit: true),
                    ],
                  ),
                ),

                // Contenido principal (cambia según la pantalla)
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Botón de la barra lateral
  Widget _buildMenuButton(String title, IconData icon, {bool isExit = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        width: 200,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: isExit ? const Color(0xFF792D1F) : Colors.amber[200],
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: () {},
          icon: Icon(icon, color: isExit ? Colors.white : AppColors.primary),
          label: Text(title,
              style: TextStyle(color: isExit ? Colors.white : AppColors.primary)),
        ),
      ),
    );
  }
}
