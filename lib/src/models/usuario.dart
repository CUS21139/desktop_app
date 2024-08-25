class Usuario {
  const Usuario({
    this.id,
    required this.nombre,
    required this.email,
    required this.password,
    required this.role,
    required this.active,
  });

  final int? id;
  final String nombre;
  final String email;
  final String password;
  final String role;
  final int active;

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        id: json['id'],
        nombre: json['nombre'],
        email: json['email'],
        password: json['password'],
        role: json['role'],
        active: json['active'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'email': email,
        'password': password,
        'role': role,
        'active': active
      };

  Usuario copyWith({String? newNombre, String? newPass, String? newRole}) => Usuario(
        id: id,
        nombre: newNombre ?? nombre,
        email: email,
        password: newPass ?? password,
        role: newRole ?? role,
        active: active,
      );
}
