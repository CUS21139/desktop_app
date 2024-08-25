import 'package:flutter/foundation.dart';
import '../../models/banco.dart';

class BancosProv with ChangeNotifier {

  Banco? _banco;
  Banco get banco => _banco!;
  set banco (Banco b){
    _banco = b;
    notifyListeners();
  }

  bool get existeBanco => _banco != null ? true: false;

  void bancoInitState () {
    _banco = null;
    notifyListeners();
  }

  List<Banco>? _bancos;
  List<Banco> get bancos => _bancos ?? [];
  set bancos (List<Banco> b){
    _bancos = b;
    notifyListeners();
  }

  double get totalSaldo {
    double sum = 0;
    for (var e in bancos) {
      sum += e.saldo!;
    }
    return sum;
  }

}