import 'package:flutter/foundation.dart';
import '/src/models/trabajador_registro.dart';

class TrabRegistroProv with ChangeNotifier {
  List<TrabajadorRegistro>? _registros;
  List<TrabajadorRegistro> get registros => _registros ?? [];
  set registros(List<TrabajadorRegistro> l) {
    _registros = l;
    notifyListeners();
  }

  double totalSalary() {
    double sum = 0;
    for (var registro in registros) {
      sum += registro.monto;
    }
    return sum;
  }
}
