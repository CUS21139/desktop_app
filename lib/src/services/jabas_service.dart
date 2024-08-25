import 'dart:convert';
import 'package:http/http.dart' as http;

import '/src/models/jabas.dart';
import '/src/utils/enviroment.dart';

class JabasService {
  final String jabasURL = '$apiUrl/jabas';

  Future<List<Jaba>> getJabas(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$jabasURL/get'),
        headers: {'Content-Type': 'application/json', 'x-token': token},
      );
      final map = jsonDecode(response.body);
      if (map['ok']) {
        final list = List<Jaba>.from(map['rows'].map((e) => Jaba.fromJson(e)));
        list.sort((a, b) => a.color.compareTo(b.color));
        return list;
      } else {
        throw Exception(map['message']);
      }
    } catch (e) {
      if(e.runtimeType.toString() == '_ClientSocketException'){
        throw Exception(['getJabas', 'Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['getJabas', e.toString()]);
    }
  }

  Future<bool> insertJaba(Jaba jaba, String token) async {
    try {
      final response = await http.post(
        Uri.parse('$jabasURL/insert'),
        body: jsonEncode(jaba.toJson()),
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
        throw Exception(['insertJaba', 'Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['insertJaba', e.toString()]);
    }
  }

  Future<bool> updateJaba(Jaba jaba, String token) async {
    try {
      final response = await http.patch(
        Uri.parse('$jabasURL/update/${jaba.id}'),
        body: jsonEncode(jaba.toJson()),
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
        throw Exception(['updatetJaba', 'Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['updateJaba', e.toString()]);
    }
  }

  Future<bool> deleteJaba(Jaba jaba, String token) async {
    try {
      final response = await http.delete(
        Uri.parse('$jabasURL/delete/${jaba.id}'),
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
        throw Exception(['deleteJaba', 'Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['deleteJaba', e.toString()]);
    }
  }
}