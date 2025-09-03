// lib/screens/main_website/main_content.dart

import 'package:flutter/material.dart';

class MainContent extends StatelessWidget {
  final VoidCallback onLogout;

  const MainContent({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pantalla Principal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: onLogout, // Llama al callback recibido del handler.
          ),
        ],
      ),
      body: const Center(
        child: Text('Bienvenido al sitio principal.'),
      ),
    );
  }
}