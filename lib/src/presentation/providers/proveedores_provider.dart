import 'package:flutter/foundation.dart';
import '../../models/proveedor.dart';

class ProveedoresProv with ChangeNotifier {

  Proveedor? _proveedor;
  Proveedor get proveedor => _proveedor!;
  set proveedor (Proveedor b){
    _proveedor = b;
    notifyListeners();
  }

  bool get existeproveedor => _proveedor != null ? true: false;

  void proveedorInitState () {
    _proveedor = null;
    notifyListeners();
  }

  List<Proveedor>? _proveedores;
  List<Proveedor> get proveedores => _proveedores ?? [];
  set proveedores (List<Proveedor> b){
    _proveedores = b;
    notifyListeners();
  }

  double get totalSaldo {
    double sum = 0;
    for (var e in proveedores) {
      sum += e.saldo!;
    }
    return sum;
  }

}