import 'dart:convert';
import 'package:http/http.dart' as http;

import '/src/models/producto_beneficiado.dart';
import '/src/utils/enviroment.dart';

class ProductosBeneficiadoService {
  final String productosURL = '$apiUrl/productos_beneficiado';

  Future<List<ProductoBeneficiado>> getProductos(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$productosURL/get'),
        headers: {'Content-Type': 'application/json', 'x-token': token},
      );
      final map = jsonDecode(response.body);
      if (map['ok']) {
        final list = List<ProductoBeneficiado>.from(map['rows'].map((e) => ProductoBeneficiado.fromJson(e)));
        list.sort((a, b) => a.nombre.compareTo(b.nombre));
        return list;
      } else {
        throw Exception(map['message']);
      }
    } catch (e) {
      if (e.runtimeType.toString() == '_ClientSocketException') {
        throw Exception(
            ['getProductos', 'Error en la conexion a intenet.', e.toString()]);
      }
      throw Exception(['getProductos', e.toString()]);
    }
  }

  Future<bool> insertProducto(ProductoBeneficiado producto, String token) async {
    try {
      final response = await http.post(
        Uri.parse('$productosURL/insert'),
        body: jsonEncode(producto.toJson()),
        headers: {'Content-Type': 'application/json', 'x-token': token},
      );
      final map = jsonDecode(response.body);
      if (map['ok']) {
        return true;
      } else {
        throw Exception(map['message']);
      }
    } catch (e) {
      if (e.runtimeType.toString() == '_ClientSocketException') {
        throw Exception([
          'insertProducto',
          'Error en la conexion a intenet.',
          e.toString()
        ]);
      }
      throw Exception(['insertProducto', e.toString()]);
    }
  }

  Future<bool> updateProducto(ProductoBeneficiado producto, String token) async {
    try {
      final response = await http.patch(
        Uri.parse('$productosURL/update/${producto.id}'),
        body: jsonEncode(producto.toJson()),
        headers: {'Content-Type': 'application/json', 'x-token': token},
      );
      final map = jsonDecode(response.body);
      if (map['ok']) {
        return true;
      } else {
        throw Exception(map['message']);
      }
    } catch (e) {
      if (e.runtimeType.toString() == '_ClientSocketException') {
        throw Exception([
          'updateProducto',
          'Error en la conexion a intenet.',
          e.toString()
        ]);
      }
      throw Exception(['updateProducto', e.toString()]);
    }
  }

  Future<bool> deleteProducto(ProductoBeneficiado producto, String token) async {
    try {
      final response = await http.delete(
        Uri.parse('$productosURL/delete/${producto.id}'),
        headers: {'x-token': token},
      );
      final map = jsonDecode(response.body);
      if (map['ok']) {
        return true;
      } else {
        throw Exception(map['message']);
      }
    } catch (e) {
      if (e.runtimeType.toString() == '_ClientSocketException') {
        throw Exception([
          'deleteProducto',
          'Error en la conexion a intenet.',
          e.toString()
        ]);
      }
      throw Exception(['deleteProducto', e.toString()]);
    }
  }
}
