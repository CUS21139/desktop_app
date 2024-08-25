import 'dart:convert';
import 'package:http/http.dart' as http;

import '/src/models/proveedor.dart';
import '/src/utils/enviroment.dart';

class ProveedoresService {
  final String proveedoresURL = '$apiUrl/proveedores';

  Future<List<Proveedor>> getProveedores(String token) async {
    try{
    final response = await http.get(
      Uri.parse('$proveedoresURL/get'),
      headers: {
        'Content-Type': 'application/json',
        'x-token': token
      },
    );
    final map = jsonDecode(response.body);
      if (map['ok']) {
        final list = List<Proveedor>.from(map['rows'].map((e) => Proveedor.fromJson(e)));
        list.sort((a, b) => a.nombre.compareTo(b.nombre));
        return list;
      } else {
        throw Exception(map['message']);
      }
    } catch (e) {
      if(e.runtimeType.toString() == '_ClientSocketException'){
        throw Exception(['getProveedores', 'Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['getProveedores', e.toString()]);
    }
  }

  Future<bool> insertProveedor(Proveedor proveedor, String token) async {
    try {
      final response = await http.post(
        Uri.parse('$proveedoresURL/insert'),
        body: jsonEncode(proveedor.toJson()),
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
        throw Exception(['insertProveedor', 'Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['insertProveedor', e.toString()]);
    }
  }

  Future<bool> updateProveedor(Proveedor proveedor, String token) async {
    try {
      final response = await http.patch(
        Uri.parse('$proveedoresURL/update/${proveedor.id}'),
        body: jsonEncode(proveedor.toJson()),
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
        throw Exception(['updateProveedor', 'Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['updateProveedor', e.toString()]);
    }
  }

  Future<bool> deleteProveedor(Proveedor proveedor, String token) async {
    try {
      final response = await http.delete(
        Uri.parse('$proveedoresURL/delete/${proveedor.id}'),
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
        throw Exception(['deleteProveedor', 'Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['deleteProveedor', e.toString()]);
    }
  }
}
