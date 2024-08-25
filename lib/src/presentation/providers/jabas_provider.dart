import 'package:flutter/foundation.dart';
import '/src/models/camal_jaba.dart';
import '/src/models/jabas.dart';

class JabasProv with ChangeNotifier {
  List<Jaba> list = [];

  void setList (List<Jaba> l) {
    list.clear();
    list = l;
    notifyListeners();
  }
  
  void addJaba(Jaba c) {
    list.add(c);
    notifyListeners();
  }

  void removeJaba(Jaba c) {
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

  List<CamalJaba> listTotales = [];
  
  void addListTotales (List<CamalJaba> l) {
    listTotales.addAll(l);
    notifyListeners();
  }

  void clearListTotales () {
    listTotales.clear();
    notifyListeners();
  }

  int get totalRecogida {
    int sum = 0;
    for (var r in listTotales) {
      sum += r.cantRecogida;
    }
    return sum;
  }
  
  int get totalPendientes {
    int sum = 0;
    for (var r in listTotales) {
      sum += r.quedan;
    }
    return sum;
  }

  int get totalAcopio => totalJabas - totalRecogida -totalPendientes;

}
