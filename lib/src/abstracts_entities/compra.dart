abstract class Compra {
  const Compra({
    this.id,
    required this.createdAt,
    required this.createdBy,
    this.docId,
    required this.productoId,
    required this.productoNombre,
    required this.proveedorId,
    required this.proveedorNombre,
    required this.proveedorEstadoCta,
    required this.precio,
    required this.pesoTotal,
    required this.cantAves,
    required this.cantJabas,
    required this.importeTotal,
  });

  final int? id;
  final DateTime createdAt;
  final String createdBy;
  final String? docId;
  final int productoId;
  final String productoNombre;
  final int proveedorId;
  final String proveedorNombre;
  final String proveedorEstadoCta;
  final double precio;
  final double pesoTotal;
  final int cantAves;
  final int cantJabas;
  final double importeTotal;
}
