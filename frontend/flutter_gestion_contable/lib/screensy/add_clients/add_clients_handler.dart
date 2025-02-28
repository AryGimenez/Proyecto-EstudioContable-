import 'package:flutter/material.dart';
import 'package:flutter_gestion_contable/core/theme/app_colors.dart';

// Función para construir una fila con tres campos de texto
Widget buildInputRow(List<String> labels) {
  return Row(
    children: labels.map((label) {
      return Expanded(
        // 'Expanded' hace que cada input ocupe el mismo espacio disponible en la fila.
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
  return Container(
    width: double.infinity, // Asegura que el contenedor ocupe todo el ancho disponible.
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey), // Establece el borde alrededor de la tabla.
      borderRadius: BorderRadius.circular(8), // Aplica un radio de esquina redondeado al borde.
    ),
    child: DataTable(
      columnSpacing: 12, // Establece el espacio entre las columnas de la tabla.
      headingRowHeight: 45, // Altura de la fila de encabezado.
      dataRowMinHeight: 30, // Altura de las filas de datos (celdas de la tabla).
      headingRowColor: WidgetStateProperty.all(AppColors.primary), // Establece el color de fondo para la fila del encabezado.
      
      // Define las columnas de la tabla
      columns: [
        _buildHeaderColumn("Nombre"), // Llama a la función que construye una columna de encabezado
        _buildHeaderColumn("Frecuencia"),
        _buildHeaderColumn("Días"),
        _buildHeaderColumn("Vencimiento"),
        _buildHeaderColumn("Monto"),
        _buildHeaderColumn("Honorario"),
      ],
      
      // Define las filas de la tabla, generando 5 filas como ejemplo
      rows: List.generate(
        5, // Genera 5 filas de ejemplo
        (index) => DataRow(cells: [
          DataCell(Text("Impuesto $index", style: TextStyle(fontSize: 14))), // Celda con texto para "Impuesto X"
          DataCell(Text("Mensual", style: TextStyle(fontSize: 14))), // Celda con texto para la frecuencia
          DataCell(Text("${index * 5}", style: TextStyle(fontSize: 14))), // Celda con el valor de días, multiplicando por el índice
          DataCell(Text("01/0${index + 1}/2025", style: TextStyle(fontSize: 14))), // Celda con la fecha de vencimiento
          DataCell(Text("\$UYU ${(index + 1) * 1000}", style: TextStyle(fontSize: 14))), // Celda con monto
          DataCell(Text("\$UYU ${(index + 1) * 500}", style: TextStyle(fontSize: 14))), // Celda con honorarios
        ]),
      ),
    ),
  );
}

// Función para construir las celdas del encabezado de la tabla
DataColumn _buildHeaderColumn(String title) {
  return DataColumn(
    label: Container(
      alignment: Alignment.center, // Centra el contenido dentro de la celda de encabezado
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, // Centra los elementos en la fila
        children: [
          Text(
            title, // Título de la columna
            style: TextStyle(
              color: Colors.white, // Color del texto
              fontWeight: FontWeight.bold, // Establece el peso del texto como negrita
              fontSize: 14, // Tamaño de la fuente
            ),
          ),
          SizedBox(width: 5), // Espacio entre el texto y el ícono
          Icon(
            Icons.arrow_drop_down, // Icono de flecha hacia abajo
            size: 16, // Tamaño del ícono
            color: Colors.white, // Color del ícono
          ),
        ],
      ),
    ),
  );
}
