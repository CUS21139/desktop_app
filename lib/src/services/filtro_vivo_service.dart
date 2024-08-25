import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '/src/models/camal.dart';
import '/src/models/cliente.dart';
import '/src/models/pesador.dart';
import '../models/producto_vivo.dart';
import '/src/models/proveedor.dart';
import '/src/models/zona.dart';

import '/src/presentation/providers/ayer_hoy_provider.dart';
import '../presentation/providers/compras_vivo_provider.dart';
import '../presentation/providers/ordenes_modelo_vivo_provider.dart';
import '../presentation/providers/ordenes_vivo_provider.dart';
import '/src/presentation/providers/usuarios_provider.dart';
import '../presentation/providers/ventas_vivo_provider.dart';

import 'compras_vivos_service.dart';
import 'ordenes_modelo_vivo_service.dart';
import 'ordenes_vivo_service.dart';
import 'ventas_vivo_service.dart';

class FiltroVivoService {
  final compraServ = ComprasVivosService();
  final ordenServ = OrdenesVivoService();
  final ordenModeloServ = OrdenesModeloVivosService();
  final ventaServ = VentasVivoService();

  Future<void> filtrarCompras(
    BuildContext context,
    DateTime fecha, {
    Proveedor? proveedor,
    ProductoVivo? producto,
  }) async {
    final token = Provider.of<UsuariosProv>(context, listen: false).token;
    final compraProv = Provider.of<ComprasVivoProv>(context, listen: false);
    final ini = DateTime(fecha.year, fecha.month, fecha.day, 0, 0, 0);
    final fin = DateTime(fecha.year, fecha.month, fecha.day, 23, 59, 59);

    try {
      final list = await compraServ.getCompras(token, ini, fin);
      if (proveedor != null) {
        list.retainWhere((e) => e.proveedorId == proveedor.id);
      }
      if (producto != null) {
        list.retainWhere((e) => e.productoId == producto.id);
      }
      list.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      compraProv.compras = list;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> filtrarOrdenes(
    BuildContext context,
    DateTime fecha, {
    Zona? zona,
    Pesador? pesador,
    Cliente? cliente,
    ProductoVivo? producto,
    Camal? camal,
  }) async {
    final token = Provider.of<UsuariosProv>(context, listen: false).token;
    final ordenProv = Provider.of<OrdenesVivoProv>(context, listen: false);
    final ini = DateTime(fecha.year, fecha.month, fecha.day, 0, 0, 0);
    final fin = DateTime(fecha.year, fecha.month, fecha.day, 23, 59, 59);

    try {
      final list = await ordenServ.getOrdenes(token, ini, fin);
      if (zona != null) {
        list.retainWhere((e) => e.zonaCode == zona.zonaCode);
      }
      if (pesador != null) {
        list.retainWhere((e) => e.pesadorId == pesador.id);
      }
      if (cliente != null) {
        list.retainWhere((e) => e.clienteId == cliente.id);
      }
      if (producto != null) {
        list.retainWhere((e) => e.productoId == producto.id);
      }
      if (camal != null) {
        list.retainWhere((e) => e.camalId == camal.id);
      }
      list.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      ordenProv.ordenes = list;
      ordenProv.ordenesResumen = list;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> filtrarOrdenesModelo(
    BuildContext context, {
    Zona? zona,
    Pesador? pesador,
    Cliente? cliente,
    ProductoVivo? producto,
    Camal? camal,
  }) async {
    final token = Provider.of<UsuariosProv>(context, listen: false).token;
    final ordenProv = Provider.of<OrdenesModeloVivoProv>(context, listen: false);

    try {
      final list = await ordenModeloServ.getOrdenes(token);
      if (zona != null) {
        list.retainWhere((e) => e.zonaCode == zona.zonaCode);
      }
      if (pesador != null) {
        list.retainWhere((e) => e.pesadorId == pesador.id);
      }
      if (cliente != null) {
        list.retainWhere((e) => e.clienteId == cliente.id);
      }
      if (producto != null) {
        list.retainWhere((e) => e.productoId == producto.id);
      }
      if (camal != null) {
        list.retainWhere((e) => e.camalId == camal.id);
      }
      list.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      ordenProv.ordenes = list;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> filtrarVentas(
    BuildContext context,
    DateTime fecha, {
    Zona? zona,
    Pesador? pesador,
    Cliente? cliente,
    ProductoVivo? producto,
    Camal? camal,
  }) async {
    final token = Provider.of<UsuariosProv>(context, listen: false).token;
    final ventaProv = Provider.of<VentasVivoProv>(context, listen: false);
    final ayerHoyProv = Provider.of<AyerHoyProv>(context, listen: false);
    final ini = DateTime(fecha.year, fecha.month, fecha.day, 0, 0, 0);
    final fin = DateTime(fecha.year, fecha.month, fecha.day, 23, 59, 59);

    try {
      final list = await ventaServ.getVentas(token, ini, fin);
      if (zona != null) {
        list.retainWhere((e) => e.zonaCode == zona.zonaCode);
      }
      if (pesador != null) {
        list.retainWhere((e) => e.pesadorId == pesador.id);
      }
      if (cliente != null) {
        list.retainWhere((e) => e.clienteId == cliente.id);
      }
      if (producto != null) {
        list.retainWhere((e) => e.productoId == producto.id);
      }
      if (camal != null) {
        list.retainWhere((e) => e.camalId == camal.id);
      }
      list.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      ventaProv.setVentas(list, ayerHoyProv.anuladas);
      ventaProv.ventaInitState();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> filtrarResumen(BuildContext context, DateTime fecha) async {
    final token = Provider.of<UsuariosProv>(context, listen: false).token;
    final ventaProv = Provider.of<VentasVivoProv>(context, listen: false);
    final compraProv = Provider.of<ComprasVivoProv>(context, listen: false);
    final ini = DateTime(fecha.year, fecha.month, fecha.day, 0, 0, 0);
    final fin = DateTime(fecha.year, fecha.month, fecha.day, 23, 59, 59);

    try {
      final ventas = await ventaServ.getVentas(token, ini, fin);
      final compras = await compraServ.getCompras(token, ini, fin);
      ventas.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      ventaProv.ventasResumen = ventas;
      compraProv.comprasResumen = compras;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
