import 'package:flutter/foundation.dart';
import '../../models/compra_vivo.dart';

class ComprasVivoProv with ChangeNotifier {
  CompraVivo? _compra;
  CompraVivo get compra => _compra!;
  set compra(CompraVivo b) {
    _compra = b;
    notifyListeners();
  }

  bool get existeCompra => _compra != null ? true : false;

  void compraInitState() {
    _compra = null;
    notifyListeners();
  }

  List<CompraVivo>? _compras;
  List<CompraVivo> get compras => _compras ?? [];
  set compras(List<CompraVivo> b) {
    _compras = b;
    notifyListeners();
  }

  double get sumNroAves {
    double sum = 0;
    for (var e in compras) {
      sum += e.cantAves;
    }
    return sum;
  }

  double get sumNroJabas {
    double sum = 0;
    for (var e in compras) {
      sum += e.cantJabas;
    }
    return sum;
  }

  double get sumPeso {
    double sum = 0;
    for (var e in compras) {
      sum += e.pesoTotal;
    }
    return sum;
  }

  double get sumImporte {
    double sum = 0;
    for (var e in compras) {
      sum += e.importeTotal;
    }
    return sum;
  }

  List<CompraVivo>? _comprasResumen;
  List<CompraVivo> get comprasResumen => _comprasResumen ?? [];
  set comprasResumen (List<CompraVivo> l){
    _comprasResumen = l;
    notifyListeners();
  }

  double get sumNroAvesResumen {
    double sum = 0;
    for (var e in comprasResumen) {
      sum += e.cantAves;
    }
    return sum;
  }

  double get sumNroJabasResumen {
    double sum = 0;
    for (var e in comprasResumen) {
      sum += e.cantJabas;
    }
    return sum;
  }

  double get sumPesoResumen {
    double sum = 0;
    for (var e in comprasResumen) {
      sum += e.pesoTotal;
    }
    return sum;
  }

  double get sumImporteResumen {
    double sum = 0;
    for (var e in comprasResumen) {
      sum += e.importeTotal;
    }
    return sum;
  }

  
  List<CompraVivo>? _comprasEstadisticas;
  List<CompraVivo> get comprasEstadisticas => _comprasEstadisticas ?? [];
  set comprasEstadisticas (List<CompraVivo> l){
    _comprasEstadisticas = l;
    notifyListeners();
  }
}
