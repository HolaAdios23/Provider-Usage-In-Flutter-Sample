import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:state_flutter_week_seve/model/product_model.dart';

import 'package:encrypt/encrypt.dart' as encrypt;

class ProductProvider with ChangeNotifier{



  List<Product_Model> _products = [];


  List<Product_Model> get products => _products;


  Future<void> fetchProducts() async {
    final key = encrypt.Key.fromUtf8('passworpassworpassworpassworpass');
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedEncrypted = prefs.getString('products');
    String? cachedIV = prefs.getString('iv'); // get saved IV

    if (cachedEncrypted != null && cachedEncrypted.isNotEmpty && cachedIV != null) {
      try {
        final iv = encrypt.IV.fromBase64(cachedIV); // use stored IV
        final decrypted = encrypter.decrypt64(cachedEncrypted, iv: iv);
        final List<dynamic> decoded = jsonDecode(decrypted);
        _products = decoded.map((json) => Product_Model.fromJson(json)).toList();

        print('Loaded from cache.');
        notifyListeners();
        return;
      } catch (e) {
        print('Error decrypting cached data: $e');
      }
    }

    // If cache doesn't exist or decryption fails, fetch from network
    final response = await http.get(Uri.parse('https://dummyjson.com/products'));

    if (response.statusCode == 200) {
      final List<dynamic> productJson = jsonDecode(response.body)['products'];
      _products = productJson.map((json) => Product_Model.fromJson(json)).toList();

      final plainText = jsonEncode(_products.map((product) => product.toJson()).toList());
      final iv = encrypt.IV.fromSecureRandom(16); // generate random IV
      final encrypted = encrypter.encrypt(plainText, iv: iv);

      await prefs.setString('products', encrypted.base64);
      await prefs.setString('iv', iv.base64); // save IV

      print('Fetched from API and cached.');
      notifyListeners();
    } else {
      throw Exception("Failed to load products");
    }
  }




}