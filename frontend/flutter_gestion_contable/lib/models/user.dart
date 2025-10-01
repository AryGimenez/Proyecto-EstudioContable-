class User {
  final int usuarioId;
  final String username;
  final String email;
  final String usuarioRol;
  final bool isActive;
  final DateTime createdAt;

  User({
    required this.usuarioId,
    required this.username,
    required this.email,
    required this.usuarioRol,
    required this.isActive,
    required this.createdAt,
  });

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