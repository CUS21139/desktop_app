abstract class Producto {
  const Producto({
    this.id,
    required this.createdAt,
    required this.createdBy,
    required this.nombre,
    required this.productCode,
    required this.pesoMin,
    required this.pesoMax,
  });

  final int? id;
  final DateTime createdAt;
  final String createdBy;
  final String nombre;
  final String productCode;
  final double pesoMin;
  final double pesoMax;
}