import 'package:app_desktop/src/abstracts_entities/orden.dart';

import '/src/models/camal.dart';
import '/src/models/cliente.dart';
import 'producto_vivo.dart';
import '/src/utils/date_formats.dart';

class OrdenVivo extends Orden {
  const OrdenVivo({
    super.id,
    required super.createdAt,
    required super.createdBy,
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
    required super.productoPesoMin,
    required super.productoPesoMax,
    required super.precio,
    required super.cantAves,
    required super.cantJabas,
    super.delivered,
    super.deliveredAt,
    super.observacion,
    super.confirm = 0,
    super.confirmAdm = 0,
    super.isSelected = false,
    required super.placa
  });

  int get avesByJaba => cantAves ~/ cantJabas;

  factory OrdenVivo.fromJson(Map<String, dynamic> json) {
    return OrdenVivo(
        id: json['id'],
        createdAt: DateTime.parse(json['created_at']),
        createdBy: json['created_by'],
        zonaCode: json['zona_code'],
        pesadorId: json['pesador_id'],
        pesadorNombre: json['pesador_nombre'],
        clienteId: json['cliente_id'],
        clienteNombre: json['cliente_nombre'],
        clienteCelular: json['cliente_celular'],
        clienteEstadoCta: json['cliente_estado_cta'],
        camalId: json['camal_id'],
        camalNombre: json['camal_nombre'],
        productoId: json['producto_id'],
        productoNombre: json['producto_nombre'],
        productoPesoMin: json['producto_peso_min'].toDouble(),
        productoPesoMax: json['producto_peso_max'].toDouble(),
        precio: json['precio'].toDouble(),
        cantAves: json['cant_aves'],
        cantJabas: json['cant_jabas'],
        delivered: json['delivered'],
        deliveredAt: DateTime.tryParse(json['delivered_at'] ?? ''),
        observacion: json['observacion'],
        confirm: json['confirmada'],
        confirmAdm: json['confirm_adm'] ?? 0,
        placa: json['placa']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': dt.format(createdAt),
      'created_by': createdBy,
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
      'producto_peso_min': productoPesoMin,
      'producto_peso_max': productoPesoMax,
      'precio': precio,
      'cant_aves': cantAves,
      'cant_jabas': cantJabas,
      'delivered': delivered,
      'delivered_at': deliveredAt != null ? dt.format(deliveredAt!) : null,
      'observacion': observacion,
      'confirmada': confirm,
      'confirm_adm': confirmAdm,
      'placa': placa,
    };
  }

  OrdenVivo copyWith({
    DateTime? newCratedAt,
    Cliente? newCliente,
    Camal? newCamal,
    ProductoVivo? newProducto,
    double? newPrecio,
    int? newCantAves,
    int? newCantJabas,
    int? newDelivered,
    DateTime? newDeliveredAt,
    String? newObservacion,
    int? newConfirm,
    int? newConfirmAdm,
    bool? newSelected,
    String? newPlaca,
  }) =>
      OrdenVivo(
        id: id,
        createdAt: newCratedAt ?? createdAt,
        createdBy: createdBy,
        zonaCode: zonaCode,
        pesadorId: pesadorId,
        pesadorNombre: pesadorNombre,
        clienteId: newCliente != null ? newCliente.id! : clienteId,
        clienteNombre: newCliente != null ? newCliente.nombre : clienteNombre,
        clienteCelular: newCliente != null ? newCliente.celular.toString() : clienteCelular,
        clienteEstadoCta: newCliente != null ? newCliente.estadoCta! : clienteEstadoCta,
        camalId: newCamal != null ? newCamal.id! : camalId,
        camalNombre: newCamal != null ? newCamal.nombre : camalNombre,
        productoId: newProducto != null ? newProducto.id! : productoId,
        productoNombre: newProducto != null ? newProducto.nombre : productoNombre,
        productoPesoMin: newProducto != null ? newProducto.pesoMin : productoPesoMin,
        productoPesoMax: newProducto != null ? newProducto.pesoMax : productoPesoMax,
        precio: newPrecio ?? precio,
        cantAves: newCantAves ?? cantAves,
        cantJabas: newCantJabas ?? cantJabas,
        delivered: newDelivered ?? delivered,
        deliveredAt: newDeliveredAt ?? deliveredAt,
        observacion: newObservacion ?? observacion,
        confirm: newConfirm ?? confirm,
        confirmAdm: newConfirmAdm ?? confirmAdm,
        isSelected: newSelected ?? isSelected,
        placa: newPlaca ?? placa,
      );
}
