// lib/screens/add_clients/add_clients.dart

import 'package:flutter/material.dart';
import 'package:flutter_gestion_contable/core/theme/app_colors.dart';
import 'add_clients_handler.dart'; // Asegúrate de que esta importación sea correcta si es necesaria.

class AgregarClientesContent extends StatefulWidget {
  const AgregarClientesContent({super.key});

  @override
  _AgregarClientesContentState createState() => _AgregarClientesContentState();
}

class _AgregarClientesContentState extends State<AgregarClientesContent> {
  // Controladores de texto para capturar los datos ingresados por el usuario.
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController frecuenciaController = TextEditingController();
  final TextEditingController diasController = TextEditingController();
  final TextEditingController vencimientoController = TextEditingController();
  final TextEditingController montoController = TextEditingController();
  final TextEditingController honorarioController = TextEditingController();

  // Lista para almacenar los registros de la tabla de impuestos.
  List<Map<String, String>> _clientesData = [];

  // Es buena práctica liberar los recursos de los controladores al destruir el widget.
  @override
  void dispose() {
    nombreController.dispose();
    frecuenciaController.dispose();
    diasController.dispose();
    vencimientoController.dispose();
    montoController.dispose();
    honorarioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título de la sección.
          const Center(
            child: Text(
              "Datos de clientes",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),

          // Filas de campos de entrada de texto.
          buildInputRow(["Nombre Completo", "Fecha de Nacimiento", "Email"]),
          const SizedBox(height: 8),
          buildInputRow(["Whatsapp", "Datos de Contacto", "Dirección"]),
          const SizedBox(height: 20),

          // Título de la sección de impuestos.
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(color: AppColors.primary),
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              'Impuestos',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 10),

          // Tabla de impuestos con scroll.
          Expanded(
            child: SingleChildScrollView(
              child: buildTaxTable(
                context,
                vencimientoController: vencimientoController,
                nombreController: nombreController,
                frecuenciaController: frecuenciaController,
                diasController: diasController,
                montoController: montoController,
                honorarioController: honorarioController,
                onAdd: _addCliente, 
                data: _clientesData, 
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Botones para acciones de la tabla.
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildSmallButton("Eliminar", Colors.red),
              buildSmallButton("Modificar", Colors.blue),
            ],
          ),
          const SizedBox(height: 8),

          // Botones de acción principales.
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildSmallButton("Cancelar", Colors.grey),
              buildSmallButton("Agregar", Colors.green),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  // Método para agregar un nuevo cliente a la lista.
  void _addCliente() {
    // Valida que los campos no estén vacíos antes de agregar el registro.
    if (nombreController.text.isNotEmpty &&
        frecuenciaController.text.isNotEmpty &&
        diasController.text.isNotEmpty &&
        vencimientoController.text.isNotEmpty &&
        montoController.text.isNotEmpty &&
        honorarioController.text.isNotEmpty) {
      setState(() {
        _clientesData.add({
          'nombre': nombreController.text,
          'frecuencia': frecuenciaController.text,
          'dias': diasController.text,
          'vencimiento': vencimientoController.text,
          'monto': montoController.text,
          'honorario': honorarioController.text,
        });
      });

      // Limpia los campos de texto después de agregar el registro.
      nombreController.clear();
      frecuenciaController.clear();
      diasController.clear();
      vencimientoController.clear();
      montoController.clear();
      honorarioController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor complete todos los campos.')));
    }
  }

  // Widget de utilidad para construir los botones pequeños.
  Widget buildSmallButton(String text, Color color) {
    return SizedBox(
      width: 120,
      height: 40,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
        onPressed: () {},
        child: Text(text, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  // Aquí se asume que `buildInputRow` y `buildTaxTable` son funciones o widgets definidos en `add_clients_handler.dart`
  // o en otro archivo importado. El error "undefined method" que encontraste antes
  // es probable que ocurra con estas funciones si no están definidas.
}