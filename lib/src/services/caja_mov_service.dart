import 'dart:convert';
import 'package:http/http.dart' as http;

import '/src/models/caja.dart';
import '/src/models/caja_mov.dart';
import '/src/utils/date_formats.dart';
import '/src/utils/enviroment.dart';

class CajaService {
  final String cajasURL = '$apiUrl/cajas';

  Future<List<CajaMov>> getMov (String token, String docId) async {
    try {
      final response = await http.get(
        Uri.parse('$cajasURL/getmov/$docId'),
        headers: {'Content-Type': 'application/json', 'x-token': token},
      );
      final map = jsonDecode(response.body);
      if (map['ok']) {
        return List<CajaMov>.from(map['movimientos'].map((e) => CajaMov.fromJson(e)));        
      } else {
        throw Exception(map['message']);
      }
    } catch (e) {
      if(e.runtimeType.toString() == '_ClientSocketException'){
        throw Exception(['getCajaMov', 'Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['getCajaMov', e.toString()]);
    }
  }

  Future<Map<String, dynamic>> getCaja(String token, DateTime fecha) async {
    try {
      final response = await http.get(
        Uri.parse('$cajasURL/get/${date.format(fecha)}'),
        headers: {'Content-Type': 'application/json', 'x-token': token},
      );
      final map = jsonDecode(response.body);
      if (map['ok']) {
        final caja = Caja.fromJson(map['caja']);
        final movs = List<CajaMov>.from(map['movimientos'].map((e) => CajaMov.fromJson(e)));
        return {
          'caja': caja,
          'movs': movs
        };
      } else {
        throw Exception(map['message']);
      }
    } catch (e) {
      if(e.runtimeType.toString() == '_ClientSocketException'){
        throw Exception(['getCaja', 'Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['getCaja', e.toString()]);
    }
  }

  Future<bool> crearCaja(String token, DateTime fecha, String createdBy) async {
    final data = {'fecha': date.format(fecha), 'hora': time.format(fecha),'created_by': createdBy};

    try {
      final response = await http.post(
        Uri.parse('$cajasURL/insert'),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json', 'x-token': token},
      );
      final map = jsonDecode(response.body);
      return map['ok'];
    } catch (e) {
      if(e.runtimeType.toString() == '_ClientSocketException'){
        throw Exception(['crearCaja', 'Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['crearCaja', e.toString()]);
    }
  }
  
  Future<Map<String, dynamic>> insertIngreso(String token, CajaMov mov) async {
    try {
      final response = await http.post(
        Uri.parse('$cajasURL/insert-ingreso'),
        body: jsonEncode(mov.toJson()),
        headers: {'Content-Type': 'application/json', 'x-token': token},
      );
      final map = jsonDecode(response.body);
      if (map['ok']) {
        final caja = Caja.fromJson(map['caja']);
        final movs = List<CajaMov>.from(map['movimientos'].map((e) => CajaMov.fromJson(e)));
        return {
          'caja': caja,
          'movs': movs
        };
      } else {
        throw Exception(map['message']);
      }
    } catch (e) {
      if(e.runtimeType.toString() == '_ClientSocketException'){
        throw Exception(['insertIngreso', 'Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['insertIngreso', e.toString()]);
    }
  }
  
  Future<Map<String, dynamic>> deleteIngreso(String token, CajaMov mov) async {
    try {
      final response = await http.delete(
        Uri.parse('$cajasURL/delete-ingreso'),
        body: jsonEncode(mov.toJson()),
        headers: {'Content-Type': 'application/json', 'x-token': token},
      );
      final map = jsonDecode(response.body);
      if (map['ok']) {
        final caja = Caja.fromJson(map['caja']);
        final movs = List<CajaMov>.from(map['movimientos'].map((e) => CajaMov.fromJson(e)));
        return {
          'caja': caja,
          'movs': movs
        };
      } else {
        throw Exception(map['message']);
      }
    } catch (e) {
      if(e.runtimeType.toString() == '_ClientSocketException'){
        throw Exception(['deleteIngreso', 'Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['deleteIngreso', e.toString()]);
    }
  }
  
  Future<Map<String, dynamic>> insertEgreso(String token, CajaMov mov) async {
    try {
      final response = await http.post(
        Uri.parse('$cajasURL/insert-egreso'),
        body: jsonEncode(mov.toJson()),
        headers: {'Content-Type': 'application/json', 'x-token': token},
      );
      final map = jsonDecode(response.body);
      if (map['ok']) {
        final caja = Caja.fromJson(map['caja']);
        final movs = List<CajaMov>.from(map['movimientos'].map((e) => CajaMov.fromJson(e)));
        return {
          'caja': caja,
          'movs': movs
        };
      } else {
        throw Exception(map['message']);
      }
    } catch (e) {
      if(e.runtimeType.toString() == '_ClientSocketException'){
        throw Exception(['insertEgreso', 'Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['insertEgreso', e.toString()]);
    }
  }
  
  Future<Map<String, dynamic>> deleteEgreso(String token, CajaMov mov) async {
    try {
      final response = await http.delete(
        Uri.parse('$cajasURL/delete-egreso'),
        body: jsonEncode(mov.toJson()),
        headers: {'Content-Type': 'application/json', 'x-token': token},
      );
      final map = jsonDecode(response.body);
      if (map['ok']) {
        final caja = Caja.fromJson(map['caja']);
        final movs = List<CajaMov>.from(map['movimientos'].map((e) => CajaMov.fromJson(e)));
        return {
          'caja': caja,
          'movs': movs
        };
      } else {
        throw Exception(map['message']);
      }
    } catch (e) {
      if(e.runtimeType.toString() == '_ClientSocketException'){
        throw Exception(['deleteEgreso', 'Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['deleteEgreso', e.toString()]);
    }
  }
  
  Future<Map<String, dynamic>> insertTransferencia(String token, CajaMov mov) async {
    try {
      final response = await http.post(
        Uri.parse('$cajasURL/insert-transferencia'),
        body: jsonEncode(mov.toJson()),
        headers: {'Content-Type': 'application/json', 'x-token': token},
      );
      final map = jsonDecode(response.body);
      if (map['ok']) {
        final caja = Caja.fromJson(map['caja']);
        final movs = List<CajaMov>.from(map['movimientos'].map((e) => CajaMov.fromJson(e)));
        return {
          'caja': caja,
          'movs': movs
        };
      } else {
        throw Exception(map['message']);
      }
    } catch (e) {
      if(e.runtimeType.toString() == '_ClientSocketException'){
        throw Exception(['insertTransferencia', 'Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['insertTransferencia', e.toString()]);
    }
  }
  
  Future<Map<String, dynamic>> deleteTransferencia(String token, CajaMov mov) async {
    try {
      final response = await http.delete(
        Uri.parse('$cajasURL/delete-transferencia'),
        body: jsonEncode(mov.toJson()),
        headers: {'Content-Type': 'application/json', 'x-token': token},
      );
      final map = jsonDecode(response.body);
      if (map['ok']) {
        final caja = Caja.fromJson(map['caja']);
        final movs = List<CajaMov>.from(map['movimientos'].map((e) => CajaMov.fromJson(e)));
        return {
          'caja': caja,
          'movs': movs
        };
      } else {
        throw Exception(map['message']);
      }
    } catch (e) {
      if(e.runtimeType.toString() == '_ClientSocketException'){
        throw Exception(['deleteTransferencia', 'Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['deleteTransferencia', e.toString()]);
    }
  }
}
