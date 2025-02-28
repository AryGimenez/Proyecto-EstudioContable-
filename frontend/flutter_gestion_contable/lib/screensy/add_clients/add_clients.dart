import 'package:flutter/material.dart';
import 'package:flutter_gestion_contable/core/theme/app_colors.dart';

void main() {
  // Función principal que inicia la app
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Agregar Clientes"), // Título de la barra de la aplicación
        ),
        body: AgregarClientesContent(), // Cuerpo de la app con la clase 'AgregarClientesContent'
      ),
    );
  }
}

class AgregarClientesContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0), // Define el espacio de los lados
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Alinea todo a la izquierda
        children: [
          // Título "Datos de clientes"
          Center(
            child: Text(
              "Datos de clientes", // Título centrado
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), // Estilo del título
            ),
          ),
          SizedBox(height: 10), // Espacio entre el título y el siguiente elemento

          // Fila de inputs para el primer conjunto de campos
          buildInputRow(["Nombre Completo", "Fecha de Nacimiento", "Email"]),
          SizedBox(height: 8), // Espacio entre las filas de inputs
          
          // Fila de inputs para el segundo conjunto de campos
          buildInputRow(["Whatsapp", "Datos de Contacto", "Dirección"]),
          SizedBox(height: 20), // Espacio entre los inputs y la siguiente sección

          // Sección de impuestos con fondo azul que ocupa todo el ancho
          Container(
            width: double.infinity, // Ocupa todo el ancho disponible
            decoration: BoxDecoration(color: AppColors.primary), // Fondo azul
            padding: EdgeInsets.all(8.0), // Relleno interno de la caja
            child: Text(
              'Impuestos', // Texto centralizado
              style: TextStyle(color: Colors.white), // Estilo del texto en blanco
              textAlign: TextAlign.center, // Alineación del texto al centro
            ),
          ),
          SizedBox(height: 10), // Espacio entre la sección de impuestos y la tabla

          // Tabla de impuestos con scroll
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical, // Permite scroll vertical
              child: buildTaxTable(), // Llama a la función que genera la tabla
            ),
          ),
        ],
      ),
    );
  }

  // Método para crear una fila con tres inputs (campos de texto)
  Widget buildInputRow(List<String> labels) {
    return Row(
      children: labels.map((label) {
        return Expanded(
          // 'Expanded' hace que cada input ocupe el mismo espacio disponible en la fila
          child: SizedBox(
            height: 40, // Altura de cada campo de texto
            child: TextField(
              decoration: InputDecoration(labelText: label), // Configura la etiqueta para cada campo
            ),
          ),
        );
      }).toList(), // Convierte la lista de etiquetas en una lista de widgets TextField
    );
  }

  // Método para crear la tabla de impuestos
  Widget buildTaxTable() {
    return Container(
      width: double.infinity, // Asegura que ocupe todo el ancho disponible
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey), // Borde gris alrededor de la tabla
        borderRadius: BorderRadius.circular(8), // Bordes redondeados
      ),
      child: DataTable(
        columnSpacing: 12, // Espacio entre columnas
        headingRowHeight: 30, // Altura de la fila de encabezado
        dataRowHeight: 30, // Altura de las filas de datos
        headingRowColor: WidgetStateProperty.all(AppColors.primary), // Color del fondo del encabezado
        columns: [
          _buildHeaderColumn("Nombre"), // Llama a la función para crear las columnas
          _buildHeaderColumn("Frecuencia"),
          _buildHeaderColumn("Días"),
          _buildHeaderColumn("Vencimiento"),
          _buildHeaderColumn("Monto"),
          _buildHeaderColumn("Honorario"),
        ],
        rows: List.generate(
          5, // Genera 5 filas de datos
          (index) => DataRow(cells: [
            DataCell(Text("Impuesto $index", style: TextStyle(fontSize: 14))), // Celdas con el nombre del impuesto
            DataCell(Text("Mensual", style: TextStyle(fontSize: 14))), // Frecuencia
            DataCell(Text("${index * 5}", style: TextStyle(fontSize: 14))), // Días
            DataCell(Text("01/0${index + 1}/2025", style: TextStyle(fontSize: 14))), // Fecha de vencimiento
            DataCell(Text("\$UYU ${(index + 1) * 1000}", style: TextStyle(fontSize: 14))), // Monto
            DataCell(Text("\$UYU ${(index + 1) * 500}", style: TextStyle(fontSize: 14))), // Honorarios
          ]),
        ),
      ),
    );
  }

  // Método para crear el encabezado de cada columna de la tabla
  DataColumn _buildHeaderColumn(String title) {
    return DataColumn(
      label: Container(
        alignment: Alignment.center, // Centra el contenido dentro de la celda del encabezado
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, // Alinea el contenido de la fila al centro
          children: [
            Text(
              title, // El título de la columna
              style: TextStyle(
                color: Colors.white, // Color blanco para el texto
                fontWeight: FontWeight.bold, // Texto en negrita
                fontSize: 14, // Tamaño del texto
              ),
            ),
            SizedBox(width: 5), // Espacio entre el texto y el icono
            Icon(
              Icons.arrow_drop_down, // Icono de flecha hacia abajo
              size: 16, // Tamaño del icono
              color: Colors.white, // Color blanco para el icono
            ),
          ],
        ),
      ),
    );
  }
}
