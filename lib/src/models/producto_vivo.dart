import 'package:app_desktop/src/abstracts_entities/producto.dart';

import '/src/utils/date_formats.dart';

class ProductoVivo extends Producto {
  const ProductoVivo({
    super.id,
    required super.createdAt,
    required super.createdBy,
    required super.nombre,
    required super.productCode,
    required super.pesoMin,
    required super.pesoMax,
  });

  double get promedio => (pesoMax + pesoMin) / 2;

  bool inRange(double min, double max) => min < promedio && max > promedio;

  factory ProductoVivo.fromJson(Map<String, dynamic> json) => ProductoVivo(
        id: json['id'],
        createdAt: DateTime.parse(json['created_at']),
        createdBy: json['created_by'],
        nombre: json['nombre'],
        productCode: json['product_code'],
        pesoMin: json['peso_min'].toDouble(),
        pesoMax: json['peso_max'].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'created_at': dt.format(createdAt),
        'created_by': createdBy,
        'nombre': nombre,
        'product_code': productCode,
        'peso_min': pesoMin,
        'peso_max': pesoMax
      };

  ProductoVivo copyWith({String? newNombre, double? newPesoMin, double? newPesoMax}) => ProductoVivo(
        id: id,
        createdAt: createdAt,
        createdBy: createdBy,
        nombre: newNombre ?? nombre,
        productCode: productCode,
        pesoMin: newPesoMin ?? pesoMin,
        pesoMax: newPesoMax ?? pesoMax,
      );
}