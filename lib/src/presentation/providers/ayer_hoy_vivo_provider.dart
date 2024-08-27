import 'package:flutter/foundation.dart';

class AyerHoyProv with ChangeNotifier {

  bool? _hoy;
  bool get hoy => _hoy ?? true;
  set hoy (bool v){
    _hoy = v;
    notifyListeners();
  }

  bool? _ayer;
  bool get ayer => _ayer ?? false;
  set ayer (bool v){
    _ayer = v;
    notifyListeners();
  }

  bool? _anuladas;
  bool get anuladas => _anuladas ?? false;
  set anuladas (bool v){
    _anuladas = v;
    notifyListeners();
  }

  bool? _confirmadas;
  bool get confirmadas => _confirmadas ?? false;
  set confirmadas (bool v){
    _confirmadas = v;
    notifyListeners();
  }

}