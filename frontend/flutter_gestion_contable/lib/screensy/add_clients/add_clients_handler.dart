import 'package:flutter/material.dart';
import 'package:flutter_gestion_contable/core/theme/app_colors.dart';

// Función para construir una fila con tres campos de texto
Widget buildInputRow(List<String> labels) {
  return Row(
    children: labels.map((label) {
      return Expanded(
        child: SizedBox(
          height: 40, // Define la altura del input
          child: TextField(
            decoration: InputDecoration(
              labelText: label, // El texto que aparece como label del input
            ),
          ),
        ),
      );
    }).toList(), // Convierte la lista de 'labels' en una lista de widgets de tipo TextField.
  );
}

// Función para construir la tabla de impuestos
Widget buildTaxTable() {
  return Column(
    children: [
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
          rows: List.generate(
            5,
            (index) => DataRow(cells: [
              DataCell(Text("Impuesto $index", style: TextStyle(fontSize: 14))),
              DataCell(Text("Mensual", style: TextStyle(fontSize: 14))),
              DataCell(Text("${index * 5}", style: TextStyle(fontSize: 14))),
              DataCell(Text("01/0${index + 1}/2025", style: TextStyle(fontSize: 14))),
              DataCell(Text("\$UYU ${(index + 1) * 1000}", style: TextStyle(fontSize: 14))),
              DataCell(Text("\$UYU ${(index + 1) * 500}", style: TextStyle(fontSize: 14))),
            ]),
          ),
        ),
      ),
    ],
  );
}

// Función para construir las celdas del encabezado de la tabla
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
