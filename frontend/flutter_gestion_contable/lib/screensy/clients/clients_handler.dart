import 'package:flutter/material.dart';
import 'package:flutter_gestion_contable/screensy/main_website/main_styles.dart';
import 'clients_screen.dart'; // Importa el contenido principal

class ClientsHandler extends StatelessWidget {
  const ClientsHandler({super.key}); // Constructor de la clase

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ClientsScreen(), // Aquí se muestra la pantalla de clientes
      ),
    );
  }
}

// Clase Client que define la estructura de cada cliente
class Client {
  final String name;
  final String email;
  final String birthDate;
  final String whatsapp;
  final String monthlyAmount;
  final String contact;
  final String address;

  Client(this.name, this.email, this.birthDate, this.whatsapp, this.monthlyAmount, this.contact, this.address);
}

// Lista de clientes con datos de ejemplo
List<Client> clients = [
  Client("Ary Gimenez", "juan.perez@ex...", "01/01/2010", "+598 98 12...", "\$3,500", "+598 98 12...", "Calle 18 de Julio"),
  Client("Sofía Ramírez", "maria.gonzalez@...", "15/03/2008", "+598 98 9...", "\$2,800", "+598 98 9...", "Avenida Cardis"),
  Client("Mateo Gómez", "carlos.lopez@ex...", "12/07/2009", "+598 98 5...", "\$5,100", "+598 98 5...", "Calle Artigas"),
];

// Función para construir la tabla de clientes
Widget buildClientTable() {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: DataTable(
      columnSpacing: 15,
      headingRowColor: WidgetStateColor.resolveWith((states) => AppColors.primary),
      columns: [
        DataColumn(label: Text("Nombre", style: TextStyle(color: Colors.white))),
        DataColumn(label: Text("Email", style: TextStyle(color: Colors.white))),
        DataColumn(label: Text("Nacimiento", style: TextStyle(color: Colors.white))),
        DataColumn(label: Text("WhatsApp", style: TextStyle(color: Colors.white))),
        DataColumn(label: Text("Monto", style: TextStyle(color: Colors.white))),
        DataColumn(label: Text("Contacto", style: TextStyle(color: Colors.white))),
        DataColumn(label: Text("Dirección", style: TextStyle(color: Colors.white))),
      ],
      rows: clients.map((client) {
        return DataRow(cells: [
          DataCell(Text(client.name)),
          DataCell(Text(client.email)),
          DataCell(Text(client.birthDate)),
          DataCell(Text(client.whatsapp)),
          DataCell(Text(client.monthlyAmount)),
          DataCell(Text(client.contact)),
          DataCell(Text(client.address)),
        ]);
      }).toList(),
    ),
  );
}
