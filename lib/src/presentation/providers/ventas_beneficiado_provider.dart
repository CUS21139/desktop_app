import 'package:flutter/foundation.dart';
import '/src/models/venta_beneficiado.dart';

class VentasBeneficiadoProv with ChangeNotifier {
  VentaBeneficiado? _venta;
  VentaBeneficiado get venta => _venta!;
  set venta(VentaBeneficiado b) {
    _venta = b;
    notifyListeners();
  }

  bool get existeVenta => _venta != null ? true : false;

  void ventaInitState() {
    _venta = null;
    notifyListeners();
  }

  List<VentaBeneficiado>? _ventas;
  List<VentaBeneficiado> get ventas => _ventas ?? [];
  void setVentas(List<VentaBeneficiado> b, bool anuladas) {
    if (!anuladas) {
      b.removeWhere((e) => e.anulada == 1);
    }
    _ventas = b;
    notifyListeners();
  }

  int get totalJabas {
    int sum = 0;
    for (var e in ventas) {
      sum += e.totalJabas;
    }
    return sum;
  }
  
  int get totalAves {
    int sum = 0;
    for (var e in ventas) {
      sum += e.totalAves;
    }
    return sum;
  }

  double get totalPeso {
    double sum = 0;
    for (var e in ventas) {
      sum += e.totalNeto;
    }
    return sum;
  }

  double get totalImporte {
    double sum = 0;
    for (var e in ventas) {
      sum += e.totalImporte;
    }
    return sum;
  }

  List<VentaBeneficiado>? _ventasResumen;
  List<VentaBeneficiado> get ventasResumen => _ventasResumen ?? [];
  set ventasResumen(List<VentaBeneficiado> l) {
    l.removeWhere((e) => e.anulada == 1);
    _ventasResumen = l;
    notifyListeners();
  }

  int get totalAvesResumen {
    int sum = 0;
    for (var e in ventasResumen) {
      sum += e.totalAves;
    }
    return sum;
  }

  double get totalPesoResumen {
    double sum = 0;
    for (var e in ventasResumen) {
      sum += e.totalNeto;
    }
    return sum;
  }

  double get totalImporteResumen {
    double sum = 0;
    for (var e in ventasResumen) {
      sum += e.totalImporte;
    }
    return sum;
  }

 
  Map<String, int> jabasPorCamal () {
     Map<String, int> result = {};
    for (var e in ventas) {
      if (!result.containsKey(e.camalNombre)) {
        result.putIfAbsent(e.camalNombre, () => e.totalJabas);
      } else {
        result.update(e.camalNombre, (value) => value + e.totalJabas);
      }
    }
    return result;
  }

  List<VentaBeneficiado>? _ventasEstadisticas;
  List<VentaBeneficiado> get ventasEstadisticas => _ventasEstadisticas ?? [];
  set ventasEstadisticas(List<VentaBeneficiado> l) {
    l.removeWhere((e) => e.anulada == 1);
    _ventasEstadisticas = l;
    notifyListeners();
  }
  
  List<VentaBeneficiado>? _ventasEstadisticasPrecios;
  List<VentaBeneficiado> get ventasEstadisticasPrecios => _ventasEstadisticasPrecios ?? [];
  set ventasEstadisticasPrecios(List<VentaBeneficiado> l) {
    l.removeWhere((e) => e.anulada == 1);
    _ventasEstadisticasPrecios = l;
    notifyListeners();
  }
}
