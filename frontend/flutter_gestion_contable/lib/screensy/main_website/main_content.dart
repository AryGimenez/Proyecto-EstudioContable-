import 'package:flutter/material.dart';
import 'main_styles.dart';  // Importa los estilos personalizados

class MainScreen extends StatelessWidget {
  final Widget child; // El widget que se pasará para el contenido principal
  final String title; // El título que se pasará a la barra superior

  // Constructor que recibe el widget y el título como parámetros
  const MainScreen({required this.child, required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Barra superior que contiene el título y los botones de notificación y menú
          Container(
            height: 60,
            color: AppColors.primary,  // Color de la barra superior
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Título dinámico que se pasará al widget
                Text(
                  title, // Muestra el título actualizado
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
                        backgroundColor: const Color(0xFF792D1F),  // Color del botón
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(120, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: const Icon(Icons.notifications, color: Colors.white),
                      label: const SizedBox.shrink(),  // El label está vacío ya que solo tiene el ícono
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
                  width: 250,  // Ancho de la barra lateral
                  color: AppColors.primary,  // Color de la barra lateral
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
                      // Botones de menú que redirigen a diferentes secciones
                      _buildMenuButton('Clientes', Icons.people),
                      _buildMenuButton('Agregar Cliente', Icons.person_add),
                      _buildMenuButton('Pagos', Icons.payment),
                      _buildMenuButton('Depósito', Icons.account_balance),
                      const Spacer(),
                      // Botón de salir
                      _buildMenuButton('Salir', Icons.exit_to_app, isExit: true),
                    ],
                  ),
                ),

                // Contenido principal que cambia dependiendo de la pantalla seleccionada
                Expanded(child: child),  // Aquí se muestra el widget actual que se pasa al constructor
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Botón de la barra lateral que se usa para cambiar de pantalla
  Widget _buildMenuButton(String title, IconData icon, {bool isExit = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),  // Separación entre los botones
      child: SizedBox(
        width: 200,  // Ancho de los botones
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: isExit ? const Color(0xFF792D1F) : Color(0xFFf8f19f),  // Cambia el color si es el botón de salir
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),  // Bordes redondeados
          ),
          onPressed: () {},  // Aquí se puede colocar la acción que se quiere ejecutar al presionar el botón
          icon: Icon(icon, color: isExit ? Colors.white : AppColors.primary),  // Cambia el color del ícono según si es un botón de salir
          label: Text(title,  // El texto del botón
              style: TextStyle(color: isExit ? Colors.white : AppColors.primary)),
        ),
      ),
    );
  }
  class NotificationModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: 300,
        height: 500, // Ajusta el tamaño según necesites
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Barra superior con botón de cerrar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Notificaciones", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),

            // Contenido del modal
            Expanded(
              child: Center(
                child: Text("Aquí van las notificaciones"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
}
