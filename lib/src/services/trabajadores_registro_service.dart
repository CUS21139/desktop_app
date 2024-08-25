import 'dart:convert';
import 'package:http/http.dart' as http;

import '/src/models/trabajador_registro.dart';
import '/src/utils/date_formats.dart';
import '/src/utils/enviroment.dart';

class TrabajadoresRegistroService {
  final String trabajadoresURL = '$apiUrl/trab-registros';

  Future<List<TrabajadorRegistro>> getRegistros(String token, DateTime ini, DateTime fin) async {
    try{
    final response = await http.get(
      Uri.parse('$trabajadoresURL/get/${dt.format(ini)}/${dt.format(fin)}'),
      headers: {
        'Content-Type': 'application/json',
        'x-token': token
      },
    );
    final map = jsonDecode(response.body);
      if (map['ok']) {
        final list = List<TrabajadorRegistro>.from(map['rows'].map((e) => TrabajadorRegistro.fromJson(e)));
        list.sort((a, b) => a.nombre.compareTo(b.nombre));
        return list;
      } else {
        throw Exception(map['message']);
      }
    } catch (e) {
      if(e.runtimeType.toString() == '_ClientSocketException'){
        throw Exception(['getRegistrosT', 'Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['getRegistrosT', e.toString()]);
    }
  }

  Future<bool> insertRegistro(TrabajadorRegistro registro, String token) async {
    try {
      final response = await http.post(
        Uri.parse('$trabajadoresURL/insert'),
        body: jsonEncode(registro.toJson()),
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
        throw Exception(['insertRegistroT', 'Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['insertRegistroT', e.toString()]);
    }
  }

  Future<bool> updateRegistro(TrabajadorRegistro registro, String token) async {
    try {
      final response = await http.patch(
        Uri.parse('$trabajadoresURL/update/${registro.id}'),
        body: jsonEncode(registro.toJson()),
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
        throw Exception(['updateRegistroT', 'Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['updateRegistroT', e.toString()]);
    }
  }

  Future<bool> deleteRegistro(TrabajadorRegistro registro, String token) async {
    try {
      final response = await http.delete(
        Uri.parse('$trabajadoresURL/delete/${registro.id}'),
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
        throw Exception(['deleteRegistroT', 'Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['deleteRegistroT', e.toString()]);
    }
  }
}
