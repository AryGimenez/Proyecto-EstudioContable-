// frontend/flutter_gestion_contable/lib/screens/add_clients/add_clients_handler.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Para usar el TextInputFormatter
import 'package:flutter_gestion_contable/core/theme/app_colors.dart';



/// Función auxiliar que construye una fila de campos de texto ([TextField])
/// distribuidos uniformemente utilizando el widget [Row] y [Expanded].
///
/// **Propósito:** Se utiliza para crear *layouts* de formularios donde múltiples
/// campos de entrada comparten el mismo espacio horizontal.
///
/// **Limitación:** Esta función no está siendo utilizada en el archivo 'add_clients.dart'
/// tal como fue proporcionado, pero su intención es modularizar la creación de filas.
///
/// @param labels Una lista de etiquetas de tipo [String] para cada campo de texto.
/// @returns Un widget [Row] que contiene un [TextField] por cada etiqueta.
Widget buildInputRow(List<String> labels) {
  return Row( // Crea una fila horizontal
    children: labels.map((label) {
      return Expanded(
        child: SizedBox(
          height: 40,
          child: TextField(
            decoration: InputDecoration(
              labelText: label,
            ),
          ),
        ),
      );
    }).toList(),
  );
}

Widget buildTaxInputsRow(BuildContext context, {
  required TextEditingController vencimientoController,
  required TextEditingController nombreController,
  required TextEditingController frecuenciaController,
  required TextEditingController diasController,
  required TextEditingController montoController,
  required TextEditingController honorarioController,
  required Function onAdd,
}) {
  return Row(
    children: [
      Expanded(
        child: SizedBox(
          height: 40,
          child: TextField(
            controller: nombreController,
            decoration: InputDecoration(labelText: "Nombre"),
          ),
        ),
      ),
      SizedBox(width: 8),
      Expanded(
        child: SizedBox(
          height: 40,
          child: TextField(
            controller: frecuenciaController,
            decoration: InputDecoration(labelText: "Frecuencia"),
          ),
        ),
      ),
      SizedBox(width: 8),
      Expanded(
        child: SizedBox(
          height: 40,
          child: TextField(
            controller: diasController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(labelText: "Días"),
          ),
        ),
      ),
      SizedBox(width: 8),
      Expanded(
        child: SizedBox(
          height: 40,
          child: TextField(
            controller: vencimientoController,
            readOnly: true,
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime(2100),
              );
              if (pickedDate != null) {
                vencimientoController.text = "${pickedDate.toLocal()}".split(' ')[0];
              }
            },
            decoration: InputDecoration(labelText: "Vencimiento"),
          ),
        ),
      ),
      SizedBox(width: 8),
      Expanded(
        child: SizedBox(
          height: 40,
          child: TextField(
            controller: montoController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: "Monto"),
          ),
        ),
      ),
      SizedBox(width: 8),
      Expanded(
        child: SizedBox(
          height: 40,
          child: TextField(
            controller: honorarioController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: "Honorario"),
          ),
        ),
      ),
      Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: IconButton(
          onPressed: () {
            if (nombreController.text.isNotEmpty &&
                frecuenciaController.text.isNotEmpty &&
                diasController.text.isNotEmpty &&
                vencimientoController.text.isNotEmpty &&
                montoController.text.isNotEmpty &&
                honorarioController.text.isNotEmpty) {
              onAdd();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Por favor complete todos los campos.')));
            }
          },
          icon: Icon(Icons.add, color: Colors.white),
        ),
      ),
    ],
  );
}

Widget buildTaxTable(BuildContext context, {
  required TextEditingController vencimientoController,
  required TextEditingController nombreController,
  required TextEditingController frecuenciaController,
  required TextEditingController diasController,
  required TextEditingController montoController,
  required TextEditingController honorarioController,
  required Function onAdd,
  required List<Map<String, String>> data,
}) {
  return Column(
    children: [
      buildTaxInputsRow(
        context,
        vencimientoController: vencimientoController,
        nombreController: nombreController,
        frecuenciaController: frecuenciaController,
        diasController: diasController,
        montoController: montoController,
        honorarioController: honorarioController,
        onAdd: onAdd,
      ),
      SizedBox(height: 10),
      Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: DataTable(
          columnSpacing: 12,
          headingRowHeight: 45,
          dataRowMinHeight: 30,
          headingRowColor: MaterialStateProperty.all(AppColors.primary),
          columns: [
            _buildHeaderColumn("Nombre"),
            _buildHeaderColumn("Frecuencia"),
            _buildHeaderColumn("Días"),
            _buildHeaderColumn("Vencimiento"),
            _buildHeaderColumn("Monto"),
            _buildHeaderColumn("Honorario"),
          ],
          rows: data.map((item) {
            return DataRow(cells: [
              DataCell(Text(item['nombre']!)),
              DataCell(Text(item['frecuencia']!)),
              DataCell(Text(item['dias']!)),
              DataCell(Text(item['vencimiento']!)),
              DataCell(Text(item['monto']!)),
              DataCell(Text(item['honorario']!)),
            ]);
          }).toList(),
        ),
      ),
    ],
  );
}

DataColumn _buildHeaderColumn(String title) {
  return DataColumn(
    label: Container(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          SizedBox(width: 5),
          Icon(
            Icons.arrow_drop_down,
            size: 16,
            color: Colors.white,
          ),
        ],
      ),
    ),
  );
}
