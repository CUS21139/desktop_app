import 'dart:convert';
import 'package:http/http.dart' as http;

import '/src/models/venta_beneficiado.dart';
import '/src/utils/enviroment.dart';
import '/src/utils/date_formats.dart';


class VentasBeneficiadoService {
  final String ventasURL = '$apiUrl/ventas_beneficiado';

  Future<List<VentaBeneficiado>> getVentas(String token, DateTime ini, DateTime fin) async {
    try {
      final response = await http.get(
        Uri.parse('$ventasURL/get/${dt.format(ini)}/${dt.format(fin)}'),
        headers: {'Content-Type': 'application/json', 'x-token': token},
      );
      final map = jsonDecode(response.body);
      if (map['ok']) {
        return List<VentaBeneficiado>.from(map['rows'].map((e) => VentaBeneficiado.fromJson(e)));
      } else {
        throw Exception(map['message']);
      }
    } catch (e) {
      if(e.runtimeType.toString() == '_ClientSocketException'){
        throw Exception(['getVentas', 'Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['getVentas', e.toString()]);
    }
  }

  Future<List<VentaBeneficiado>> getVenta(int id, String token) async {
    try {
      final response = await http.get(
        Uri.parse('$ventasURL/get/$id'),
        headers: {'Content-Type': 'application/json', 'x-token': token},
      );
      final map = jsonDecode(response.body);
      if (map['ok']) {
        final venta = VentaBeneficiado.fromJson(map['venta']);
        return [venta];
      } else {
        throw Exception(map['message']);
      }
    } catch (e) {
      if(e.runtimeType.toString() == '_ClientSocketException'){
        throw Exception(['getVenta', 'Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['gettVenta', e.toString()]);
    }
  }
  
  Future<bool> insertVenta(VentaBeneficiado venta, String token) async {
    try {
      final response = await http.post(
        Uri.parse('$ventasURL/insert'),
        body: jsonEncode(venta.toJson()),
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
        throw Exception(['insertVenta', 'Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['insertVenta', e.toString()]);
    }
  }

  Future<bool> editarPrecio(VentaBeneficiado venta, String token) async {
    try {
      final response = await http.patch(
        Uri.parse('$ventasURL/edit-precio/${venta.id!}'),
        body: jsonEncode(venta.toJson()),
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
        throw Exception(['ediPreciotVenta', 'Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['editPrecioVenta', e.toString()]);
    }
  }

  Future<bool> descontar(VentaBeneficiado venta, String token) async {
    try {
      final response = await http.patch(
        Uri.parse('$ventasURL/descontar/${venta.id!}'),
        body: jsonEncode(venta.toJson()),
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
        throw Exception(['descontarVenta', 'Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['descontarVenta', e.toString()]);
    }
  }

  Future<bool> anular(VentaBeneficiado venta, String token) async {
    try {
      final response = await http.patch(
        Uri.parse('$ventasURL/anular/${venta.id!}'),
        body: jsonEncode(venta.toJson()),
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
        throw Exception(['anularVenta', 'Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['anularVenta', e.toString()]);
    }
  }
}