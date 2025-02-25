import 'package:flutter/material.dart';
import 'main_styles.dart'; // Importa los estilos personalizados
import 'main_content.dart'; // Importa el contenido principal

class MainHandler extends StatelessWidget {
  const MainHandler({super.key}); // Constructor de la clase

  @override
  Widget build(BuildContext context) {
    return Scaffold( // Scaffold es el esqueleto de la pantalla
      appBar: AppBar( // Barra superior de la aplicación
        title: Text('Pantalla Principal'), // Título de la barra
      ),
      body: Center( // Cuerpo de la pantalla centrado
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

// Función para construir el menú lateral (Drawer)
Widget buildDrawer() {
  return Drawer(
    child: ListView( // Lista de elementos en el Drawer
      children: [
        UserAccountsDrawerHeader( // Cabecera del Drawer con info del usuario
          accountName: Text("Lorena Gimenez"), // Nombre de la cuenta
          accountEmail: Text("lorena@example.com"), // Email de la cuenta
          currentAccountPicture: CircleAvatar(backgroundImage: AssetImage('assets/profile.jpg')), // Imagen de perfil
          decoration: BoxDecoration(color: AppColors.primary), // Fondo de la cabecera
        ),
        // Elementos del menú lateral
        ListTile(leading: Icon(Icons.person), title: Text("Clientes"), onTap: () {}),
        ListTile(leading: Icon(Icons.payment), title: Text("Pagos"), onTap: () {}),
        ListTile(leading: Icon(Icons.attach_money), title: Text("Depósito"), onTap: () {}),
        ListTile(leading: Icon(Icons.exit_to_app), title: Text("Salir"), onTap: () {}),
      ],
    ),
  );
}

// Función para construir la barra de búsqueda
Widget buildSearchBar() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0), // Añade margen horizontal
    child: TextField( // Campo de texto para la búsqueda
      decoration: InputDecoration( // Estilo del campo de texto
        labelText: 'Buscar', // Texto que aparece dentro del campo
        prefixIcon: Icon(Icons.search), // Icono de búsqueda al inicio
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)), // Borde redondeado
      ),
    ),
  );
}

// Función para construir la tabla de clientes
Widget buildClientTable() {
  return SingleChildScrollView( // Permite hacer scroll horizontal
    scrollDirection: Axis.horizontal, // Definir dirección del scroll como horizontal
    child: DataTable( // Construye la tabla de datos
      columnSpacing: 15, // Espaciado entre las columnas
      headingRowColor: WidgetStateColor.resolveWith((states) => AppColors.primary), // Color del encabezado de la tabla
      columns: [ // Definir las columnas de la tabla
        DataColumn(label: Text("Nombre", style: TextStyle(color: Colors.white))), // Columna para el nombre
        DataColumn(label: Text("Email", style: TextStyle(color: Colors.white))), // Columna para el email
        DataColumn(label: Text("Nacimiento", style: TextStyle(color: Colors.white))), // Columna para la fecha de nacimiento
        DataColumn(label: Text("WhatsApp", style: TextStyle(color: Colors.white))), // Columna para WhatsApp
        DataColumn(label: Text("Monto", style: TextStyle(color: Colors.white))), // Columna para monto mensual
        DataColumn(label: Text("Contacto", style: TextStyle(color: Colors.white))), // Columna para contacto
        DataColumn(label: Text("Dirección", style: TextStyle(color: Colors.white))), // Columna para dirección
      ],
      rows: clients.map((client) { // Mapea la lista de clientes para construir las filas
        return DataRow(cells: [ // Cada fila de la tabla
          DataCell(Text(client.name)), // Celda con el nombre
          DataCell(Text(client.email)), // Celda con el email
          DataCell(Text(client.birthDate)), // Celda con la fecha de nacimiento
          DataCell(Text(client.whatsapp)), // Celda con WhatsApp
          DataCell(Text(client.monthlyAmount)), // Celda con el monto mensual
          DataCell(Text(client.contact)), // Celda con el contacto
          DataCell(Text(client.address)), // Celda con la dirección
        ]);
      }).toList(), // Convierte la lista de clientes en filas de la tabla
    ),
  );
}