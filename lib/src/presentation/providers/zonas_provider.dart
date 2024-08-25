import 'package:flutter/foundation.dart';
import '../../models/zona.dart';

class ZonasProv with ChangeNotifier {

  Zona? _zona;
  Zona get zona => _zona!;
  set zona (Zona b){
    _zona = b;
    notifyListeners();
  }

  bool get existezona => _zona != null ? true: false;

  void zonaInitState () {
    _zona = null;
    notifyListeners();
  }

  List<Zona>? _zonas;
  List<Zona> get zonas => _zonas ?? [];
  set zonas (List<Zona> b){
    _zonas = b;
    notifyListeners();
  }

}