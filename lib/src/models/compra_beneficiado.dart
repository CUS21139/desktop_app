import 'package:app_desktop/src/abstracts_entities/compra.dart';

import '/src/presentation/utils/round_number.dart';
import '/src/models/producto_beneficiado.dart';
import '/src/utils/date_formats.dart';

class CompraBeneficiado extends Compra{
  const CompraBeneficiado({
    super.id,
    required super.createdAt,
    required super.createdBy,
    super.docId,
    required super.productoId,
    required super.productoNombre,
    required super.proveedorId,
    required super.proveedorNombre,
    required super.proveedorEstadoCta,
    required super.precio,
    required super.pesoTotal,
    required super.cantAves,
    required super.cantJabas,
    required super.importeTotal,
  });

  double get promedio => roundNumber(pesoTotal / cantAves);

  factory CompraBeneficiado.fromJson(Map<String, dynamic> json) => CompraBeneficiado(
        id: json['id'],
        createdAt: DateTime.parse(json['created_at']),
        createdBy: json['created_by'],
        docId: json['doc_id'],
        productoId: json['producto_id'],
        productoNombre: json['producto_nombre'],
        proveedorId: json['proveedor_id'],
        proveedorNombre: json['proveedor_nombre'],
        proveedorEstadoCta: json['proveedor_estado_cta'],
        precio: json['precio'].toDouble(),
        pesoTotal: json['peso_total'].toDouble(),
        cantAves: json['cant_aves'],
        cantJabas: json['cant_jabas'],
        importeTotal: json['importe_total'].toDouble(),
      );

  Map<String, dynamic> toJson() {
    return {
        'id': id,
        'created_at': dt.format(createdAt),
        'created_by': createdBy,
        'doc_id': docId,
        'producto_id': productoId,
        'producto_nombre': productoNombre,
        'proveedor_id': proveedorId,
        'proveedor_nombre': proveedorNombre,
        'proveedor_estado_cta': proveedorEstadoCta,
        'precio': precio,
        'peso_total': pesoTotal,
        'cant_aves': cantAves,
        'cant_jabas': cantJabas,
        'importe_total': importeTotal
      };
  }

  CompraBeneficiado copyWith({
    ProductoBeneficiado? newProducto,
    double? newPrecio,
    double? newPeso,
    int? newCantAves,
    int? newCantJabas,
    double? newImporte,
  }) =>
      CompraBeneficiado(
          id: id,
          createdAt: createdAt,
          createdBy: createdBy,
          docId: docId,
          productoId: newProducto != null ? newProducto.id! : productoId,
          productoNombre: newProducto != null ? newProducto.nombre : productoNombre,
          proveedorId: proveedorId,
          proveedorNombre: proveedorNombre,
          proveedorEstadoCta: proveedorEstadoCta,
          precio: newPrecio ?? precio,
          pesoTotal: newPeso ?? pesoTotal,
          cantAves: newCantAves ?? cantAves,
          cantJabas: newCantJabas ?? cantJabas,
          importeTotal: newImporte ?? importeTotal);
}
