import 'package:flutter/foundation.dart';

import '../../models/usuario.dart';

class UsuariosProv with ChangeNotifier {

  Usuario? _usuario;
  Usuario get usuario => _usuario!;
  set usuario (Usuario user) {
    _usuario = user;
    notifyListeners();
  }

  bool existeUsuario () => _usuario != null ? true : false;

  String? _token;
  String get token => _token ?? '';
  set token (String tk){
    _token = tk;
    notifyListeners();
  }

  List<Usuario>? _usuarios;
  List<Usuario> get usuarios => _usuarios ?? [];
  set usuarios (List<Usuario> l){
    _usuarios = l;
    notifyListeners();
  }

}