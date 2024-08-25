import '/src/utils/date_formats.dart';

class Zona {
  const Zona({
    this.id,
    required this.createdAt,
    required this.createdBy,
    required this.nombre,
    required this.zonaCode,
  });

  final int? id;
  final DateTime createdAt;
  final String createdBy;
  final String nombre;
  final String zonaCode;

  factory Zona.fromJson(Map<String, dynamic> json) => Zona(
        id: json['id'],
        createdAt: DateTime.parse(json['created_at']),
        createdBy: json['created_by'],
        nombre: json['nombre'],
        zonaCode: json['zona_code'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'created_at': dt.format(createdAt),
        'created_by': createdBy,
        'nombre': nombre,
        'zona_code': zonaCode
      };

  Zona copyWith({String? newNombre}) => Zona(
        id: id,
        createdAt: createdAt,
        createdBy: createdBy,
        nombre: newNombre ?? nombre,
        zonaCode: zonaCode,
      );
}
