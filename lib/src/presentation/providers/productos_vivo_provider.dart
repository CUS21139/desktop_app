import 'package:flutter/foundation.dart';
import '../../models/producto_vivo.dart';

class ProductosVivoProv with ChangeNotifier {

  ProductoVivo? _producto;
  ProductoVivo get producto => _producto!;
  set producto (ProductoVivo b){
    _producto = b;
    notifyListeners();
  }

  bool get existeproducto => _producto != null ? true: false;

  void productoInitState () {
    _producto = null;
    notifyListeners();
  }

  List<ProductoVivo>? _productos;
  List<ProductoVivo> get productos => _productos ?? [];
  set productos (List<ProductoVivo> b){
    _productos = b;
    notifyListeners();
  }

}