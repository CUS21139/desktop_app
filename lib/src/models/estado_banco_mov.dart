import '/src/utils/date_formats.dart';

class EstadoBancoMov {
  const EstadoBancoMov({
    this.id,
    required this.createdAt,
    required this.createdBy,
    required this.estadoCode,
    required this.entityType,
    required this.entityId,
    required this.entityNombre,
    required this.movType,
    required this.docId,
    required this.descripcion,
    required this.ingreso,
    required this.egreso,
    required this.saldo,
  });

  final int? id;
  final DateTime createdAt;
  final String createdBy;
  final String estadoCode;
  final String entityType;
  final int entityId;
  final String entityNombre;
  final String movType;
  final String docId;
  final String descripcion;
  final double ingreso;
  final double egreso;
  final double saldo;

  factory EstadoBancoMov.fromJson(Map<String, dynamic> json) =>
      EstadoBancoMov(
        id: json['id'],
        createdAt: DateTime.parse(json['created_at']),
        createdBy: json['created_by'],
        estadoCode: json['estado_code'],
        entityType: json['entity_type'],
        entityId: json['entity_id'],
        entityNombre: json['entity_nombre'],
        movType: json['mov_type'],
        docId: json['doc_id'],
        descripcion: json['descripcion'],
        ingreso: json['ingreso'].toDouble(),
        egreso: json['egreso'].toDouble(),
        saldo: json['saldo'].toDouble(),
      );

  Map<String, dynamic> toJson() {
    return {
        'id': id,
        'created_at': dt.format(createdAt),
        'created_by': createdBy,
        'estado_code': estadoCode,
        'entity_type': entityType,
        'entity_id': entityId,
        'entity_nombre': entityNombre,
        'mov_type': movType,
        'doc_id': docId,
        'descripcion': descripcion,
        'ingreso': ingreso,
        'egreso': egreso
      };
  }

  EstadoBancoMov copyWith({
    int? newCantAves,
    double? newPeso,
    double? newPrecio,
    double? newImporte,
    double? newPago,
  }) =>
      EstadoBancoMov(
        id: id,
        createdAt: createdAt,
        createdBy: createdBy,
        estadoCode: estadoCode,
        entityType: entityType,
        entityId: entityId,
        entityNombre: entityNombre,
        movType: movType,
        docId: docId,
        descripcion: descripcion,
        ingreso: ingreso,
        egreso: egreso,
        saldo: saldo
      );
}
