import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '/src/models/camal.dart';
import '/src/models/cliente.dart';
import '/src/models/pesador.dart';
import '/src/models/producto_beneficiado.dart';
import '/src/models/proveedor.dart';
import '/src/models/zona.dart';

import '../presentation/providers/ayer_hoy_vivo_provider.dart';
import '/src/presentation/providers/compras_beneficiado_provider.dart';
import '/src/presentation/providers/ordenes_beneficiado_provider.dart';
import '/src/presentation/providers/ordenes_modelo_beneficiado_provider.dart';
import '/src/presentation/providers/ventas_beneficiado_provider.dart';
import '/src/presentation/providers/usuarios_provider.dart';

import '/src/services/compras_beneficiado_service.dart';
import '/src/services/ordenes_beneficiado_service.dart';
import '/src/services/ordenes_modelo_beneficiado_service.dart';
import '/src/services/ventas_beneficiado_service.dart';


class FiltroBeneficiadoService {
  final compraServ = ComprasBeneficiadoService();
  final ordenServ = OrdenesBeneficiadoService();
  final ordenModeloServ = OrdenesModeloBeneficiadoService();
  final ventaServ = VentasBeneficiadoService();

  Future<void> filtrarCompras(
    BuildContext context,
    DateTime fecha, {
    Proveedor? proveedor,
    ProductoBeneficiado? producto,
  }) async {
    final token = Provider.of<UsuariosProv>(context, listen: false).token;
    final compraProv = Provider.of<ComprasBeneficiadoProv>(context, listen: false);
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
    ProductoBeneficiado? producto,
    Camal? camal,
  }) async {
    final token = Provider.of<UsuariosProv>(context, listen: false).token;
    final ordenProv = Provider.of<OrdenesBeneficiadoProv>(context, listen: false);
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
    ProductoBeneficiado? producto,
    Camal? camal,
  }) async {
    final token = Provider.of<UsuariosProv>(context, listen: false).token;
    final ordenProv = Provider.of<OrdenesModeloBeneficiadoProv>(context, listen: false);

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
    ProductoBeneficiado? producto,
    Camal? camal,
  }) async {
    final token = Provider.of<UsuariosProv>(context, listen: false).token;
    final ventaProv = Provider.of<VentasBeneficiadoProv>(context, listen: false);
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
    final ventaProv = Provider.of<VentasBeneficiadoProv>(context, listen: false);
    final compraProv = Provider.of<ComprasBeneficiadoProv>(context, listen: false);
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
