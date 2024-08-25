import '/src/utils/date_formats.dart';

class CamalJaba {
  const CamalJaba({
    this.id,
    required this.createdAt,
    required this.operationDate,
    required this.pesadorId,
    required this.pesadorNombre,
    required this.camalId,
    required this.camalNombre,
    this.trabajadorId,
    this.trabajadorNombre,
    required this.cantidad,
    this.cantRecogida = 0,
    required this.recogido,
  });

  final int? id;
  final DateTime createdAt;
  final DateTime operationDate;
  final int pesadorId;
  final String pesadorNombre;
  final int camalId;
  final String camalNombre;
  final String? trabajadorId;
  final String? trabajadorNombre;
  final int cantidad;
  final int cantRecogida;
  final bool recogido;

  int get quedan => cantidad - cantRecogida;

  bool get completo => cantidad == cantRecogida;

  factory CamalJaba.fromJson(Map<String, dynamic> json) => CamalJaba(
        id: json['id'],
        createdAt: DateTime.parse(json['created_at']),
        operationDate: DateTime.parse(json['operation_date']),
        pesadorId: json['pesador_id'],
        pesadorNombre: json['pesador_nombre'],
        camalId: json['camal_id'],
        camalNombre: json['camal_nombre'],
        trabajadorId: json['trabajador_id'],
        trabajadorNombre: json['trabajador_nombre'],
        cantidad: json['cantidad'],
        cantRecogida: json['cant_recogidas'] ?? 0,
        recogido: json['recogido'] == 1 ? true : false,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'created_at': dt.format(createdAt),
        'operation_date': date.format(operationDate),
        'pesador_id': pesadorId,
        'pesador_nombre': pesadorNombre,
        'camal_id': camalId,
        'camal_nombre': camalNombre,
        'trabajador_id': trabajadorId,
        'trabajador_nombre': trabajadorNombre,
        'cantidad': cantidad,
        'cant_recogidas': cantRecogida,
        'recogido': recogido ? 1 : 0,
      };

  CamalJaba copyWith({int? newCant, bool? newRecogido, int? newCantRecogida}) => CamalJaba(
        id: id,
        createdAt: createdAt,
        operationDate: operationDate,
        pesadorId: pesadorId,
        pesadorNombre: pesadorNombre,
        camalId: camalId,
        camalNombre: camalNombre,
        trabajadorId: trabajadorId,
        trabajadorNombre: trabajadorNombre,
        cantidad: newCant ?? cantidad,
        cantRecogida: newCantRecogida ?? cantRecogida,
        recogido: newRecogido ?? recogido,
      );
}
