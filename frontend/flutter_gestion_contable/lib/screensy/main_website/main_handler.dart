import 'package:flutter/material.dart';
import 'main_styles.dart';
import 'main_content.dart';

class MainHandler extends StatelessWidget {
  const MainHandler({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pantalla Principal'),
      ),
      body: Center(
        child: ClientsScreen(),
      ),
    );
  }
}

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

List<Client> clients = [
  Client("Ary Gimenez", "juan.perez@ex...", "01/01/2010", "+598 98 12...", "\$3,500", "+598 98 12...", "Calle 18 de Julio"),
  Client("Sofía Ramírez", "maria.gonzalez@...", "15/03/2008", "+598 98 9...", "\$2,800", "+598 98 9...", "Avenida Cardis"),
  Client("Mateo Gómez", "carlos.lopez@ex...", "12/07/2009", "+598 98 5...", "\$5,100", "+598 98 5...", "Calle Artigas"),
];

Widget buildDrawer() {
  return Drawer(
    child: ListView(
      children: [
        UserAccountsDrawerHeader(
          accountName: Text("Lorena Gimenez"),
          accountEmail: Text("lorena@example.com"),
          currentAccountPicture: CircleAvatar(backgroundImage: AssetImage('assets/profile.jpg')),
          decoration: BoxDecoration(color: AppColors.primary),
        ),
        ListTile(leading: Icon(Icons.person), title: Text("Clientes"), onTap: () {}),
        ListTile(leading: Icon(Icons.payment), title: Text("Pagos"), onTap: () {}),
        ListTile(leading: Icon(Icons.attach_money), title: Text("Depósito"), onTap: () {}),
        ListTile(leading: Icon(Icons.exit_to_app), title: Text("Salir"), onTap: () {}),
      ],
    ),
  );
}

Widget buildSearchBar() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: TextField(
      decoration: InputDecoration(
        labelText: 'Buscar',
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
    ),
  );
}

Widget buildClientTable() {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: DataTable(
      columnSpacing: 15,
      headingRowColor: MaterialStateColor.resolveWith((states) => AppColors.primary),
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