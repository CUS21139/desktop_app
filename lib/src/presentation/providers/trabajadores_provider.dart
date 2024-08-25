import 'package:flutter/foundation.dart';
import '../../models/trabajador.dart';

class TrabajadoresProv with ChangeNotifier {

  Trabajador? _trabajador;
  Trabajador get trabajador => _trabajador!;
  set trabajador (Trabajador b){
    _trabajador = b;
    notifyListeners();
  }

  bool get existetrabajador => _trabajador != null ? true: false;

  void trabajadorInitState () {
    _trabajador = null;
    notifyListeners();
  }

  List<Trabajador>? _trabajadores;
  List<Trabajador> get trabajadores => _trabajadores ?? [];
  set trabajadores (List<Trabajador> b){
    _trabajadores = b;
    notifyListeners();
  }

  double get totalSaldo {
    double sum = 0;
    for (var e in trabajadores) {
      sum += e.saldo!;
    }
    return sum;
  }

}