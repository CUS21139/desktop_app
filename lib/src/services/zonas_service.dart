import 'dart:convert';
import 'package:http/http.dart' as http;

import '/src/models/zona.dart';
import '/src/utils/enviroment.dart';

class ZonasService {
  final String zonasURL = '$apiUrl/zonas';

  Future<List<Zona>> getZonas(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$zonasURL/get'),
        headers: {'Content-Type': 'application/json', 'x-token': token},
      );
      final map = jsonDecode(response.body);
      if (map['ok']) {
        final list = List<Zona>.from(map['rows'].map((e) => Zona.fromJson(e)));
        list.sort((a, b) => a.nombre.compareTo(b.nombre));
        return list;
      } else {
        throw Exception(map['message']);
      }
    } catch (e) {
      if(e.runtimeType.toString() == '_ClientSocketException'){
        throw Exception(['getZonas', 'Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['getZonas', e.toString()]);
    }
  }

  Future<bool> insertZona(Zona zona, String token) async {
    try {
      final response = await http.post(
        Uri.parse('$zonasURL/insert'),
        body: jsonEncode(zona.toJson()),
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
        throw Exception(['insertZona', 'Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['insertZona', e.toString()]);
    }
  }

  Future<bool> updateZona(Zona zona, String token) async {
    try {
      final response = await http.patch(
        Uri.parse('$zonasURL/update/${zona.id}'),
        body: jsonEncode(zona.toJson()),
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
        throw Exception(['updatetZona', 'Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['updateZona', e.toString()]);
    }
  }

  Future<bool> deleteZona(Zona zona, String token) async {
    try {
      final response = await http.delete(
        Uri.parse('$zonasURL/delete/${zona.id}'),
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
        throw Exception(['deleteZona', 'Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['deleteZona', e.toString()]);
    }
  }
}