import 'package:flutter/foundation.dart';
import '/src/models/ordenes_beneficiado.dart';

class OrdenesBeneficiadoProv with ChangeNotifier {
  OrdenBeneficiado? _orden;
  OrdenBeneficiado get orden => _orden!;
  set orden(OrdenBeneficiado b) {
    _orden = b;
    notifyListeners();
  }

  bool get existeOrden => _orden != null ? true : false;

  void ordenInitState() {
    _orden = null;
    notifyListeners();
  }

  List<OrdenBeneficiado>? _ordenes = [];
  List<OrdenBeneficiado> get ordenes => _ordenes ?? [];
  set ordenes(List<OrdenBeneficiado> b) {
    _ordenes = b;
    notifyListeners();
  }

  List<OrdenBeneficiado> ordenesResumen = [];

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
