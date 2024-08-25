import 'dart:convert';
import 'package:http/http.dart' as http;

import '/src/models/pesador.dart';
import '/src/utils/enviroment.dart';

class PesadoresService {
  final String pesadoresURL = '$apiUrl/pesadores';

  Future<List<Pesador>> getPesadores(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$pesadoresURL/get'),
        headers: {'Content-Type': 'application/json', 'x-token': token},
      );
      final map = jsonDecode(response.body);
      if (map['ok']) {
        final list = List<Pesador>.from(map['rows'].map((e) => Pesador.fromJson(e)));
        list.sort((a, b) => a.nombre.compareTo(b.nombre));
        return list;
      } else {
        throw Exception(map['message']);
      }
    } catch (e) {
      if(e.runtimeType.toString() == '_ClientSocketException'){
        throw Exception(['getPesadores', 'Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['getPesadores', e.toString()]);
    }
  }
  
  Future<Pesador> getPesador(int id, String token) async {
    try {
      final response = await http.get(
        Uri.parse('$pesadoresURL/get/$id'),
        headers: {'Content-Type': 'application/json', 'x-token': token},
      );
      final map = jsonDecode(response.body);
      if (map['ok']) {
        return Pesador.fromJson(map['pesador']);
      } else {
        throw Exception(map['message']);
      }
    } catch (e) {
      if(e.runtimeType.toString() == '_ClientSocketException'){
        throw Exception(['getPesadores', 'Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['getPesadores', e.toString()]);
    }
  }

  Future<bool> insertPesador(Pesador pesador, String token) async {

    try {
      final response = await http.post(
        Uri.parse('$pesadoresURL/insert'),
        body: jsonEncode(pesador.toJson()),
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
        throw Exception(['insertPesador', 'Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['insertPesador', e.toString()]);
    }
  }

  Future<bool> updateCliente(Pesador pesador, String token) async {
    try {
      final response = await http.patch(
        Uri.parse('$pesadoresURL/update/${pesador.id}'),
        body: jsonEncode(pesador.toJson()),
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
        throw Exception(['updatePesador', 'Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['updatePesador', e.toString()]);
    }
  }

  Future<bool> deletePesador(Pesador pesador, String token) async {
    try {
      final response = await http.delete(
        Uri.parse('$pesadoresURL/delete/${pesador.id}'),
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
        throw Exception(['deletePesador', 'Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['deletePesador', e.toString()]);
    }
  }

  Future<bool> jabasMov(int pesadorID, int jabas, bool recibir, String token) async {
    final body = {'jabas': jabas, 'recibir': recibir};
    try {
      final response = await http.post(
        Uri.parse('$pesadoresURL/recibir-jabas/$pesadorID'),
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
