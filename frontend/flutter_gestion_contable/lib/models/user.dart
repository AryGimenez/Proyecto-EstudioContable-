
/// Modelo de usuario
/// 
/// Este modelo representa la estructura de los datos de un usuario en la aplicación.
/// Incluye información como el ID del usuario, nombre de usuario, correo electrónico,
/// rol de usuario, estado activo y fecha de creación.
class User {
  final int usuarioId; // ID en la base de datos
  final String username; // Nombre de usuario para login
  final String email; // Dirección de correo electrónico  
  final String usuarioRol; // Rol del usuario (admin, user, etc.)
  final bool isActive; // Estado activo del usuario
  final DateTime createdAt; // Fecha de creación del usuario

  // <!> Supongo que esto es un constructor 
  User({
    required this.usuarioId, // ID en la base de datos
    required this.username, // Nombre de usuario para login
    required this.email, // Dirección de correo electrónico  
    required this.usuarioRol, // Rol del usuario (admin, user, etc.)
    required this.isActive, // Estado activo del usuario
    required this.createdAt, // Fecha de creación del usuario
  });

  /// Crea una instancia de User a partir de un mapa JSON.
  /// 
  /// Este método se utiliza para convertir los datos obtenidos de una solicitud HTTP
  /// en una instancia de la clase User.
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      usuarioId: json['usuario_id'],
      username: json['username'],
      email: json['email'],
      usuarioRol: json['usuario_rol'],
      isActive: json['is_active'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}