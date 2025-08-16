import 'package:flutter/material.dart';
import 'package:flutter_gestion_contable/core/theme/app_colors.dart';
import 'add_clients_handler.dart'; // Asegúrate de importar correctamente

class AgregarClientesContent extends StatefulWidget {
  @override
  _AgregarClientesContentState createState() => _AgregarClientesContentState();
}

class _AgregarClientesContentState extends State<AgregarClientesContent> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController frecuenciaController = TextEditingController();
  final TextEditingController diasController = TextEditingController();
  final TextEditingController vencimientoController = TextEditingController();
  final TextEditingController montoController = TextEditingController();
  final TextEditingController honorarioController = TextEditingController();

  // Lista para almacenar los registros de la tabla
  List<Map<String, String>> _clientesData = [];

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
                onAdd: _addCliente, // Llamamos a la función para agregar registros
                data: _clientesData, // Mostramos los registros actuales
              ),
            ),
          ),
          SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildSmallButton("Eliminar", Colors.red),
              buildSmallButton("Modificar", Colors.blue),
            ],
          ),
          SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildSmallButton("Cancelar", Colors.grey),
              buildSmallButton("Agregar", Colors.green),
            ],
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  // Función que se llama al presionar el botón "Agregar"
  void _addCliente() {
    if (nombreController.text.isNotEmpty &&
        frecuenciaController.text.isNotEmpty &&
        diasController.text.isNotEmpty &&
        vencimientoController.text.isNotEmpty &&
        montoController.text.isNotEmpty &&
        honorarioController.text.isNotEmpty) {
      setState(() {
        // Agregamos un nuevo cliente a la lista
        _clientesData.add({
          'nombre': nombreController.text,
          'frecuencia': frecuenciaController.text,
          'dias': diasController.text,
          'vencimiento': vencimientoController.text,
          'monto': montoController.text,
          'honorario': honorarioController.text,
        });
      });

      // Limpiamos los controladores
      nombreController.clear();
      frecuenciaController.clear();
      diasController.clear();
      vencimientoController.clear();
      montoController.clear();
      honorarioController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Por favor complete todos los campos.')));
    }
  }

  Widget buildSmallButton(String text, Color color) {
    return SizedBox(
      width: 120,
      height: 40,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
        onPressed: () {},
        child: Text(text, style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
