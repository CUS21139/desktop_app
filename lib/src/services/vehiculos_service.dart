import 'dart:convert';
import 'package:http/http.dart' as http;

import '/src/models/vehiculo.dart';
import '/src/utils/enviroment.dart';

class VehiculosService {
  final String vehiculosURL = '$apiUrl/vehiculos';

  Future<List<Vehiculo>> getVehiculos(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$vehiculosURL/get'),
        headers: {'Content-Type': 'application/json', 'x-token': token},
      );
      final map = jsonDecode(response.body);
      if (map['ok']) {
        final list = List<Vehiculo>.from(map['rows'].map((e) => Vehiculo.fromJson(e)));
        list.sort((a, b) => a.placa.compareTo(b.placa));
        return list;
      } else {
        throw Exception(map['message']);
      }
    } catch (e) {
      if(e.runtimeType.toString() == '_ClientSocketException'){
        throw Exception(['getVehiculos', 'Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['getVehiculos', e.toString()]);
    }
  }

  Future<bool> insertVehiculo(Vehiculo vehiculo, String token) async {
    try {
      final response = await http.post(
        Uri.parse('$vehiculosURL/insert'),
        body: jsonEncode(vehiculo.toJson()),
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
        throw Exception(['insertVehiculo', 'Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['insertVehiculo', e.toString()]);
    }
  }

  Future<bool> updateVehiculo(Vehiculo vehiculo, String token) async {
    try {
      final response = await http.patch(
        Uri.parse('$vehiculosURL/update/${vehiculo.id}'),
        body: jsonEncode(vehiculo.toJson()),
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
        throw Exception(['updateVehiculo', 'Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['updateVehiculo', e.toString()]);
    }
  }

  Future<bool> deleteVehiculo(Vehiculo vehiculo, String token) async {
    try {
      final response = await http.delete(
        Uri.parse('$vehiculosURL/delete/${vehiculo.id}'),
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
        throw Exception(['deleteVehiculo', 'Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['deleteVehiculo', e.toString()]);
    }
  }
}