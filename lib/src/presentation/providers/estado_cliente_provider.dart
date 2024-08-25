import 'package:flutter/foundation.dart';
import '/src/models/cliente.dart';
import '../../models/estado_cliente_mov.dart';

class EstadoClienteProv with ChangeNotifier {
  Cliente? _clienteSelect;
  Cliente get clienteSelect => _clienteSelect!;
  set clienteSelect(Cliente b) {
    _clienteSelect = b;
    notifyListeners();
  }

  bool get existeClienteSelect => _clienteSelect != null ? true : false;

  List<EstadoClienteMov>? _movimientos;
  List<EstadoClienteMov> get movimientos => _movimientos ?? [];
  set movimientos(List<EstadoClienteMov> m) {
    _movimientos = m;
    notifyListeners();
  }

  EstadoClienteMov? _movSelect;
  EstadoClienteMov get movSelect => _movSelect!;
  set movSelect (EstadoClienteMov mov) {
    _movSelect = mov;
    notifyListeners();
  }
  bool get existeMovSelect => _movSelect != null ? true : false;
  
  void movSelectInitState () {
    _movSelect = null;
    notifyListeners();
  }
}
