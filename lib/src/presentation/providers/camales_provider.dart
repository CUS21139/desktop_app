import 'package:flutter/foundation.dart';
import '../../models/camal.dart';

class CamalesProv with ChangeNotifier {

  Camal? _camal;
  Camal get camal => _camal!;
  set camal (Camal c){
    _camal = c;
    notifyListeners();
  }

  bool get existeCamal => _camal != null ? true: false;

  void bancoInitState () {
    _camal = null;
    notifyListeners();
  }

  List<Camal>? _camales;
  List<Camal> get camales => _camales ?? [];
  set camales (List<Camal> c){
    _camales = c;
    notifyListeners();
  }

}