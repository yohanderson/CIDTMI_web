import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';

class CartModel extends ChangeNotifier {
  final List<Map<String, dynamic>> _products = [];

  bool addProduct(Map<String, dynamic> product, int quantity) {
    final existingProduct = _products.firstWhereOrNull(
          (p) => p['product_id'] == product['product_id'],
    );
    if (existingProduct != null) {
      if (existingProduct['quantity_cart'] == quantity) {
        return false;
      }
      existingProduct['quantity_cart'] = quantity;
    } else {
      _products.add({...product, 'quantity_cart': quantity});
    }
    notifyListeners();
    return true;
  }

  void removeProduct(Map<String, dynamic> product) {
    _products.removeWhere((p) => p['product_id'] == product['product_id']);
    notifyListeners();
  }

  double get total {
    double total = 0;
    for (var product in _products) {
      final price = product['promotion'] ?? product['price_unit'];
      final subtotal = price * product['quantity_cart'];
      total += subtotal;
    }
    return total;
  }

  List<Map<String, dynamic>> get products => _products;
}