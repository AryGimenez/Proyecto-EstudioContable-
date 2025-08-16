// lib/core/theme/apptextstyles.dart

/// Clase que define los estilos de texto estandarizados para toda la aplicación.
/// Proporciona un conjunto coherente de estilos tipográficos reutilizables.
/// Todos los estilos son constantes y estáticos para garantizar consistencia.
library;

import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  /// Estilo para títulos principales (H1)
  /// Usado en encabezados de pantalla y títulos importantes
  /// Propiedades:
  /// - Tamaño: 24px
  /// - Peso: Bold
  /// - Color: Color de texto principal definido en AppColors
  static const TextStyle headline1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  /// Estilo para texto regular del cuerpo
  /// Usado en párrafos y contenido principal
  /// Propiedades:
  /// - Tamaño: 16px
  /// - Color: Color de texto principal definido en AppColors
  static const TextStyle bodyText1 = TextStyle(
    fontSize: 16,
    color: AppColors.textPrimary,
  );

  /// Estilo específico para texto en botones
  /// Usado en ElevatedButtons y TextButtons
  /// Propiedades:
  /// - Tamaño: 16px
  /// - Peso: Medium (500)
  /// - Color: Blanco para contraste en botones con fondo de color
  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  // Para añadir un nuevo estilo de texto:
  // 1. Definir una nueva constante con TextStyle
  // 2. Documentar su uso previsto
  // 3. Especificar sus propiedades clave
  // 4. Mantener la consistencia con los estilos existentes
}
