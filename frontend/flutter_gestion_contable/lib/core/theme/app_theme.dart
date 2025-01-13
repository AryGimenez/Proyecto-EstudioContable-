// lib/core/theme/app_theme.dart

import 'package:flutter/material.dart'; // Importa la librería principal de Flutter para usar Material Design
import 'app_colors.dart'; // Importa el archivo que contiene los colores definidos en la app

class AppTheme {
  // Método getter para obtener el tema claro de la aplicación (lightTheme)

  static ThemeData get lightTheme {
    return ThemeData(
      // Define el color principal para la aplicación, que se usará en elementos como el AppBar, botones, etc.
      primaryColor: AppColors.primary,

      // Establece el color de fondo de la pantalla principal (scaffold) en la aplicación
      scaffoldBackgroundColor: AppColors.background,

      // Tema personalizado para el widget ElevatedButton (botones elevados)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          // Establece el color de fondo del ElevatedButton usando el color primario de la app
          backgroundColor: AppColors.primary,

          // Define el color del texto del botón como blanco
          foregroundColor: Colors.white,

          // Establece el tamaño mínimo del botón (ancho infinito y altura de 50 píxeles)
          minimumSize: const Size(double.infinity, 50),

          // Define la forma del botón, especificando bordes redondeados
          shape: RoundedRectangleBorder(
            // Aplica un redondeo de 8 píxeles a los bordes del botón
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

      // Tema para la decoración de los campos de texto (InputDecoration)
      inputDecorationTheme: InputDecorationTheme(
        // Habilita el relleno de los campos de texto
        filled: true,

        // Define el color de fondo de los campos de texto como blanco
        fillColor: Colors.white,

        // Establece el borde del campo de texto cuando no está enfocado
        border: OutlineInputBorder(
          // Aplica bordes redondeados con un radio de 8 píxeles
          borderRadius: BorderRadius.circular(8),

          // Define el color del borde como el color primario de la app
          borderSide: const BorderSide(color: AppColors.primary),
        ),

        // Establece el borde del campo de texto cuando está habilitado
        enabledBorder: OutlineInputBorder(
          // Aplica bordes redondeados con un radio de 8 píxeles
          borderRadius: BorderRadius.circular(8),

          // Define el color del borde con una opacidad del 50% sobre el color primario
          // ignore: deprecated_member_use
          borderSide: BorderSide(color: AppColors.primary.withOpacity(0.5)),
        ),

        // Establece el borde cuando el campo de texto está enfocado (activo)
        focusedBorder: OutlineInputBorder(
          // Aplica bordes redondeados con un radio de 8 píxeles
          borderRadius: BorderRadius.circular(8),

          // Define el color del borde como el color primario, con un grosor de 2 píxeles
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),

        // Establece el borde cuando hay un error en el campo de texto
        errorBorder: OutlineInputBorder(
          // Aplica bordes redondeados con un radio de 8 píxeles
          borderRadius: BorderRadius.circular(8),

          // Define el color del borde como el color de error de la app
          borderSide: const BorderSide(color: AppColors.error),
        ),
      ),
    );
  }
}
