import '../models/compra_vivo.dart';
import '../models/ordenes_vivo.dart';
import '../models/producto_vivo.dart';
import '../models/venta_vivo.dart';

class TableResumenCtrl {
  static Map<String, Map<String, int>> mapResumenOrdenCompra(
      List<CompraVivo> compras, List<OrdenVivo> ordenes) {
    Map<String, Map<String, int>> result = {};
    for (var e in compras) {
      if (!result.containsKey(e.productoNombre)) {
        result.putIfAbsent(
          e.productoNombre,
          () => {'compra': e.cantAves, 'venta': 0},
        );
      } else {
        result.update(
          e.productoNombre,
          (value) =>
              {'compra': ((value['compra'] ?? 0) + e.cantAves), 'venta': 0},
        );
      }
    }
    for (var e in ordenes) {
      if (!result.containsKey(e.productoNombre)) {
        result.putIfAbsent(
          e.productoNombre,
          () => {'compra': 0, 'venta': e.cantAves},
        );
      } else {
        result.update(
          e.productoNombre,
          (value) => {
            'compra': value['compra']!,
            'venta': ((value['venta'] ?? 0) + e.cantAves)
          },
        );
      }
    }
    return result;
  }

  static Map<String, Map<String, dynamic>> mapResumenVentaCompra({
    required List<CompraVivo> compras,
    required List<VentaVivo> ventas,
    required List<ProductoVivo> productos,
  }) {
    Map<String, Map<String, dynamic>> result = {};
    ventas.removeWhere((e) => e.anulada == 1);

    for (var e in productos) {
      result.putIfAbsent(
        e.nombre,
        () => {
          'compra': {'cantidad': 0, 'peso': 0, 'importe': 0},
          'venta': {'cantidad': 0, 'peso': 0, 'importe': 0},
        },
      );
    }
    for (var e in compras) {
      final compraMap = result[e.productoNombre];
      if (compraMap != null) {
        compraMap.update(
          'compra',
          (value) => {
            'cantidad': ((value['cantidad'] ?? 0) + e.cantAves),
            'peso': ((value['peso'] ?? 0) + e.pesoTotal),
            'importe': ((value['importe'] ?? 0) + e.importeTotal),
          },
        );
      }
    }
    for (var e in ventas) {
      final compraMap = result[e.productoNombre];
      if (compraMap != null) {
        compraMap.update(
          'venta',
          (value) => {
            'cantidad': ((value['cantidad'] ?? 0) + e.totalAves),
            'peso': ((value['peso'] ?? 0) + e.totalNeto),
            'importe': ((value['importe'] ?? 0) + e.totalImporte),
          },
        );
      }
    }

    result.removeWhere((key, value) {
      return value['compra']['cantidad'] == 0 && value['venta']['cantidad'] == 0;
    });

    return result;
  }
}
