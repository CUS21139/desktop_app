import 'package:flutter/foundation.dart';
import '/src/models/caja.dart';
import '../../models/caja_mov.dart';

class CajaProv with ChangeNotifier {

  Caja? _caja;
  Caja get caja => _caja!;
  set caja (Caja c){
    _caja = c;
    notifyListeners();
  }

  bool get existeCaja => _caja != null ? true : false;

  List<CajaMov>? _cajaMov;
  List<CajaMov> get cajaMov => _cajaMov ?? [];
  set cajaMov (List<CajaMov> c){
    _cajaMov = c;
    notifyListeners();
  }

}