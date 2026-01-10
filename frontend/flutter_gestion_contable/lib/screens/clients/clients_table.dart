// frontend/flutter_gestion_contable/lib/screens/clients/clients_table.dart

import 'package:flutter/material.dart';
import 'package:flutter_gestion_contable/screens/clients/clients_handler.dart';
import 'package:flutter_gestion_contable/models/cliente_modle.dart';
import 'package:flutter_gestion_contable/core/theme/app_colors.dart';

/// ClientsTable es un widget que muestra la lista de clientes en una tabla interactiva.
/// Al ser 'StatelessWidget', no maneja estado interno; depende de los datos que recibe.
class ClientsTable extends StatelessWidget {
  final ClientsHandler
      handler; // Controlador que contiene los datos de los clientes.
  final Function(int, bool)
      onRowSelected; // Función que se ejecuta al seleccionar una fila.
  final Function(bool)
      onSelectAll; // Función que se ejecuta al seleccionar/deseleccionar todos.

  const ClientsTable({
    super.key,
    required this.handler,
    required this.onRowSelected,
    required this.onSelectAll,
  });

  /// Calcula el ancho óptimo de una columna basándose en el contenido más largo.
  /// 
  /// Utiliza [TextPainter] para medir la dimensión física de cada string en píxeles,
  /// comparando los encabezados con todos los datos de la lista [clients].
  /// 
  /// [clients] es la lista de datos actual para comparar.
  /// [columnKey] es el identificador de la columna (ej. 'Nombre', 'Email').
  /// [style] es el estilo de texto aplicado para asegurar una medición precisa.
  /// 
  /// Retorna un [double] con el ancho máximo encontrado más un margen de seguridad.
  double _calculateColumnWidth(
      List<ClienteModel> clients, String columnKey, TextStyle style) {
    double maxWidth = 0; // Variable para guardar el ancho máximo encontrado.

    // 'TextPainter' sirve para medir cuánto mide un texto físicamente en la pantalla.
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
          text: columnKey, // Texto que se mide.
          style: style), // Estilo del texto que se mide.
      maxLines: 1, // Limitamos a una línea para evitar saltos de línea innecesarios.
      textDirection:/// Este método calcula el ancho necesario para una columna basándose en el texto más largo.
  /// Esto evita que el contenido se vea amontonado o cortado.
          TextDirection.ltr, // Dirección del texto (Izquierda a Derecha).
    )..layout(); // 'layout()' realiza el cálculo del tamaño.

    maxWidth =
        textPainter.width; // Empezamos con el ancho del título de la columna.

    // Recorremos todos los clientes para ver cuál tiene el dato más largo en esta columna.
    for (var client in clients) {
      String text = '';
      // Dependiendo de qué columna estemos calculando, tomamos un dato u otro del modelo.
      switch (columnKey) {
        case 'Nombre':
          text = client.nombre;
          break;
        case 'Email':
          text = client.email ?? ''; // Si es nulo, usamos un texto vacío.
          break;
        case 'Nacimiento':
          // Convertimos la fecha a String y nos quedamos solo con la parte de la fecha (sin la hora).
          text = client.fechaNacimiento.toString().split(' ')[0];
          break;
        case 'WhatsApp':
          text = client.whatsapp;
          break;
        case 'Saldo':
          // Formateamos el saldo con 2 decimales y el símbolo de peso.
          text = '\$${client.saldo.toStringAsFixed(2)}';
          break;
        case 'Contacto':
          text = client.datoContacto ?? '';
          break;
        case 'Dirección':
          text = client.direccion ?? '';
          break;
      }

      //<!> Aca me quede porque uso este varibale la declaro 2 veces
      //<!>  no seria mejor decararla una sola ves y cargarle en nuevo valor 
      //<!>  del texto 
      // Medimos el texto de este cliente en particular.
      final TextPainter dataPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: 1,
        textDirection: TextDirection.ltr,
      )..layout();

      // Si este dato es más ancho que el máximo actual, actualizamos 'maxWidth'.
      if (dataPainter.width > maxWidth) {
        maxWidth = dataPainter.width;
      }
    }
    // Devolvemos el ancho máximo encontrado más un margen extra (padding) de 30 pixeles.
    return maxWidth + 30;
  }

  @override
  Widget build(BuildContext context) {
    // Definimos estilos constantes para las cabeceras y las celdas.
    const TextStyle headerStyle =
        TextStyle(color: Colors.white, fontWeight: FontWeight.bold);
    const TextStyle cellStyle = TextStyle(color: Colors.black);

    // Obtenemos la lista de clientes ya filtrada del handler.
    final List<ClienteModel> clientsData = handler.filteredClients;

    // Calculamos los anchos de cada columna dinámicamente.
    final double nombreColumnWidth =
        _calculateColumnWidth(clientsData, 'Nombre', cellStyle);
    final double emailColumnWidth =
        _calculateColumnWidth(clientsData, 'Email', cellStyle);
    final double nacimientoColumnWidth =
        _calculateColumnWidth(clientsData, 'Nacimiento', cellStyle);
    final double whatsappColumnWidth =
        _calculateColumnWidth(clientsData, 'WhatsApp', cellStyle);
    final double contactoColumnWidth =
        _calculateColumnWidth(clientsData, 'Contacto', cellStyle);
    final double direccionColumnWidth =
        _calculateColumnWidth(clientsData, 'Dirección', cellStyle);
    final double saldoColumnWidth =
        _calculateColumnWidth(clientsData, 'Saldo', cellStyle);

    // Ancho fijo para columnas especiales.
    const double checkboxHeaderColumnWidth = 50; // Columna del checkbox.
    const double editIconColumnWidth = 60; // Margen para el final de la tabla.

    // Sumamos todos los anchos para saber el ancho total mínimo que necesita la tabla.
    final double minTableWidth = checkboxHeaderColumnWidth +
        nombreColumnWidth +
        emailColumnWidth +
        nacimientoColumnWidth +
        whatsappColumnWidth +
        saldoColumnWidth +
        contactoColumnWidth +
        direccionColumnWidth +
        editIconColumnWidth;

    // 'LayoutBuilder' nos deja saber cuánto espacio disponible tiene el widget en pantalla.
    return LayoutBuilder(
      builder: (context, constraints) {
        // Si el espacio disponible es mayor al mínimo, usamos todo el espacio disponible.
        final double tableWidth = constraints.maxWidth > minTableWidth
            ? constraints.maxWidth
            : minTableWidth;

        // 'SingleChildScrollView' con scroll horizontal permite que la tabla se deslice si es muy ancha.
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            // Configuramos que la tabla mida al menos el ancho calculado.
            constraints: BoxConstraints(minWidth: tableWidth),
            child: DataTable(
              columnSpacing: 10.0, // Espacio entre columnas.
              dataRowHeight: 40.0, // Altura de cada fila de datos.
              headingRowHeight: 40.0, // Altura de la fila de cabecera.
              // Color de fondo de la cabecera (usando el color primario del tema).
              headingRowColor: WidgetStateProperty.all(AppColors.primary),
              showCheckboxColumn:
                  true, // Muestra la columna de selección a la izquierda.
              columns: [
                // 'DataColumn' define cada columna y su título.
                const DataColumn(
                    label: SizedBox.shrink()), // Espacio para el checkbox.
                DataColumn(
                    label: SizedBox(
                        width: nombreColumnWidth,
                        child: const Text('Nombre', style: headerStyle))),
                DataColumn(
                    label: SizedBox(
                        width: emailColumnWidth,
                        child: const Text('Email', style: headerStyle))),
                DataColumn(
                    label: SizedBox(
                        width: nacimientoColumnWidth,
                        child: const Text('Nacimiento', style: headerStyle))),
                DataColumn(
                    label: SizedBox(
                        width: whatsappColumnWidth,
                        child: const Text('WhatsApp', style: headerStyle))),
                DataColumn(
                    label: SizedBox(
                        width: direccionColumnWidth,
                        child: const Text('Dirección', style: headerStyle))),
                DataColumn(
                    label: SizedBox(
                        width: contactoColumnWidth,
                        child: const Text('Contacto', style: headerStyle))),
                DataColumn(
                    label: SizedBox(
                        width: saldoColumnWidth,
                        child: const Text('Saldo', style: headerStyle))),
                const DataColumn(
                    label: SizedBox.shrink()), // Columna de relleno al final.
              ],
              // Si hay clientes, generamos las filas. Si no, mostramos un mensaje de "No encontrado".
              rows: handler.filteredClients.isNotEmpty
                  ? List.generate(
                      handler.filteredClients.length,
                      (index) {
                        final client = handler.filteredClients[
                            index]; // Obtenemos el cliente por su índice.
                        final clientId = client.id; // Su ID único.
                        final isSelected = handler
                            .isRowSelected(clientId); // Si está seleccionado.

                        // 'DataRow' representa una fila de la tabla.
                        return DataRow(
                          selected:
                              isSelected, // Indica visualmente si está seleccionada.
                          onSelectChanged: (value) {
                            // Cuando se pulsa el checkbox, llamamos a la función recibida por parámetro.
                            onRowSelected(clientId, value ?? false);
                          },
                          cells: [
                            // Cada 'DataCell' es una celda dentro de la fila.
                            DataCell(const SizedBox(
                                width: checkboxHeaderColumnWidth - 10)),
                            DataCell(SizedBox(
                                width: nombreColumnWidth,
                                child: Text(client.nombre, style: cellStyle))),
                            DataCell(SizedBox(
                                width: emailColumnWidth,
                                child: Text(client.email ?? '',
                                    style: cellStyle))),
                            DataCell(SizedBox(
                                width: nacimientoColumnWidth,
                                child: Text(
                                    client.fechaNacimiento
                                        .toString()
                                        .split(' ')[0],
                                    style: cellStyle))),
                            DataCell(SizedBox(
                                width: whatsappColumnWidth,
                                child:
                                    Text(client.whatsapp, style: cellStyle))),
                            DataCell(SizedBox(
                                width: direccionColumnWidth,
                                child: Text(client.direccion ?? '',
                                    style: cellStyle))),
                            DataCell(SizedBox(
                                width: contactoColumnWidth,
                                child: Text(client.datoContacto ?? '',
                                    style: cellStyle))),
                            DataCell(SizedBox(
                              width: saldoColumnWidth,
                              child: Text(
                                '\$${client.saldo.toStringAsFixed(2)}',
                                style: TextStyle(
                                  // El color del saldo cambia: rojo si debe dinero, verde si está a favor.
                                  color: client.saldo < 0
                                      ? Colors.red
                                      : Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )),
                            const DataCell(SizedBox.shrink()),
                          ],
                        );
                      },
                    )
                  : [
                      // Esta fila solo aparece si la búsqueda no arroja resultados.
                      const DataRow(cells: [
                        DataCell(Text('No se encontraron clientes',
                            style: TextStyle(fontStyle: FontStyle.italic))),
                        DataCell(Text('')),
                        DataCell(Text('')),
                        DataCell(Text('')),
                        DataCell(Text('')),
                        DataCell(Text('')),
                        DataCell(Text('')),
                        DataCell(Text('')),
                        DataCell(Text('')),
                      ]),
                    ],
            ),
          ),
        );
      },
    );
  }
}
