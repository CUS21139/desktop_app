import 'dart:convert';
import 'package:http/http.dart' as http;

import '/src/models/camal_jaba.dart';
import '/src/models/pesador.dart';
import '/src/utils/date_formats.dart';
import '/src/utils/enviroment.dart';

class CamalesJabasService {
  final String camalJabaURL = '$apiUrl/camal-jaba';

  Future<List<CamalJaba>> getAll(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$camalJabaURL/get'),
        headers: {'Content-Type': 'application/json', 'x-token': token},
      );
      final map = jsonDecode(response.body);
      if (map['ok']) {
        return List<CamalJaba>.from(
            map['rows'].map((e) => CamalJaba.fromJson(e)));
      } else {
        throw Exception(map['message']);
      }
    } catch (e) {
      throw Exception(['getRegistros', e.toString()]);
    }
  }

  Future<List<CamalJaba>> getRegistros(
      String token, Pesador pesador, DateTime dateTime) async {
    try {
      final response = await http.get(
        Uri.parse('$camalJabaURL/get/${pesador.id}/${date.format(dateTime)}'),
        headers: {'Content-Type': 'application/json', 'x-token': token},
      );
      final map = jsonDecode(response.body);
      if (map['ok']) {
        return List<CamalJaba>.from(
            map['rows'].map((e) => CamalJaba.fromJson(e)));
      } else {
        throw Exception(map['message']);
      }
    } catch (e) {
      throw Exception(['getRegistros', e.toString()]);
    }
  }

  Future<List<CamalJaba>> getRegistrosPendientes(
      String token, Pesador pesador, DateTime operationDay) async {
    try {
      final response = await http.get(
        Uri.parse('$camalJabaURL/get-pendientes'),
        headers: {'Content-Type': 'application/json', 'x-token': token},
      );
      final map = jsonDecode(response.body);
      if (map['ok']) {
        final list = List<CamalJaba>.from(map['records'].map((e) => CamalJaba.fromJson(e)));
        list.retainWhere((e) => e.pesadorId == pesador.id!);
        list.retainWhere((e) {
          if(date.format(operationDay) != date.format(e.operationDate)){
            return e.quedan > 0;
          }
          return true;
        });
        list.sort((a, b) => a.camalNombre.compareTo(b.camalNombre));
        return list;
      } else {
        throw Exception(map['message']);
      }
    } catch (e) {
      throw Exception(['getRegistros', e.toString()]);
    }
  }

  Future<Map<String, dynamic>> insertRegistro(
      CamalJaba registro, String token) async {
    try {
      final response = await http.post(
        Uri.parse('$camalJabaURL/insert'),
        body: jsonEncode(registro.toJson()),
        headers: {'Content-Type': 'application/json', 'x-token': token},
      );
      final map = jsonDecode(response.body);
      return map;
    } catch (e) {
      throw Exception(['insertRegistro', e.toString()]);
    }
  }

  Future<bool> updateRegistro(CamalJaba registro, String token) async {
    try {
      final response = await http.patch(
        Uri.parse('$camalJabaURL/update'),
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
      throw Exception(['updateRegistro', e.toString()]);
    }
  }
}
