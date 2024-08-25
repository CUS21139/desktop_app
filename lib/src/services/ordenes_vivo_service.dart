import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/ordenes_vivo.dart';
import '/src/utils/date_formats.dart';
import '/src/utils/enviroment.dart';

class OrdenesVivoService {
  final String ordenesURL = '$apiUrl/ordenes_vivos';

  Future<List<OrdenVivo>> getOrdenes(String token, DateTime ini, DateTime fin) async {
    try {
      final response = await http.get(
        Uri.parse('$ordenesURL/get/${dt.format(ini)}/${dt.format(fin)}'),
        headers: {'Content-Type': 'application/json', 'x-token': token},
      );
      final map = jsonDecode(response.body);
      if (map['ok']) {
        return List<OrdenVivo>.from(map['rows'].map((e) => OrdenVivo.fromJson(e)));
      } else {
        throw Exception(map['message']);
      }
    } catch (e) {
      if(e.runtimeType.toString() == '_ClientSocketException'){
        throw Exception(['getOrdenes', 'Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['getOrdenes', e.toString()]);
    }
  }

  Future<bool> insertOrden(OrdenVivo orden, String token) async {
    try {
      final response = await http.post(
        Uri.parse('$ordenesURL/insert'),
        body: jsonEncode(orden.toJson()),
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
        throw Exception(['insertOrden', 'Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['insertOrden', e.toString()]);
    }
  }

  Future<bool> updateOrden(OrdenVivo orden, String token) async {
    try {
      final response = await http.patch(
        Uri.parse('$ordenesURL/update/${orden.id!}'),
        body: jsonEncode(orden.toJson()),
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
        throw Exception(['updateOrden', 'Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['updateOrden', e.toString()]);
    }
  }

  Future<bool> deleteOrden(OrdenVivo orden, String token) async {
    try {
      final response = await http.delete(
        Uri.parse('$ordenesURL/delete/${orden.id!}'),
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
        throw Exception(['deleteOrden', 'Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['deleteCompra', e.toString()]);
    }
  }

}
