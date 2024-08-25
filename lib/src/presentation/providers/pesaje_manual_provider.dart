import 'package:flutter/foundation.dart';

class PesajeManualProv with ChangeNotifier {

  bool? _pesajeManual;
  bool get pesajeManual => _pesajeManual ?? false;
  set pesajeManual (bool p){
    _pesajeManual = p;
    notifyListeners();
  }

}