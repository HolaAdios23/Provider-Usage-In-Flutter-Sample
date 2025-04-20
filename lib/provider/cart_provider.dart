import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:state_flutter_week_seve/model/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_connectivity/src/watch_connectivity_base.dart';

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



  Future<void> addToCart(Product_Model product_model, CartProvider carts, WatchConnectivity watchConnectivity) async {
    _carts.add(product_model);
    final prefs = await SharedPreferences.getInstance();
    final String encoded =
    jsonEncode(_carts.map((product) => product.toJson()).toList());

    await prefs.setString('cartItems', encoded);

    double cal_price = 0.0;
    for(var list in carts.cats)
      {
        cal_price += list.price;
      }
    String formattedPrice = cal_price.toStringAsFixed(2);

    sendToMobile(carts.counts.toString(),formattedPrice, product_model.name, watchConnectivity);

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

  void sendToMobile(String items, String price, String name, WatchConnectivity _watchConnectivity) async {
    if (await _watchConnectivity.isReachable) {
      // Send a message to the mobile app
      await _watchConnectivity.sendMessage({
        "totalItems": items,
        "totalPrice" : price,
        "itemName" : name
      });


      print("Message sent to Mobile");
    } else {
      print("Mobile app is not reachable");
    }
  }


  int get counts => _carts.length;
}

