abstract class Orden {
  const Orden({
    this.id,
    required this.createdAt,
    required this.createdBy,
    required this.zonaCode,
    required this.pesadorId,
    required this.pesadorNombre,
    required this.clienteId,
    required this.clienteNombre,
    required this.clienteCelular,
    required this.clienteEstadoCta,
    required this.camalId,
    required this.camalNombre,
    required this.productoId,
    required this.productoNombre,
    required this.productoPesoMin,
    required this.productoPesoMax,
    required this.precio,
    required this.cantAves,
    required this.cantJabas,
    this.delivered,
    this.deliveredAt,
    this.observacion,
    this.confirm = 0,
    this.confirmAdm = 0,
    this.isSelected = false,
    required this.placa
  });

  final int? id;
  final DateTime createdAt;
  final String createdBy;
  final String zonaCode;
  final int pesadorId;
  final String pesadorNombre;
  final int clienteId;
  final String clienteNombre;
  final String clienteCelular;
  final String clienteEstadoCta;
  final int camalId;
  final String camalNombre;
  final int productoId;
  final String productoNombre;
  final double productoPesoMin;
  final double productoPesoMax;
  final double precio;
  final int cantAves;
  final int cantJabas;
  final int? delivered;
  final DateTime? deliveredAt;
  final String? observacion;
  final int? confirm;
  final int confirmAdm;
  final bool isSelected;
  final String placa;
}