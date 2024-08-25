import '/src/utils/date_formats.dart';
import './entity.dart';

class TrabajadorRegistro extends Entity{
  const TrabajadorRegistro({
    super.id,
    required this.createdAt,
    required this.createdBy,
    required super.nombre,
    required this.zonaCode,
    this.docId,
    required this.celular,
    required super.estadoCta,
    this.monto = 0,
    this.confirmado = 0,
  });

  final DateTime createdAt;
  final String createdBy;
  final int? celular;
  final String zonaCode;
  final String? docId;
  final double monto;
  final int confirmado;

  factory TrabajadorRegistro.fromJson(Map<String, dynamic> json) => TrabajadorRegistro(
        id: json['id'],
        createdAt: DateTime.parse(json['created_at']),
        createdBy: json['created_by'],
        nombre: json['nombre'],
        celular: json['celular'],
        zonaCode: json['zona_code'],
        docId: json['doc_id'],
        estadoCta: json['estado_cta'],
        monto: json['monto'].toDouble(),
        confirmado: json['confirmado']
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'created_at': dt.format(createdAt),
        'created_by': createdBy,
        'nombre': nombre,
        'celular': celular,
        'zona_code': zonaCode,
        'doc_id': docId,
        'estado_cta': estadoCta,
        'saldo': saldo,
        'monto': monto,
        'confirmado': confirmado
      };

  TrabajadorRegistro copyWith({
    String? newNombre,
    int? newCelular,
    String? newZone,
    double? newSaldo,
    double? newSueldo,
    int? newConfirmado,
  }) =>
      TrabajadorRegistro(
        id: id,
        createdAt: createdAt,
        createdBy: createdBy,
        nombre: newNombre ?? nombre,
        celular: newCelular ?? celular,
        zonaCode: newZone ?? zonaCode,
        docId: docId,
        estadoCta: estadoCta,
        monto: newSueldo ?? monto,
        confirmado: newConfirmado ?? confirmado
      );
}
