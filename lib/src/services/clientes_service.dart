import 'dart:convert';
import 'package:http/http.dart' as http;

import '/src/models/cliente.dart';
import '/src/utils/enviroment.dart';

class ClientesService {
  final String clientesURL = '$apiUrl/clientes';

  Future<List<Cliente>> getClientes(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$clientesURL/get'),
        headers: {'Content-Type': 'application/json', 'x-token': token},
      );
      final map = jsonDecode(response.body);
      if (map['ok']) {
        final list = List<Cliente>.from(map['rows'].map((e) => Cliente.fromJson(e)));
        list.sort((a, b) => a.nombre.compareTo(b.nombre));
        return list;
      } else {
        throw Exception(map['message']);
      }
    } catch (e) {
      if(e.runtimeType.toString() == '_ClientSocketException'){
        throw Exception(['getClientes', 'Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['getClientes', e.toString()]);
    }
  }

  Future<Cliente> getCliente(String token, int id) async {
    try {
      final response = await http.get(
        Uri.parse('$clientesURL/get/$id'),
        headers: {'Content-Type': 'application/json', 'x-token': token},
      );
      final map = jsonDecode(response.body);
      if (map['ok']) {
        return Cliente.fromJson(map['cliente']);
      } else {
        throw Exception(map['message']);
      }
    } catch (e) {
      if(e.runtimeType.toString() == '_ClientSocketException'){
        throw Exception(['getClientes', 'Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['getClientes', e.toString()]);
    }
  }

  Future<bool> insertCliente(Cliente cliente, String token) async {
    try {
      final response = await http.post(
        Uri.parse('$clientesURL/insert'),
        body: jsonEncode(cliente.toJson()),
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
        throw Exception(['insertCliente', 'Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['insertCliente', e.toString()]);
    }
  }

  Future<bool> updateCliente(Cliente cliente, String token) async {
    try {
      final response = await http.patch(
        Uri.parse('$clientesURL/update/${cliente.id}'),
        body: jsonEncode(cliente.toJson()),
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
        throw Exception(['updateCliente', 'Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['updateCliente', e.toString()]);
    }
  }

  Future<bool> deleteCliente(Cliente cliente, String token) async {
    try {
      final response = await http.delete(
        Uri.parse('$clientesURL/delete/${cliente.id}'),
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
        throw Exception(['deleteCliente', 'Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['deleteCliente', e.toString()]);
    }
  }
}