import 'dart:convert';

import 'package:app_desktop/src/abstracts_entities/venta.dart';

import '/src/presentation/utils/round_number.dart';

import '/src/models/pesaje.dart';
import '/src/utils/date_formats.dart';

class VentaBeneficiado extends Venta {
  const VentaBeneficiado({
    super.id,
    required super.createdAt,
    required super.createdBy,
    required super.ordenId,
    required super.ordenDate,
    required super.zonaCode,
    required super.pesadorId,
    required super.pesadorNombre,
    required super.clienteId,
    required super.clienteNombre,
    required super.clienteCelular,
    required super.clienteEstadoCta,
    required super.camalId,
    required super.camalNombre,
    required super.productoId,
    required super.productoNombre,
    required super.precio,
    required this.precioPelado,
    required super.pesajes,
    required super.totalJabas,
    required super.totalBruto,
    required super.totalTara,
    required super.totalNeto,
    required super.totalAves,
    required super.totalPromedio,
    required super.totalImporte,
    super.anulada,
    super.observacion,
    required super.placa,
  });

  final double precioPelado;

  factory VentaBeneficiado.fromJson(Map<String, dynamic> jsonData) => VentaBeneficiado(
        id: jsonData['id'],
        createdAt: DateTime.parse(jsonData['created_at']),
        createdBy: jsonData['created_by'],
        ordenId: jsonData['orden_id'],
        ordenDate: DateTime.parse(jsonData['orden_date']),
        zonaCode: jsonData['zona_code'],
        pesadorId: jsonData['pesador_id'],
        pesadorNombre: jsonData['pesador_nombre'],
        clienteId: jsonData['cliente_id'],
        clienteNombre: jsonData['cliente_nombre'],
        clienteCelular: jsonData['cliente_celular'],
        clienteEstadoCta: jsonData['cliente_estado_cta'],
        camalId: jsonData['camal_id'],
        camalNombre: jsonData['camal_nombre'],
        productoId: jsonData['producto_id'],
        productoNombre: jsonData['producto_nombre'],
        precio: jsonData['precio'].toDouble(),
        precioPelado: jsonData['precio_pelado'].toDouble(),
        pesajes: List<Pesaje>.from(
            json.decode(jsonData['pesajes']).map((x) => Pesaje.fromJson(x))),
        totalJabas: jsonData['total_jabas'],
        totalBruto: jsonData['total_bruto'].toDouble(),
        totalTara: jsonData['total_tara'].toDouble(),
        totalNeto: jsonData['total_neto'].toDouble(),
        totalAves: jsonData['total_aves'],
        totalPromedio: jsonData['total_promedio'].toDouble(),
        totalImporte: jsonData['total_importe'].toDouble(),
        anulada: jsonData['anulada'],
        observacion: jsonData['observacion'],
        placa: jsonData['placa'],
      );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': dt.format(createdAt),
      'created_by': createdBy,
      'orden_id': ordenId,
      'orden_date': dt.format(ordenDate),
      'zona_code': zonaCode,
      'pesador_id': pesadorId,
      'pesador_nombre': pesadorNombre,
      'cliente_id': clienteId,
      'cliente_nombre': clienteNombre,
      'cliente_celular': clienteCelular,
      'cliente_estado_cta': clienteEstadoCta,
      'camal_id': camalId,
      'camal_nombre': camalNombre,
      'producto_id': productoId,
      'producto_nombre': productoNombre,
      'precio': precio,
      'pesajes':
          json.encode(List<dynamic>.from(pesajes.map((e) => e.toJson()))),
      'total_jabas': totalJabas,
      'total_bruto': totalBruto,
      'total_tara': totalTara,
      'total_neto': totalNeto,
      'total_aves': totalAves,
      'total_promedio': totalPromedio,
      'total_importe': totalImporte,
      'anulada': anulada,
      'observacion': observacion,
      'placa': placa
    };
  }

  VentaBeneficiado insertarPesajeDescuento(Pesaje pesaje) {
    pesajes.add(pesaje);
    final newNeto = totalNeto + pesaje.neto;
    final newAves = totalAves + pesaje.nroAves;
    final newPromedio = newNeto / newAves;
    final newTotal = totalImporte + pesaje.importe;
    return VentaBeneficiado(
        id: id,
        createdAt: createdAt,
        createdBy: createdBy,
        ordenId: ordenId,
        ordenDate: ordenDate,
        zonaCode: zonaCode,
        camalId: camalId,
        camalNombre: camalNombre,
        pesadorId: pesadorId,
        pesadorNombre: pesadorNombre,
        clienteId: clienteId,
        clienteNombre: clienteNombre,
        clienteCelular: clienteCelular,
        clienteEstadoCta: clienteEstadoCta,
        productoId: productoId,
        productoNombre: productoNombre,
        precio: precio,
        precioPelado: precioPelado,
        pesajes: pesajes,
        totalJabas: totalJabas,
        totalBruto: totalBruto,
        totalTara: totalTara,
        totalNeto: newNeto,
        totalAves: newAves,
        totalPromedio: roundNumber(newPromedio),
        totalImporte: newTotal,
        placa: placa);
  }

  VentaBeneficiado editarPrecio(double newPrecio) {
    List<Pesaje> newPesajes = [];
    for (var e in pesajes) {
      final newP = e.copyWith(newImporte: e.neto * newPrecio);
      newPesajes.add(newP);
    }
    return VentaBeneficiado(
      id: id,
      createdAt: createdAt,
      createdBy: createdBy,
      ordenId: ordenId,
      ordenDate: ordenDate,
      zonaCode: zonaCode,
      pesadorId: pesadorId,
      pesadorNombre: pesadorNombre,
      clienteId: clienteId,
      clienteNombre: clienteNombre,
      clienteCelular: clienteCelular,
      clienteEstadoCta: clienteEstadoCta,
      camalId: camalId,
      camalNombre: camalNombre,
      productoId: productoId,
      productoNombre: productoNombre,
      precio: newPrecio,
      precioPelado: precioPelado,
      pesajes: newPesajes,
      totalJabas: totalJabas,
      totalBruto: totalBruto,
      totalTara: totalTara,
      totalNeto: totalNeto,
      totalAves: totalAves,
      totalPromedio: totalPromedio,
      totalImporte: totalNeto * newPrecio,
      placa: placa,
    );
  }

  VentaBeneficiado copyWith({
    double? newPrecio,
    double? newPrecioPelado,
    List<Pesaje>? newPesajes,
    int? newCantAves,
    double? newTotalBruto,
    double? newTotalTara,
    double? newTotalNeto,
    int? newCantJabas,
    double? newTotalPromedio,
    double? newTotalImporte,
    int? newAnulada,
    String? newPlaca,
  }) =>
      VentaBeneficiado(
        id: id,
        createdAt: createdAt,
        createdBy: createdBy,
        ordenId: ordenId,
        ordenDate: ordenDate,
        zonaCode: zonaCode,
        pesadorId: pesadorId,
        pesadorNombre: pesadorNombre,
        clienteId: clienteId,
        clienteNombre: clienteNombre,
        clienteCelular: clienteCelular,
        clienteEstadoCta: clienteEstadoCta,
        camalId: camalId,
        camalNombre: camalNombre,
        productoId: productoId,
        productoNombre: productoNombre,
        precio: newPrecio ?? precio,
        precioPelado: newPrecioPelado ?? precioPelado,
        pesajes: newPesajes ?? pesajes,
        totalJabas: newCantJabas ?? totalJabas,
        totalBruto: newTotalBruto ?? totalBruto,
        totalTara: newTotalTara ?? totalTara,
        totalNeto: newTotalNeto ?? totalNeto,
        totalAves: newCantAves ?? totalAves,
        totalPromedio: totalPromedio,
        totalImporte: newTotalImporte ?? totalImporte,
        anulada: newAnulada ?? anulada,
        observacion: observacion,
        placa: newPlaca ?? placa,
      );
}
