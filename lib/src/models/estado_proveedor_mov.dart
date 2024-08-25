import '/src/utils/date_formats.dart';

class EstadoProveedorMov {
  const EstadoProveedorMov({
    this.id,
    required this.createdAt,
    required this.createdBy,
    required this.estadoCode,
    required this.bancoId,
    required this.bancoNombre,
    required this.movType,
    required this.docId,
    required this.docDate,
    required this.producto,
    required this.cantAves,
    required this.peso,
    required this.precio,
    required this.descripcion,
    required this.importe,
    required this.pago,
    required this.saldo,
  });

  final int? id;
  final DateTime createdAt;
  final String createdBy;
  final String estadoCode;
  final int bancoId;
  final String bancoNombre;
  final String movType;
  final String docId;
  final DateTime docDate;
  final String producto;
  final int cantAves;
  final double peso;
  final double precio;
  final String descripcion;
  final double importe;
  final double pago;
  final double saldo;

  factory EstadoProveedorMov.fromJson(Map<String, dynamic> json) =>
      EstadoProveedorMov(
        id: json['id'],
        createdAt: DateTime.parse(json['created_at']),
        createdBy: json['created_by'],
        estadoCode: json['estado_code'],
        bancoId: json['banco_id'],
        bancoNombre: json['banco_nombre'],
        movType: json['mov_type'],
        docId: json['doc_id'],
        docDate: DateTime.parse(json['doc_date']),
        producto: json['producto'],
        cantAves: json['cant_aves'],
        peso: json['peso'].toDouble(),
        precio: json['precio'].toDouble(),
        descripcion: json['descripcion'],
        importe: json['importe'].toDouble(),
        pago: json['pago'].toDouble(),
        saldo: json['saldo'].toDouble(),
      );

  Map<String, dynamic> toJson() {
    return {
        'id': id,
        'created_at': dt.format(createdAt),
        'created_by': createdBy,
        'estado_code': estadoCode,
        'banco_id': bancoId,
        'banco_nombre': bancoNombre,
        'mov_type': movType,
        'doc_id': docId,
        'doc_date': dt.format(docDate),
        'producto': producto,
        'cant_aves': cantAves,
        'peso': peso,
        'precio': precio,
        'descripcion': descripcion,
        'importe': importe,
        'pago': pago
      };
  }

  EstadoProveedorMov copyWith({
    int? newCantAves,
    double? newPeso,
    double? newPrecio,
    double? newImporte,
    double? newPago,
  }) =>
      EstadoProveedorMov(
        id: id,
        createdAt: createdAt,
        createdBy: createdBy,
        estadoCode: estadoCode,
        bancoId: bancoId,
        bancoNombre: bancoNombre,
        movType: movType,
        docId: docId,
        docDate: docDate,
        producto: producto,
        cantAves: cantAves,
        peso: peso,
        precio: precio,
        descripcion: descripcion,
        importe: importe,
        pago: pago,
        saldo: saldo
      );
}
