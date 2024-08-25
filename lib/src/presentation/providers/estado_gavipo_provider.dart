import 'package:flutter/foundation.dart';
import '/src/models/estado_gavipo_mov.dart';

class EstadoGavipoProv with ChangeNotifier {

  List<EstadoGavipoMov>? _movimientos;
  List<EstadoGavipoMov> get movimientos => _movimientos ?? [];
  set movimientos (List<EstadoGavipoMov> m) {
    _movimientos = m;
    notifyListeners();
  }

  double getTotalSaldo () {
    double sum = 0;
    for (var e in movimientos) {
      sum += e.saldo;
    }
    return sum;
  }

  EstadoGavipoMov? _movSelect;
  EstadoGavipoMov get movSelect => _movSelect!;
  set movSelect (EstadoGavipoMov mov) {
    _movSelect = mov;
    notifyListeners();
  }
  bool get existeMovSelect => _movSelect != null ? true : false;

  void movSelectInitState () {
    _movSelect = null;
    notifyListeners();
  }
}