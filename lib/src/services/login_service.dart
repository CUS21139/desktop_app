import 'dart:convert';
import '/src/models/usuario.dart';
import 'package:http/http.dart' as http;

import '/src/utils/enviroment.dart';

class LoginService {
  final String loginURL = '$apiUrl/login';

  Future<List<Usuario>> getUsers(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$loginURL/get'),
        headers: {'Content-Type': 'application/json', 'x-token': token},
      );
      final map = jsonDecode(response.body);
      if (map['ok']) {
        final list = List<Usuario>.from(map['rows'].map((e) => Usuario.fromJson(e)));
        list.removeWhere((e) => e.role == 'PES');
        list.sort((a, b) => a.nombre.compareTo(b.nombre));
        return list;
      } else {
        throw Exception(map['message']);
      }
    } catch (e) {
      if(e.runtimeType.toString() == '_ClientSocketException'){
        throw Exception(['getUsuarios','Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['getUsuarios', e.toString()]);
    }
  }

  Future<Map<String, dynamic>> createUser(String nombre, String email, String password, String role) async {
    final data = {'nombre': nombre, 'email': email, 'password': password, 'role': role};

    try {
      final response = await http.post(
        Uri.parse('$loginURL/new'),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'},
      );
      return jsonDecode(response.body);
    } catch (e) {
      if(e.runtimeType.toString() == '_ClientSocketException'){
        throw Exception(['Compruebe la conexion a intenet.', e.toString()]);
      }
      throw Exception(e);
    }
  }

  Future<bool> updateUsuario(Usuario usuario, String token) async {
    try {
      final response = await http.patch(
        Uri.parse('$loginURL/update/${usuario.id}'),
        body: jsonEncode(usuario.toJson()),
        headers: {'Content-Type': 'application/json', 'x-token': token},
      );
      final map = jsonDecode(response.body);
      if (map['ok']) {
        return true;
      } else {
        throw Exception(map['message']);
      }
    } catch (e) {
      if(e.runtimeType.toString() == '_ClientSocketException'){
        throw Exception(['updateUsuario','Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['updateUsuario', e.toString()]);
    }
  }

  Future<bool> changePass(int id, String sysEmail, String sysPass, String newPass, String token) async {
    final data = {
      'sysEmail': sysEmail,
      'sysPass': sysPass,
      'newPass': newPass,
    };
    try {
      final response = await http.patch(
        Uri.parse('$loginURL/change-pass/$id'),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json', 'x-token': token},
      );
      final map = jsonDecode(response.body);
      if (map['ok']) {
        return true;
      } else {
        throw Exception(map['message']);
      }
    } catch (e) {
      if(e.runtimeType.toString() == '_ClientSocketException'){
        throw Exception(['updateUsuario','Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['updateUsuario', e.toString()]);
    }
  }

  Future<bool> deleteUsuario(Usuario usuario, String token) async {
    try {
      final response = await http.delete(
        Uri.parse('$loginURL/delete/${usuario.id}'),
        headers: {'x-token': token},
      );
      final map = jsonDecode(response.body);
      if(map['ok']){
        return true;
      } else {
        throw Exception(map['message']);
      }
    } catch (e) {
      if(e.runtimeType.toString() == '_ClientSocketException'){
        throw Exception(['deleteUsuario','Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['deleteUsuario', e.toString()]);
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final data = {'email': email, 'password': password};

    try {
      final response = await http.post(
        Uri.parse('$loginURL/signin'),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'},
      );
      return jsonDecode(response.body);
    } catch (e) {
      if(e.runtimeType.toString() == '_ClientSocketException'){
        throw Exception(['Compruebe la conexion a intenet.', e.toString()]);
      }
      throw Exception(e);
    }
  }

  Future<Map<String, dynamic>> logout(String email) async {
    final data = {'email': email};
    try {
      final response = await http.post(
        Uri.parse('$loginURL/signout'),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'},
      );
      return jsonDecode(response.body);
    } catch (e) {
      if(e.runtimeType.toString() == '_ClientSocketException'){
        throw Exception(['Compruebe la conexion a intenet.', e.toString()]);
      }
      throw Exception(e);
    }
  }
}
