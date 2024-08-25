import 'package:flutter/foundation.dart';
import '/src/models/banco.dart';
import '../../models/estado_banco_mov.dart';

class EstadoBancoProv with ChangeNotifier {

  Banco? _bancoSelect;
  Banco get bancoSelect => _bancoSelect!;
  set bancoSelect (Banco b){
    _bancoSelect = b;
    notifyListeners();
  }
  bool get existeBancoSelect => _bancoSelect != null ? true : false;

  List<EstadoBancoMov>? _movimientos;
  List<EstadoBancoMov> get movimientos => _movimientos ?? [];
  set movimientos (List<EstadoBancoMov> m) {
    _movimientos = m;
    notifyListeners();
  }

  EstadoBancoMov? _movSelect;
  EstadoBancoMov get movSelect => _movSelect!;
  set movSelect (EstadoBancoMov mov) {
    _movSelect = mov;
    notifyListeners();
  }
  bool get existeMovSelect => _movSelect != null ? true : false;

  void movSelectInitState () {
    _movSelect = null;
    notifyListeners();
  }
}