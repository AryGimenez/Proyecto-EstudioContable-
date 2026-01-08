// frontend/flutter_gestion_contable/lib/models/cliente_modle.dart

class ClienteModel {
  final int id;
  final String nombre;
  final String? direccion;
  final String? email;
  final String whatsapp;
  final String? datoContacto;
  final DateTime fechaNacimiento;
  final double saldo;

  ClienteModel({
    required this.id,
    required this.nombre,
    this.direccion,
    this.email,
    required this.whatsapp,
    this.datoContacto,
    required this.fechaNacimiento,
    required this.saldo,
  });

  // Este es el "Constructor Factory" que transforma el JSON de Python en este Objeto Dart
  factory ClienteModel.fromJson(Map<String, dynamic> json) {
    return ClienteModel(
      id: json['Cli_ID'],
      nombre: json['Cli_Nom'],
      direccion: json['Cli_Dir'],
      email: json['Cli_Email'],
      whatsapp: json['Cli_Whatsapp'],
      datoContacto: json['Cli_DatoContacto'],
      // Convertimos el String de la BD a un objeto DateTime de Dart
      fechaNacimiento: DateTime.parse(json['Cli_FechNas']),
      // Aseguramos que el saldo sea double (por si viene como int)
      saldo: (json['Cli_Saldo'] as num).toDouble(),
    );
  }
}