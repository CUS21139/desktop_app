import 'package:flutter/foundation.dart';
import '../../models/pesador.dart';

class PesadoresProv with ChangeNotifier {

  Pesador? _pesador;
  Pesador get pesador => _pesador!;
  set pesador (Pesador b){
    _pesador = b;
    notifyListeners();
  }

  bool get existepesador => _pesador != null ? true: false;

  void pesadorInitState () {
    _pesador = null;
    notifyListeners();
  }

  List<Pesador>? _pesadores;
  List<Pesador> get pesadores => _pesadores ?? [];
  set pesadores (List<Pesador> b){
    _pesadores = b;
    notifyListeners();
  }

}