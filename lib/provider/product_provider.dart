import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:state_flutter_week_seve/model/product_model.dart';


class ProductProvider with ChangeNotifier{



  List<Product_Model> _products = [];


  List<Product_Model> get products => _products;


  Future<void> fetchProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedProducts = prefs.getString('products');

    if (cachedProducts != null && cachedProducts.isNotEmpty) {
      final List<dynamic> decoded = jsonDecode(cachedProducts);
      _products = decoded.map((json) => Product_Model.fromJson(json)).toList();
      print('Cached products: $cachedProducts');

      notifyListeners();
    } else {
      final responses = await http.get(Uri.parse('https://dummyjson.com/products'));

      if (responses.statusCode == 200) {
        final List<dynamic> productJson = jsonDecode(responses.body)['products'];

        _products = productJson.map((json) => Product_Model.fromJson(json)).toList();

        prefs.setString(
          'products',
            jsonEncode(_products.map((product) => product.toJson()).toList())

        );

        notifyListeners();
      } else {
        throw Exception("Failed to load products");
      }
    }
  }


}