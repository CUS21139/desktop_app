import '/src/utils/date_formats.dart';

import './entity.dart';

class Banco extends Entity{
  const Banco ({
    super.id,
    required this.createdAt,
    required this.createdBy,
    required super.nombre,
    super.estadoCta,
    super.saldo,
  });

  final DateTime createdAt;
  final String createdBy;

  String get entityType => 'BN';

  factory Banco.fromJson(Map<String, dynamic> json) => Banco(
        id: json['id'],
        createdAt: DateTime.parse(json['created_at']),
        createdBy: json['created_by'],
        nombre: json['nombre'],
        estadoCta: json['estado_cta'],
        saldo: json['saldo'] == null ? 0.0 : json['saldo'].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'created_at': dt.format(createdAt),
        'created_by': createdBy,
        'nombre': nombre,
        'estado_cta': estadoCta,
        'saldo': saldo
      };

  Banco copyWith({String? newNombre, double? newSaldo}) => Banco(
      id: id,
      createdAt: createdAt,
      createdBy: createdBy,
      nombre: newNombre ?? nombre,
      estadoCta: estadoCta,
      saldo: newSaldo ?? saldo);
}
