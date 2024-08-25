import 'package:intl/intl.dart';

class EstadoSinNombreMov {
  const EstadoSinNombreMov({
    this.id,
    required this.createdAt,
    required this.createdBy,
    required this.bancoId,
    required this.bancoNombre,
    required this.entityType,
    required this.entityId,
    required this.entityNombre,
    required this.movType,
    this.docId,
    required this.descripcion,
    required this.ingreso,
    required this.egreso,
    required this.saldo,
    this.asignada = false,
  });

  final int? id;
  final DateTime createdAt;
  final String createdBy;
  final int bancoId;
  final String bancoNombre;
  final String entityType;
  final int entityId;
  final String entityNombre;
  final String movType;
  final String? docId;
  final String descripcion;
  final double ingreso;
  final double egreso;
  final double saldo;
  final bool asignada;

  factory EstadoSinNombreMov.fromJson(Map<String, dynamic> json) =>
      EstadoSinNombreMov(
        id: json['id'],
        createdAt: DateTime.parse(json['created_at']),
        createdBy: json['created_by'],
        bancoId: json['banco_id'],
        bancoNombre: json['banco_nombre'],
        entityType: json['entity_type'],
        entityId: json['entity_id'],
        entityNombre: json['entity_nombre'],
        movType: json['mov_type'],
        docId: json['doc_id'],
        descripcion: json['descripcion'],
        ingreso: json['ingreso'].toDouble(),
        egreso: json['egreso'].toDouble(),
        saldo: json['saldo'].toDouble(),
        asignada: json['asignada'] == 0 ? false : true,
      );

  Map<String, dynamic> toJson() {
    final f = DateFormat('yyyy-MM-dd HH:mm:ss');
    return {
      'id': id,
      'created_at': f.format(createdAt),
      'created_by': createdBy,
      'banco_id': bancoId,
      'banco_nombre': bancoNombre,
      'entity_type': entityType,
      'entity_id': entityId,
      'entity_nombre': entityNombre,
      'mov_type': movType,
      'doc_id': docId,
      'descripcion': descripcion,
      'ingreso': ingreso,
      'egreso': egreso,
      'saldo': saldo,
      'asignada': asignada ? 1 : 0
    };
  }
}
