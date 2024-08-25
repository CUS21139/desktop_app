import '/src/utils/date_formats.dart';

class Tarea {
  const Tarea({
    this.id,
    required this.updateAt,
    required this.updateBy,
    required this.tareaNombre,
    required this.monto,
  });

  final int? id;
  final DateTime updateAt;
  final String updateBy;
  final String tareaNombre;
  final double monto;

  factory Tarea.fromJson(Map<String, dynamic> json) => Tarea(
        id: json['id'],
        updateAt: DateTime.parse(json['update_at']),
        updateBy: json['update_by'],
        tareaNombre: json['tarea_nombre'],
        monto: json['monto'].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'update_at': dt.format(updateAt),
        'update_by': updateBy,
        'tarea_nombre': tareaNombre,
        'monto': monto
      };

  Tarea copyWith(
          {DateTime? newUpdateAt,
          String? newUpdateBy,
          String? newNombre,
          double? newMonto}) =>
      Tarea(
        id: id,
        updateAt: newUpdateAt ?? updateAt,
        updateBy: newUpdateBy ?? updateBy,
        tareaNombre: newNombre ?? tareaNombre,
        monto: newMonto ?? monto,
      );
}
