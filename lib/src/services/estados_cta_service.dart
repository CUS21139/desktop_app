import 'dart:convert';
import '/src/models/estado_sin_nombre_mov.dart';
import 'package:http/http.dart' as http;

import '/src/models/estado_banco_mov.dart';
import '/src/models/estado_cliente_mov.dart';
import '/src/models/estado_gavipo_mov.dart';
import '/src/models/estado_proveedor_mov.dart';
import '/src/models/estado_trabajador_mov.dart';

import '/src/utils/date_formats.dart';
import '/src/utils/enviroment.dart';

class EstadoCtaService {
  final String estadosURL = '$apiUrl/estados_cta';

  Future<List<EstadoBancoMov>> getEstadoBanco (String token, DateTime fecha, String estado) async {
    try {
      final response = await http.get(
        Uri.parse('$estadosURL/get-banco/${dt.format(fecha)}/$estado'),
        headers: {'Content-Type': 'application/json', 'x-token': token},
      );
      final map = jsonDecode(response.body);
      if (map['ok']) {
        return List<EstadoBancoMov>.from(map['movimientos'].map((e) => EstadoBancoMov.fromJson(e)));
      } else {
        throw Exception(map['message']);
      }
    } catch (e) {
      if(e.runtimeType.toString() == '_ClientSocketException'){
        throw Exception(['getEstadoBanco', 'Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['getEstadoBanco', e.toString()]);
    }
  }
  
  Future<List<EstadoClienteMov>> getEstadoCliente (String token, DateTime fecha, String estado) async {
    try {
      final response = await http.get(
        Uri.parse('$estadosURL/get-cliente/${dt.format(fecha)}/$estado'),
        headers: {'Content-Type': 'application/json', 'x-token': token},
      );
      final map = jsonDecode(response.body);
      if (map['ok']) {
        return List<EstadoClienteMov>.from(map['movimientos'].map((e) => EstadoClienteMov.fromJson(e)));
      } else {
        throw Exception(map['message']);
      }
    } catch (e) {
      if(e.runtimeType.toString() == '_ClientSocketException'){
        throw Exception(['getEstadoCliente', 'Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['getEstadoCliente', e.toString()]);
    }
  }
  
  Future<List<EstadoGavipoMov>> getEstadoGavipo (String token, DateTime fecha) async {
    try {
      final response = await http.get(
        Uri.parse('$estadosURL/get-gavipo/${dt.format(fecha)}'),
        headers: {'Content-Type': 'application/json', 'x-token': token},
      );
      final map = jsonDecode(response.body);
      if (map['ok']) {
        return List<EstadoGavipoMov>.from(map['movimientos'].map((e) => EstadoGavipoMov.fromJson(e)));
      } else {
        throw Exception(map['message']);
      }
    } catch (e) {
      if(e.runtimeType.toString() == '_ClientSocketException'){
        throw Exception(['getEstadoGavipo', 'Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['getEstadoGavipo', e.toString()]);
    }
  }
  
  Future<List<EstadoSinNombreMov>> getEstadoSinNombre (String token, DateTime fecha) async {
    try {
      final response = await http.get(
        Uri.parse('$estadosURL/get-sin-nombre/${dt.format(fecha)}'),
        headers: {'Content-Type': 'application/json', 'x-token': token},
      );
      final map = jsonDecode(response.body);
      if (map['ok']) {
        return List<EstadoSinNombreMov>.from(map['movimientos'].map((e) => EstadoSinNombreMov.fromJson(e)));
      } else {
        throw Exception(map['message']);
      }
    } catch (e) {
      if(e.runtimeType.toString() == '_ClientSocketException'){
        throw Exception(['getEstadoSinNombre', 'Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['getEstadoSinNombre', e.toString()]);
    }
  }
 
  Future<bool> asignarEstadoSinNombre (String token, String docId) async {
    try {
      final response = await http.get(
        Uri.parse('$estadosURL/update-sin-nombre/$docId'),
        headers: {'Content-Type': 'application/json', 'x-token': token},
      );
      final map = jsonDecode(response.body);
      if (map['ok']) {
        return map['ok'];
      } else {
        throw Exception(map['message']);
      }
    } catch (e) {
      if(e.runtimeType.toString() == '_ClientSocketException'){
        throw Exception(['getEstadoSinNombre', 'Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['getEstadoSinNombre', e.toString()]);
    }
  }

  Future<List<EstadoProveedorMov>> getEstadoProveedor (String token, DateTime fecha, String estado) async {
    try {
      final response = await http.get(
        Uri.parse('$estadosURL/get-proveedor/${dt.format(fecha)}/$estado'),
        headers: {'Content-Type': 'application/json', 'x-token': token},
      );
      final map = jsonDecode(response.body);
      if (map['ok']) {
        return List<EstadoProveedorMov>.from(map['movimientos'].map((e) => EstadoProveedorMov.fromJson(e)));
      } else {
        throw Exception(map['message']);
      }
    } catch (e) {
      if(e.runtimeType.toString() == '_ClientSocketException'){
        throw Exception(['getEstadoProveedor', 'Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['getEstadoProveedor', e.toString()]);
    }
  }
  
  Future<List<EstadoTrabajadorMov>> getEstadoTrabajador (String token, DateTime fecha, String estado) async {
    try {
      final response = await http.get(
        Uri.parse('$estadosURL/get-trabajador/${dt.format(fecha)}/$estado'),
        headers: {'Content-Type': 'application/json', 'x-token': token},
      );
      final map = jsonDecode(response.body);
      if (map['ok']) {
        return List<EstadoTrabajadorMov>.from(map['movimientos'].map((e) => EstadoTrabajadorMov.fromJson(e)));
      } else {
        throw Exception(map['message']);
      }
    } catch (e) {
      if(e.runtimeType.toString() == '_ClientSocketException'){
        throw Exception(['getEstadTrabajador', 'Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['getEstadoTrabajador', e.toString()]);
    }
  }
}