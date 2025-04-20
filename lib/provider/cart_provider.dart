import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:state_flutter_week_seve/model/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider with ChangeNotifier {
  final List<Product_Model> _carts = [];

  List<Product_Model> get cats => _carts;

  // Load cart from shared preferences
  Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final String? cartJson = prefs.getString('cartItems');

    //decrpypt

    if (cartJson != null) {
      final List<dynamic> decoded = jsonDecode(cartJson);
      _carts.clear();
      _carts.addAll(decoded.map((json) => Product_Model.fromJson(json)).toList());
      notifyListeners();
    }
  }


  Future<void> addToCart(Product_Model product_model) async {
    _carts.add(product_model);
    final prefs = await SharedPreferences.getInstance();
    final String encoded =
    jsonEncode(_carts.map((product) => product.toJson()).toList());
    //encoded encrypt
    await prefs.setString('cartItems', encoded);
    notifyListeners();
  }

  Future<void> removeFromCart(Product_Model product) async {

    _carts.remove(product);
    final prefs = await SharedPreferences.getInstance();
    final String encoded =
    jsonEncode(_carts.map((product) => product.toJson()).toList());
    await prefs.setString('cartItems', encoded);
    notifyListeners();
  }



  int get counts => _carts.length;
}

