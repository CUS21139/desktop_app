import 'package:flutter/foundation.dart';
import '/src/models/trabajador.dart';
import '../../models/estado_trabajador_mov.dart';

class EstadoTrabajadorProv with ChangeNotifier {
  Trabajador? _trabajadorSelect;
  Trabajador get trabajadorSelect => _trabajadorSelect!;
  set trabajadorSelect(Trabajador b) {
    _trabajadorSelect = b;
    notifyListeners();
  }

  bool get existeTrabajadorSelect => _trabajadorSelect != null ? true : false;

  List<EstadoTrabajadorMov>? _movimientos;
  List<EstadoTrabajadorMov> get movimientos => _movimientos ?? [];
  set movimientos(List<EstadoTrabajadorMov> m) {
    _movimientos = m;
    notifyListeners();
  }

  EstadoTrabajadorMov? _movSelect;
  EstadoTrabajadorMov get movSelect => _movSelect!;
  set movSelect (EstadoTrabajadorMov mov) {
    _movSelect = mov;
    notifyListeners();
  }
  bool get existeMovSelect => _movSelect != null ? true : false;

  void movSelectInitState () {
    _movSelect = null;
    notifyListeners();
  }
}
