// lib/screens/login/login_styles.dart

import 'package:flutter/material.dart';
// Importa la librería de Flutter para utilizar widgets y herramientas de Material Design.

class LoginStyles {
  // Clase estática que centraliza los estilos reutilizables para la pantalla de inicio de sesión.

  static const double horizontalPadding = 16.0;
  // Define el padding horizontal estándar para márgenes y separación entre elementos.
  // Valor constante para garantizar consistencia en todo el diseño.

  static const double verticalPadding = 24.0;
  // Define el padding vertical estándar para márgenes y separación entre elementos.
  // Este valor puede usarse en bordes superiores e inferiores de widgets.

  static const double spacing = 16.0;
  // Espaciado genérico entre elementos de la interfaz, como cajas, botones, o texto.
  // Garantiza uniformidad en la distribución de los elementos.

  static const BoxDecoration containerDecoration = BoxDecoration(
    // Estilo de decoración visual que puede aplicarse a un contenedor (Container) o similar.

    color: Colors.white,
    // Define el color de fondo del contenedor. En este caso, blanco.

    borderRadius: BorderRadius.all(Radius.circular(16)),
    // Aplica bordes redondeados a todo el contenedor.
    // El radio de curvatura es de 16 píxeles, dando un aspecto más moderno y amigable.

    boxShadow: [
      // Define un efecto de sombra que proporciona profundidad visual al contenedor.
      BoxShadow(
        color: Colors.black12,
        // Color de la sombra: un negro con opacidad baja (12% de opacidad).
        // Da un efecto sutil para no ser intrusivo.

        blurRadius: 15,
        // Radio de desenfoque de la sombra.
        // Un valor alto hace que los bordes de la sombra sean más difusos.

        offset: Offset(0, 5),
        // Define el desplazamiento de la sombra en los ejes X (horizontal) e Y (vertical).
        // Aquí, la sombra está centrada horizontalmente (0) y desplazada 5 píxeles hacia abajo.
      ),
    ],
  );
  // Esta decoración es ideal para cajas que contienen campos de formulario, tarjetas o elementos destacados.
}
