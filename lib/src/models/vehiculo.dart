import 'package:app_desktop/src/utils/date_formats.dart';

class Vehiculo {
  const Vehiculo({
    this.id,
    required this.createdAt,
    required this.createdBy,
    required this.placa,
    required this.capacidad,
  });

  final int? id;
  final DateTime createdAt;
  final String createdBy;
  final String placa;
  final int capacidad;

  factory Vehiculo.fromJson(Map<String, dynamic> json) => Vehiculo(
        id: json['id'],
        createdAt: DateTime.parse(json['created_at']),
        createdBy: json['created_by'],
        placa: json['placa'],
        capacidad: json['capacidad'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'created_at': dt.format(createdAt),
        'created_by': createdBy,
        'placa': placa,
        'capacidad': capacidad
      };

  Vehiculo copyWith({int? newCapacidad}) => Vehiculo(
        id: id,
        createdAt: createdAt,
        createdBy: createdBy,
        placa: placa,
        capacidad: newCapacidad ?? capacidad,
      );
}
