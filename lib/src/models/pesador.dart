import '/src/utils/date_formats.dart';

class Pesador {
  const Pesador({
    this.id,
    required this.createdAt,
    required this.createdBy,
    required this.nombre,
    required this.password,
    required this.zonaCode,
    this.jabas = 0,
  });

  final int? id;
  final DateTime createdAt;
  final String createdBy;
  final String nombre;
  final String password;
  final String zonaCode;
  final int jabas;

  factory Pesador.fromJson(Map<String, dynamic> json) => Pesador(
        id: json['id'],
        createdAt: DateTime.parse(json['created_at']),
        createdBy: json['created_by'],
        nombre: json['nombre'],
        password: json['password'],
        zonaCode: json['zona_code'],
        jabas: json['jabas'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'created_at': dt.format(createdAt),
        'created_by': createdBy,
        'nombre': nombre,
        'password': password,
        'zona_code': zonaCode,
        'jabas': jabas,
      };

  Pesador copyWith({
    String? newNombre,
    String? newPassword,
    String? newZonaCode,
    int? newJabas,
  }) =>
      Pesador(
        id: id,
        createdAt: createdAt,
        createdBy: createdBy,
        nombre: newNombre ?? nombre,
        password: newPassword ?? password,
        zonaCode: newZonaCode ?? zonaCode,
        jabas: newJabas ?? jabas,
      );
}
