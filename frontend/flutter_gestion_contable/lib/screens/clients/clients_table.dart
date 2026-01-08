import 'package:flutter/material.dart';
import 'package:flutter_gestion_contable/screens/clients/clients_handler.dart';
import 'package:flutter_gestion_contable/models/cliente_modle.dart';
import 'package:flutter_gestion_contable/core/theme/app_colors.dart'; 

class ClientsTable extends StatelessWidget {
  final ClientsHandler handler;
  final Function(int, bool) onRowSelected;
  final Function(bool) onSelectAll;

  const ClientsTable({
    super.key,
    required this.handler,
    required this.onRowSelected,
    required this.onSelectAll,
  });

  double _calculateColumnWidth(
      List<ClienteModel> clients, String columnKey, TextStyle style) {
    double maxWidth = 0;
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: columnKey, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();
    maxWidth = textPainter.width;

    for (var client in clients) {
      String text = '';
      switch (columnKey) {
        case 'ID':
          text = client.id.toString();
          break;
        case 'Nombre':
          text = client.nombre;
          break;
        case 'Email':
          text = client.email ?? '';
          break;
        case 'Nacimiento':
          text = client.fechaNacimiento.toString().split(' ')[0];
          break;
        case 'WhatsApp':
          text = client.whatsapp;
          break;
        case 'Saldo':
          text = '\$${client.saldo.toStringAsFixed(2)}';
          break;
        case 'Contacto':
          text = client.datoContacto ?? '';
          break;
        case 'Dirección':
          text = client.direccion ?? '';
          break;
      }
      final TextPainter dataPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: 1,
        textDirection: TextDirection.ltr,
      )..layout();
      if (dataPainter.width > maxWidth) {
        maxWidth = dataPainter.width;
      }
    }
    return maxWidth + 30;
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle headerStyle =
        TextStyle(color: Colors.white, fontWeight: FontWeight.bold);
    const TextStyle cellStyle = TextStyle(color: Colors.black);

    final List<ClienteModel> clientsData = handler.filteredClients;

    final double idColumnWidth =
        _calculateColumnWidth(clientsData, 'ID', cellStyle);
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

    const double checkboxHeaderColumnWidth = 50;
    const double editIconColumnWidth = 60;

    final double minTableWidth = checkboxHeaderColumnWidth +
        idColumnWidth +
        nombreColumnWidth +
        emailColumnWidth +
        nacimientoColumnWidth +
        whatsappColumnWidth +
        saldoColumnWidth +
        contactoColumnWidth +
        direccionColumnWidth +
        editIconColumnWidth;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double tableWidth = constraints.maxWidth > minTableWidth
            ? constraints.maxWidth
            : minTableWidth;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: tableWidth),
            child: DataTable(
              columnSpacing: 10.0,
              dataRowHeight: 40.0,
              headingRowHeight: 40.0,
              headingRowColor: WidgetStateProperty.all(AppColors.primary),
              showCheckboxColumn: true,
              columns: [
                const DataColumn(label: SizedBox.shrink()),
                DataColumn(
                    label: SizedBox(
                        width: idColumnWidth,
                        child: const Text('ID', style: headerStyle))),
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
                const DataColumn(label: SizedBox.shrink()),
              ],
              rows: handler.filteredClients.isNotEmpty
                  ? List.generate(
                      handler.filteredClients.length,
                      (index) {
                        final client = handler.filteredClients[index];
                        final clientId = client.id;
                        final isSelected = handler.isRowSelected(clientId);

                        return DataRow(
                          selected: isSelected,
                          onSelectChanged: (value) {
                            onRowSelected(clientId, value ?? false);
                          },
                          cells: [
                            DataCell(const SizedBox(
                                width: checkboxHeaderColumnWidth - 10)),
                            DataCell(SizedBox(
                                width: idColumnWidth,
                                child: Text(client.id.toString(),
                                    style: cellStyle))),
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
