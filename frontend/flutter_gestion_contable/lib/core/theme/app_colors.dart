// lib/theme/appcolor.dart

/// Clase que define la paleta de colores centralizada para toda la aplicación.
/// Todos los colores son constantes y estáticos para acceso global.
/// Los colores se definen usando valores hexadecimales con el formato 0xFF seguido del código de color.
library;

import 'package:flutter/material.dart';

class AppColors {
  /// Colores primarios de la aplicación
  /// Se usan principalmente para elementos destacados, botones y barras
  /// primary: Azul principal usado en elementos interactivos y de énfasis
  static const Color primary = Color(0xFF986d35);

  /// secondary: Variante más oscura del color primario
  static const Color secondary = Color(0xFF00a2d3);

  /// Colores de fondo para diferentes capas y superficies
  /// background: Color de fondo principal, blanco puro para máximo contraste
  static const Color background = Colors.white; // Blanco puro
  /// surfaceColor: Color para elementos elevados o tarjetas
  static const Color surfaceColor = Color(0xFFF5F5F5); // Gris muy claro

  /// Colores para texto y tipografía
  /// textPrimary: Color principal para texto, casi negro para mejor legibilidad
  static const Color textPrimary = Color(0xFF212121); // Gris muy oscuro
  /// textSecondary: Color para texto menos importante o secundario
  static const Color textSecondary = Color(0xFF757575); // Gris medio

  /// Colores para estados y feedback
  /// error: Color rojo usado para errores y alertas críticas
  static const Color error = Color(0xFFD32F2F); // Material Red 700
  /// success: Color verde usado para confirmaciones y éxito
  static const Color success = Color(0xFF388E3C); // Material Green 700
}
