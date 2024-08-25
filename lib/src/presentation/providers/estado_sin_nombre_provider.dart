import 'package:flutter/foundation.dart';
import '/src/models/estado_sin_nombre_mov.dart';

class EstadoSinNombreProv with ChangeNotifier {
  List<EstadoSinNombreMov>? _movimientos;
  List<EstadoSinNombreMov> get movimientos => _movimientos ?? [];
  set movimientos(List<EstadoSinNombreMov> m) {
    _movimientos = m;
    notifyListeners();
  }

  double getTotalSaldo() {
    double sum = 0;
    for (var e in movimientos) {
      sum += e.saldo;
    }
    return sum;
  }

  EstadoSinNombreMov? _movSelect;
  EstadoSinNombreMov get movSelect => _movSelect!;
  set movSelect(EstadoSinNombreMov mov) {
    _movSelect = mov;
    notifyListeners();
  }

  bool get existeMovSelect => _movSelect != null ? true : false;

  bool get isIngresoSelect {
    if(existeMovSelect){
      if(_movSelect!.ingreso == 0){
        return false;
      }
      if(_movSelect!.asignada){
        return false;
      }
      return true;
    }
    return false;
  }

  void movSelectInitState() {
    _movSelect = null;
    notifyListeners();
  }
}
