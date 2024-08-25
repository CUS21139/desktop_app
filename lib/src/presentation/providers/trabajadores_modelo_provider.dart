import 'package:flutter/foundation.dart';
import '../../models/trabajador.dart';

class TrabajadoresModeloProv with ChangeNotifier {
  List<Trabajador>? _trabajadoresModelo;
  List<Trabajador> get trabajadoresModelo => _trabajadoresModelo ?? [];
  set trabajadoresModelo(List<Trabajador> b) {
    _trabajadoresModelo = b;
    notifyListeners();
  }

  double totalSalary() {
    double sum = 0;
    for (var trabajador in trabajadoresModelo) {
      sum += trabajador.sueldoDia;
    }
    return sum;
  }
}
