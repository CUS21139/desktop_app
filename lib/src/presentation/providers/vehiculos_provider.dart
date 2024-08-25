import 'package:app_desktop/src/models/vehiculo.dart';
import 'package:flutter/foundation.dart';

class VehiculosProvider with ChangeNotifier {

  List<Vehiculo>? _vehiculos;
  List<Vehiculo> get vehiculos => _vehiculos ?? [];
  set vehiculos (List<Vehiculo> list) {
    _vehiculos = list;
    notifyListeners();
  }

}