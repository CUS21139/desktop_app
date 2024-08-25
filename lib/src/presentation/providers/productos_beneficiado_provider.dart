import 'package:flutter/foundation.dart';
import '/src/models/producto_beneficiado.dart';

class ProductosBeneficiadoProv with ChangeNotifier {

  ProductoBeneficiado? _producto;
  ProductoBeneficiado get producto => _producto!;
  set producto (ProductoBeneficiado b){
    _producto = b;
    notifyListeners();
  }

  bool get existeproducto => _producto != null ? true: false;

  void productoInitState () {
    _producto = null;
    notifyListeners();
  }

  List<ProductoBeneficiado>? _productos;
  List<ProductoBeneficiado> get productos => _productos ?? [];
  set productos (List<ProductoBeneficiado> b){
    _productos = b;
    notifyListeners();
  }

}