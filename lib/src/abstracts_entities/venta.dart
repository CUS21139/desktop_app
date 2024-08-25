import '/src/models/pesaje.dart';

abstract class Venta {
  const Venta({
    this.id,
    required this.createdAt,
    required this.createdBy,
    required this.ordenId,
    required this.ordenDate,
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
    required this.precio,
    required this.pesajes,
    required this.totalJabas,
    required this.totalBruto,
    required this.totalTara,
    required this.totalNeto,
    required this.totalAves,
    required this.totalPromedio,
    required this.totalImporte,
    this.anulada,
    this.observacion,
    required this.placa,
  });

  final int? id;
  final DateTime createdAt;
  final String createdBy;
  final int ordenId;
  final DateTime ordenDate;
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
  final double precio;
  final List<Pesaje> pesajes;
  final int totalJabas;
  final double totalBruto;
  final double totalTara;
  final double totalNeto;
  final int totalAves;
  final double totalPromedio;
  final double totalImporte;
  final int? anulada;
  final String? observacion;
  final String placa;
}