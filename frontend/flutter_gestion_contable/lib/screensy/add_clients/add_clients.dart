import 'package:flutter/material.dart';
import 'package:flutter_gestion_contable/core/theme/app_colors.dart';
import 'add_clients_handler.dart'; // Asegúrate de importar correctamente

class AgregarClientesContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              "Datos de clientes",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),

          buildInputRow(["Nombre Completo", "Fecha de Nacimiento", "Email"]),
          SizedBox(height: 8),
          buildInputRow(["Whatsapp", "Datos de Contacto", "Dirección"]),
          SizedBox(height: 20),

          Container(
            width: double.infinity,
            decoration: BoxDecoration(color: AppColors.primary),
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Impuestos',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 10),

          // Se expande la tabla sin afectar la estructura
          Expanded(child: SingleChildScrollView(child: buildTaxTable())),

          SizedBox(height: 10), // Espacio antes de los botones

          // Fila con los botones superiores (Eliminar - Modificar)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribución espaciada
            children: [
              buildSmallButton("Eliminar", Colors.red),
              buildSmallButton("Modificar", Colors.blue),
            ],
          ),
          SizedBox(height: 8),

          // Fila con los botones inferiores (Cancelar - Agregar)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribución espaciada
            children: [
              buildSmallButton("Cancelar", Colors.grey),
              buildSmallButton("Agregar", Colors.green),
            ],
          ),
          SizedBox(height: 10), // Espacio final
        ],
      ),
    );
  }

  // Función para construir botones pequeños
  Widget buildSmallButton(String text, Color color) {
    return SizedBox(
      width: 120,// Tamaño pequeño para los botones
      height: 40,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
        onPressed: () {}, // Acción vacía por ahora
        child: Text(text, style: TextStyle(color: Colors.white)),
      ),
    );
  }
}