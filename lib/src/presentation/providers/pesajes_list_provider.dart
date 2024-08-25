import 'package:flutter/foundation.dart';
import '../../models/pesaje.dart';

class PesajesProv with ChangeNotifier {

  List<Pesaje> pesajes = [];

  void addPesaje (Pesaje p) {
    pesajes.add(p);
    notifyListeners();
  }
  
  void deletePesaje (Pesaje p) {
    pesajes.remove(p);
    notifyListeners();
  }

  void clearList () {
    pesajes.clear();
    notifyListeners();
  }

  int get totalJabas {
    int sum = 0;
    for (var e in pesajes) {
      sum += e.nroJabas;
    }
    return sum;
  } 
  
  int get totalAves {
    int sum = 0;
    for (var e in pesajes) {
      sum += e.nroAves;
    }
    return sum;
  } 
  
  double get totalBruto {
    double sum = 0;
    for (var e in pesajes) {
      sum += e.bruto;
    }
    return sum;
  } 
  
  double get totalTara {
    double sum = 0;
    for (var e in pesajes) {
      sum += e.tara;
    }
    return sum;
  } 
  
  double get totalNeto {
    double sum = 0;
    for (var e in pesajes) {
      sum += e.neto;
    }
    return sum;
  } 
  
  double get totalPromedio {
    double sum = 0;
    for (var e in pesajes) {
      sum += e.promedio;
    }
    final promedio = sum/pesajes.length;
    return promedio.isNaN ? 0 : promedio;
  } 
  
  double get totalImporte {
    double sum = 0;
    for (var e in pesajes) {
      sum += e.importe;
    }
    return sum;
  }

}