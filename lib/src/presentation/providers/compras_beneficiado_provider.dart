import 'package:flutter/foundation.dart';
import '../../models/compra_beneficiado.dart';

class ComprasBeneficiadoProv with ChangeNotifier {
  CompraBeneficiado? _compra;
  CompraBeneficiado get compra => _compra!;
  set compra(CompraBeneficiado b) {
    _compra = b;
    notifyListeners();
  }

  bool get existeCompra => _compra != null ? true : false;

  void compraInitState() {
    _compra = null;
    notifyListeners();
  }

  List<CompraBeneficiado>? _compras;
  List<CompraBeneficiado> get compras => _compras ?? [];
  set compras(List<CompraBeneficiado> b) {
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

  List<CompraBeneficiado>? _comprasResumen;
  List<CompraBeneficiado> get comprasResumen => _comprasResumen ?? [];
  set comprasResumen (List<CompraBeneficiado> l){
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

  
  List<CompraBeneficiado>? _comprasEstadisticas;
  List<CompraBeneficiado> get comprasEstadisticas => _comprasEstadisticas ?? [];
  set comprasEstadisticas (List<CompraBeneficiado> l){
    _comprasEstadisticas = l;
    notifyListeners();
  }
}
