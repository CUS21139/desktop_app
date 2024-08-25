import 'dart:convert';
import 'package:http/http.dart' as http;

import '/src/models/banco.dart';
import '/src/utils/enviroment.dart';

class BancosService {
  final String bancosURL = '$apiUrl/bancos';

  Future<List<Banco>> getBancos(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$bancosURL/get'),
        headers: {'Content-Type': 'application/json', 'x-token': token},
      );
      final map = jsonDecode(response.body);
      if (map['ok']) {
        final list = List<Banco>.from(map['rows'].map((e) => Banco.fromJson(e)));
        list.sort((a, b) => a.nombre.compareTo(b.nombre));
        return list;
      } else {
        throw Exception(map['message']);
      }
    } catch (e) {
      if(e.runtimeType.toString() == '_ClientSocketException'){
        throw Exception(['getBancos','Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['getBancos', e.toString()]);
    }
  }

  Future<bool> insertBanco(Banco banco, String token) async {
    try {
      final response = await http.post(
        Uri.parse('$bancosURL/insert'),
        body: jsonEncode(banco.toJson()),
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
        throw Exception(['insertBanco','Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['insertBanco', e.toString()]);
    }
  }

  Future<bool> updateBanco(Banco banco, String token) async {
    try {
      final response = await http.patch(
        Uri.parse('$bancosURL/update/${banco.id}'),
        body: jsonEncode(banco.toJson()),
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
        throw Exception(['updateBanco','Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['updateBanco', e.toString()]);
    }
  }

  Future<bool> deleteBanco(Banco banco, String token) async {
    try {
      final response = await http.delete(
        Uri.parse('$bancosURL/delete/${banco.id}'),
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
        throw Exception(['deleteBanco','Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['deleteBanco', e.toString()]);
    }
  }
}