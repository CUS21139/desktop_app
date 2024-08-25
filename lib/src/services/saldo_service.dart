import 'dart:convert';
import 'package:http/http.dart' as http;

import '/src/models/saldo.dart';
import '/src/utils/date_formats.dart';
import '/src/utils/enviroment.dart';

class SaldosService {
  final String saldosURL = '$apiUrl/saldos';

  Future<Saldo> getSaldo(String token, DateTime fecha) async {
    try {
      final response = await http.get(
        Uri.parse('$saldosURL/get/${date.format(fecha)}'),
        headers: {'Content-Type': 'application/json', 'x-token': token},
      );
      final map = jsonDecode(response.body);
      if (map['ok']) {
        return Saldo.fromJson(map['saldo']);
      } else {
        throw Exception(map['message']);
      }
    } catch (e) {
      if(e.runtimeType.toString() == '_ClientSocketException'){
        throw Exception(['getSaldos', 'Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['getSaldos', e.toString()]);
    }
  }

  Future<bool> insertSaldo(Saldo saldo, String token) async {
    try {
      final response = await http.post(
        Uri.parse('$saldosURL/insert'),
        body: jsonEncode(saldo.toJson()),
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
        throw Exception(['insertSaldos', 'Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['insertSaldos', e.toString()]);
    }
  }

}