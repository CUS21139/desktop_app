import 'package:flutter/foundation.dart';
import '/src/models/camal_jaba.dart';

class CamalesJabasProv with ChangeNotifier {
  List<CamalJaba> list = [];

  void setList (List<CamalJaba> l) {
    list.clear();
    list = l;
    notifyListeners();
  }
  
  void addCamalJaba(CamalJaba c) {
    list.add(c);
    notifyListeners();
  }

  void removeCamalJaba(CamalJaba c) {
    list.remove(c);
    notifyListeners();
  }

  int get totalJabas {
    int sum = 0;
    for (var r in list) {
      sum += r.cantidad;
    }
    return sum;
  }

  int get totalRecogida {
    int sum = 0;
    for (var r in list) {
      sum += r.cantRecogida;
    }
    return sum;
  }
  
  int get totalPendientes {
    int sum = 0;
    for (var r in list) {
      sum += r.quedan;
    }
    return sum;
  }
}
