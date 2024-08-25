import 'dart:convert';
import 'package:http/http.dart' as http;

import '/src/models/camal.dart';
import '/src/utils/enviroment.dart';

class CamalesService {
  final String camalesURL = '$apiUrl/camales';

  Future<List<Camal>> getCamales(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$camalesURL/get'),
        headers: {'Content-Type': 'application/json', 'x-token': token},
      );
      final map = jsonDecode(response.body);
      if (map['ok']) {
        final list = List<Camal>.from(map['rows'].map((e) => Camal.fromJson(e)));
        list.sort((a, b) => a.nombre.compareTo(b.nombre));
        return list;
      } else {
        throw Exception(map['message']);
      }
    } catch (e) {
      if(e.runtimeType.toString() == '_ClientSocketException'){
        throw Exception(['getCamales', 'Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['getCamales', e.toString()]);
    }
  }

  Future<bool> insertCamal(Camal camal, String token) async {
    try {
      final response = await http.post(
        Uri.parse('$camalesURL/insert'),
        body: jsonEncode(camal.toJson()),
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
        throw Exception(['insertCamal', 'Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['insertCamal', e.toString()]);
    }
  }

  Future<bool> updateCamal(Camal camal, String token) async {
    try {
      final response = await http.patch(
        Uri.parse('$camalesURL/update/${camal.id}'),
        body: jsonEncode(camal.toJson()),
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
        throw Exception(['updateCamal', 'Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['updateCamal', e.toString()]);
    }
  }

  Future<bool> deleteCamal(Camal camal, String token) async {
    try {
      final response = await http.delete(
        Uri.parse('$camalesURL/delete/${camal.id}'),
        headers: {'x-token': token},
      );
      final map = jsonDecode(response.body);
      if (map['ok']) {
        return true;
      } else {
        throw Exception(map['message']);
      }
    } catch (e) {
      if(e.runtimeType.toString() == '_ClientSocketException'){
        throw Exception(['deleteCamal', 'Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['deleteCamal', e.toString()]);
    }
  }

  Future<bool> jabasMov(int camalID, int jabas, bool recibir, String token) async {
    final body = {'jabas': jabas, 'recibir': recibir};
    try {
      final response = await http.patch(
        Uri.parse('$camalesURL/recibir-jabas/$camalID'),
        body: jsonEncode(body),
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
        throw Exception(['jabasMov', 'Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['jabasMov', e.toString()]);
    }
  }
}
