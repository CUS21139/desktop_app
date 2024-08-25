import 'package:flutter/foundation.dart';
import '/src/models/cliente.dart';

class ClientesProv with ChangeNotifier {
  Cliente? _cliente;
  Cliente get cliente => _cliente!;
  set cliente(Cliente b) {
    _cliente = b;
    notifyListeners();
  }

  bool get existeCliente => _cliente != null ? true : false;

  void clienteInitState() {
    _cliente = null;
    notifyListeners();
  }

  List<Cliente>? _clientes;
  List<Cliente> get clientes => _clientes ?? [];
  set clientes(List<Cliente> b) {
    _clientes = b;
    notifyListeners();
  }

  double get totalSaldoDeudores {
    double sum = 0;
    for (var e in clientes) {
      if (e.saldo! > 1) {
        sum += e.saldo!;
      }
    }
    return sum;
  }
}
