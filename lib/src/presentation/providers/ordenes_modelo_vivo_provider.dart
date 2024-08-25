import 'package:flutter/foundation.dart';
import '../../models/ordenes_vivo.dart';

class OrdenesModeloVivoProv with ChangeNotifier {
  OrdenVivo? _orden;
  OrdenVivo get orden => _orden!;
  set orden(OrdenVivo b) {
    _orden = b;
    notifyListeners();
  }

  bool get existeOrden => _orden != null ? true : false;

  void ordenInitState() {
    _orden = null;
    notifyListeners();
  }

  List<OrdenVivo>? _ordenes = [];
  List<OrdenVivo> get ordenes => _ordenes ?? [];
  set ordenes(List<OrdenVivo> b) {
    _ordenes = b;
    notifyListeners();
  }

  int get selectCount {
    int count = 0;
    for (var e in ordenes) {
      if (e.isSelected) count++;
    }
    return count;
  }

  void actualizarSeleccion(int index) {
    final currentOrden = ordenes.removeAt(index);
    ordenes.insert(
      index,
      currentOrden.copyWith(newSelected: !currentOrden.isSelected),
    );
    notifyListeners();
  }

  double get sumNroAves {
    double sum = 0;
    for (var e in ordenes) {
      sum += e.cantAves;
    }
    return sum;
  }

  double get sumNroJabas {
    double sum = 0;
    for (var e in ordenes) {
      sum += e.cantJabas;
    }
    return sum;
  }
}
