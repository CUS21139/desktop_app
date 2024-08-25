import 'package:flutter/foundation.dart';
import '/src/models/proveedor.dart';
import '../../models/estado_proveedor_mov.dart';

class EstadoProveedorProv with ChangeNotifier {
  Proveedor? _proveedorSelect;
  Proveedor get proveedorSelect => _proveedorSelect!;
  set proveedorSelect(Proveedor b) {
    _proveedorSelect = b;
    notifyListeners();
  }

  bool get existeProveedorSelect => _proveedorSelect != null ? true : false;

  List<EstadoProveedorMov>? _movimientos;
  List<EstadoProveedorMov> get movimientos => _movimientos ?? [];
  set movimientos(List<EstadoProveedorMov> m) {
    _movimientos = m;
    notifyListeners();
  }

  EstadoProveedorMov? _movSelect;
  EstadoProveedorMov get movSelect => _movSelect!;
  set movSelect (EstadoProveedorMov mov) {
    _movSelect = mov;
    notifyListeners();
  }
  bool get existeMovSelect => _movSelect != null ? true : false;

  void movSelectInitState () {
    _movSelect = null;
    notifyListeners();
  }
}
