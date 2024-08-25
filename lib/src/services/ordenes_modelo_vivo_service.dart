import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/ordenes_vivo.dart';
import '/src/utils/enviroment.dart';

class OrdenesModeloVivosService {
  final String ordenesURL = '$apiUrl/ordenes_model-vivos';

  Future<List<OrdenVivo>> getOrdenes(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$ordenesURL/get'),
        headers: {'Content-Type': 'application/json', 'x-token': token},
      );
      final map = jsonDecode(response.body);
      if (map['ok']) {
        final list = List<OrdenVivo>.from(map['rows'].map((e) => OrdenVivo.fromJson(e)));
        list.sort((a,b) => a.zonaCode.compareTo(b.zonaCode));
        return list;
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
      throw Exception(['deleteOrden', e.toString()]);
    }
  }

}
