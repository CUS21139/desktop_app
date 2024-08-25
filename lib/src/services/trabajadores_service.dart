import 'dart:convert';
import 'package:http/http.dart' as http;

import '/src/models/trabajador.dart';
import '/src/utils/enviroment.dart';

class TrabajadoresService {
  final String trabajadoresURL = '$apiUrl/trabajadores';

  Future<List<Trabajador>> getTrabajadores(String token) async {
    try{
    final response = await http.get(
      Uri.parse('$trabajadoresURL/get'),
      headers: {
        'Content-Type': 'application/json',
        'x-token': token
      },
    );
    final map = jsonDecode(response.body);
      if (map['ok']) {
        final list = List<Trabajador>.from(map['rows'].map((e) => Trabajador.fromJson(e)));
        list.sort((a, b) => a.nombre.compareTo(b.nombre));
        return list;
      } else {
        throw Exception(map['message']);
      }
    } catch (e) {
      if(e.runtimeType.toString() == '_ClientSocketException'){
        throw Exception(['getTrabajadores', 'Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['getTrabajadores', e.toString()]);
    }
  }

  Future<bool> insertTrabajador(Trabajador trabajador, String token) async {
    try {
      final response = await http.post(
        Uri.parse('$trabajadoresURL/insert'),
        body: jsonEncode(trabajador.toJson()),
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
        throw Exception(['insertTrabajador', 'Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['insertTrabajador', e.toString()]);
    }
  }

  Future<bool> updateTrabajador(Trabajador trabajador, String token) async {
    try {
      final response = await http.patch(
        Uri.parse('$trabajadoresURL/update/${trabajador.id}'),
        body: jsonEncode(trabajador.toJson()),
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
        throw Exception(['updateTrabajador', 'Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['updateTrabajador', e.toString()]);
    }
  }

  Future<bool> deleteTrabajador(Trabajador trabajador, String token) async {
    try {
      final response = await http.delete(
        Uri.parse('$trabajadoresURL/delete/${trabajador.id}'),
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
        throw Exception(['deleteTrabajador', 'Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['deleteTrabajador', e.toString()]);
    }
  }
}
