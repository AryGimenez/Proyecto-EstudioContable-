// frontend/flutter_gestion_contable/lib/screens/main_website/main_content.dart

import 'package:flutter/material.dart';

/// Widget para el contenido principal de la pantalla.
/// * Muestra un mensaje de bienvenida y un botón de cerrar sesión.
class MainContent extends StatelessWidget {
  
  final VoidCallback onLogout; // Callback para cerrar sesión.
  
  /// Constructor de la clase [MainContent].
  /// * Recibe un callback [onLogout] para cerrar sesión.
  const MainContent({super.key, required this.onLogout});
  
  /// Método para construir el widget.
  /// * Muestra un mensaje de bienvenida y un botón de cerrar sesión.
  @override
  Widget build(BuildContext context) {
    return Scaffold( // Devuelve un widget Scaffold.
      appBar: AppBar( // Barra de aplicación.
        title: const Text('Pantalla Principal'), // Título de la barra.
        actions: [ // Acciones en la barra de aplicación.
          IconButton( // Botón de cerrar sesión.
            icon: const Icon(Icons.logout), // Icono de cerrar sesión.
            onPressed: onLogout, // Llama al callback recibido del handler.
          ),
        ],
      ),
      body: const Center( // Cuerpo de la pantalla.
        child: Text('Bienvenido al sitio principal.'), // Mensaje de bienvenida.
      ),
    );
  }
}