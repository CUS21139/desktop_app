import '/src/utils/date_formats.dart';

class Camal {
  const Camal ({
    this.id,
    required this.createdAt,
    required this.createdBy,
    required this.nombre,
    required this.zonaCode,
    // this.jabas = 0,
  });

  final int? id;
  final DateTime createdAt;
  final String createdBy;
  final String nombre;
  final String zonaCode;
  // final int jabas;

  factory Camal.fromJson(Map<String, dynamic> json) => Camal(
        id: json['id'],
        createdAt: DateTime.parse(json['created_at']),
        createdBy: json['created_by'],
        nombre: json['nombre'],
        zonaCode: json['zona_code'],
        // jabas: json['jabas'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'created_at': dt.format(createdAt),
        'created_by': createdBy,
        'nombre': nombre,
        'zona_code': zonaCode,
        // 'jabas': jabas,
      };

  Camal copyWith({String? newNombre, String? newZoneCod, int? newJabas}) => Camal(
        id: id,
        createdAt: createdAt,
        createdBy: createdBy,
        nombre: newNombre ?? nombre,
        zonaCode: newZoneCod ?? zonaCode,
        // jabas: newJabas ?? jabas,
      );
}