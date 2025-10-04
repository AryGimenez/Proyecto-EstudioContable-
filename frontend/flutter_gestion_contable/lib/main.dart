// frontend/flutter_gestion_contable/lib/main.dart

import 'package:flutter/material.dart';
// Importa flutter_localizations para el soporte de idiomas (MaterialLocalizations)
import 'package:flutter_localizations/flutter_localizations.dart'; 

// Asegúrate de que estas rutas sean correctas para tu proyecto:
import 'package:flutter_gestion_contable/screens/login/login_handler.dart';
import 'package:flutter_gestion_contable/screens/main_website/main_handler.dart';
import 'package:flutter_gestion_contable/services/api_service.dart';
import 'package:flutter_gestion_contable/core/theme/app_theme.dart';

import 'package:provider/provider.dart'; // Si estás usando Provider en tu aplicación, mantenlo.


// La función principal que arranca la aplicación de Flutter.
void main() async {
  // Asegura que los bindings de Flutter estén inicializados antes de cualquier operación asíncrona.
  WidgetsFlutterBinding.ensureInitialized();
  
  // Crea una instancia del ApiService para verificar si hay un token de autenticación.
  final apiService = ApiService();
  final token = await apiService.getToken(); // Obtiene el token almacenado (si existe).

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

      // *******************************************************************
      // ******* AÑADIR ESTAS LÍNEAS PARA LA LOCALIZACIÓN ******************
      // *******************************************************************
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate, // Necesario para soporte en iOS
      ],
      supportedLocales: const [
        Locale('en', ''), // Soporte para inglés
        Locale('es', ''), // Soporte para español
      ],
      // *******************************************************************
      // *******************************************************************

      // Define la pantalla inicial basándose en la existencia de un token.
      // Si `hasToken` es verdadero, navega a la pantalla principal.
      // Si es falso, muestra la pantalla de inicio de sesión.
      home: hasToken ? const MainHandler() : const LoginHandler(),
      // Desactiva el banner de "debug" en la esquina superior derecha.
      debugShowCheckedModeBanner: false,
    );
  }
}