class CajaMov {
  const CajaMov({
    this.id,
    required this.fecha,
    required this.hora,
    required this.createdBy,
    required this.movType,
    this.docId,
    required this.bancoId,
    required this.bancoNombre,
    required this.bancoEstadoCta,
    required this.entityType,
    required this.entityId,
    required this.entityNombre,
    required this.entityEstadoCta,
    required this.descripcion,
    required this.ingreso,
    required this.egreso,
  });

  final int? id;
  final String fecha;
  final String hora;
  final String createdBy;
  final String movType;
  final String? docId;
  final int bancoId;
  final String bancoNombre;
  final String bancoEstadoCta;
  final String entityType;
  final int entityId;
  final String entityNombre;
  final String entityEstadoCta;
  final String descripcion;
  final double ingreso;
  final double egreso;

  factory CajaMov.fromJson(Map<String, dynamic> json) => CajaMov(
        id: json['id'],
        fecha: json['fecha'],
        hora: json['hora'],
        createdBy: json['created_by'],
        movType: json['mov_type'],
        docId: json['doc_id'],
        bancoId: json['banco_id'],
        bancoNombre: json['banco_nombre'],
        bancoEstadoCta: json['banco_estado_cta'],
        entityType: json['entity_type'],
        entityId: json['entity_id'],
        entityNombre: json['entity_nombre'],
        entityEstadoCta: json['entity_estado_cta'],
        descripcion: json['descripcion'],
        ingreso: json['ingreso'].toDouble(),
        egreso: json['egreso'].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'fecha': fecha,
        'hora': hora,
        'created_by': createdBy,
        'mov_type': movType,
        'doc_id': docId,
        'banco_id': bancoId,
        'banco_nombre': bancoNombre,
        'banco_estado_cta': bancoEstadoCta,
        'entity_type': entityType,
        'entity_id': entityId,
        'entity_nombre': entityNombre,
        'entity_estado_cta': entityEstadoCta,
        'descripcion': descripcion,
        'ingreso': ingreso,
        'egreso': egreso
      };

  CajaMov copyWith({double? newIngreso, double? newEgreso}) => CajaMov(
        id: id,
        fecha: fecha,
        hora: hora,
        createdBy: createdBy,
        movType: movType,
        docId: docId,
        bancoId: bancoId,
        bancoNombre: bancoNombre,
        bancoEstadoCta: bancoEstadoCta,
        entityType: entityType,
        entityId: entityId,
        entityNombre: entityNombre,
        entityEstadoCta: entityEstadoCta,
        descripcion: descripcion,
        ingreso: newIngreso ?? ingreso,
        egreso: newEgreso ?? egreso,
      );
}
