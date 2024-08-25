import 'dart:convert';
import 'package:http/http.dart' as http;

import '/src/models/compra_beneficiado.dart';
import '/src/utils/date_formats.dart';
import '/src/utils/enviroment.dart';

class ComprasBeneficiadoService {
  final String comprasURL = '$apiUrl/compras_vivos';

  Future<CompraBeneficiado> getCompra(String token, int id) async {
    try {
      final response = await http.get(
        Uri.parse('$comprasURL/get/$id'),
        headers: {'Content-Type': 'application/json', 'x-token': token},
      );
      final map = jsonDecode(response.body);
      if (map['ok']) {
        return CompraBeneficiado.fromJson(map['compra']);
      } else {
        throw Exception(map['message']);
      }
    } catch (e) {
      if(e.runtimeType.toString() == '_ClientSocketException'){
        throw Exception(['getCompra', 'Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['getCompra', e.toString()]);
    }
  }

  Future<List<CompraBeneficiado>> getCompras(String token, DateTime ini, DateTime fin) async {
    try {
      final response = await http.get(
        Uri.parse('$comprasURL/get/${dt.format(ini)}/${dt.format(fin)}'),
        headers: {'Content-Type': 'application/json', 'x-token': token},
      );
      final map = jsonDecode(response.body);
      if (map['ok']) {
        return List<CompraBeneficiado>.from(map['rows'].map((e) => CompraBeneficiado.fromJson(e)));
      } else {
        throw Exception(map['message']);
      }
    } catch (e) {
      if(e.runtimeType.toString() == '_ClientSocketException'){
        throw Exception(['getCompras', 'Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['getCompras', e.toString()]);
    }
  }

  Future<bool> insertCompra(CompraBeneficiado compra, String token) async {
    try {
      final response = await http.post(
        Uri.parse('$comprasURL/insert'),
        body: jsonEncode(compra.toJson()),
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
        throw Exception(['insertCompras', 'Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['insertCompra', e.toString()]);
    }
  }

  Future<bool> updateCompra(CompraBeneficiado compra, String token) async {
    try {
      final response = await http.patch(
        Uri.parse('$comprasURL/update'),
        body: jsonEncode(compra.toJson()),
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
        throw Exception(['updateCompras', 'Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['updateCompra', e.toString()]);
    }
  }

  Future<bool> deleteCompra(CompraBeneficiado compra, String token) async {
    try {
      final response = await http.delete(
        Uri.parse('$comprasURL/delete'),
        body: jsonEncode(compra.toJson()),
        headers: {'Content-Type': 'application/json', 'x-token': token},
      );
      final map = jsonDecode(response.body);
      if(map['ok']){
        return true;
      } else {
        throw Exception(map['message']);
      }
    } catch (e) {
      if(e.runtimeType.toString() == '_ClientSocketException'){
        throw Exception(['deleteCompras', 'Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['deleteCompra', e.toString()]);
    }
  }
}