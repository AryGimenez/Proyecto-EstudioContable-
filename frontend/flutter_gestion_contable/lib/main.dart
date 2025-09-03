import 'package:flutter/material.dart';
// Importa la pantalla de inicio de sesión, que será la primera que vea el usuario si no hay sesión.
import 'package:flutter_gestion_contable/screens/login/login_handler.dart';
// Importa la pantalla principal, a la que se navegará si hay una sesión activa.
import 'package:flutter_gestion_contable/screens/main_website/main_handler.dart';
// Importa el servicio de API para verificar si existe un token de autenticación.
import 'package:flutter_gestion_contable/services/api_service.dart';
// Importa el tema de la aplicación para mantener un estilo visual consistente.
import 'package:flutter_gestion_contable/core/theme/app_theme.dart';

// La función principal que arranca la aplicación de Flutter.
void main() async {
  // Asegura que los bindings de Flutter estén inicializados antes de cualquier operación asíncrona.
  WidgetsFlutterBinding.ensureInitialized();
  
  // Crea una instancia del ApiService para verificar si hay un token de autenticación.
  final apiService = ApiService();
  final token = await apiService.getToken();

  // Inicia la aplicación, pasando un valor booleano que indica si hay un token.
  runApp(MyApp(hasToken: token != null));
}

// MyApp es el widget raíz de la aplicación.
class MyApp extends StatelessWidget {
  // Variable para determinar la pantalla inicial.
  final bool hasToken;
  
  const MyApp({super.key, required this.hasToken});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Título de la aplicación, visible en el selector de aplicaciones.
      title: 'Estudio Contable',
      // Aplica el tema de la aplicación para colores, fuentes, etc.
      theme: AppTheme.lightTheme,
      // Define la pantalla inicial basándose en la existencia de un token.
      // Si `hasToken` es verdadero, navega a la pantalla principal.
      // Si es falso, muestra la pantalla de inicio de sesión.
      home: hasToken ? const MainHandler() : const LoginHandler(),
      // Desactiva el banner de "debug" en la esquina superior derecha.
      debugShowCheckedModeBanner: false,
    );
  }
}