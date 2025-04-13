import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watch_connectivity/watch_connectivity.dart';

import '../provider/cart_provider.dart';

class ProductSummary extends StatefulWidget {
  const ProductSummary({super.key});

  @override
  State<ProductSummary> createState() => _ProductSummaryState();
}

class _ProductSummaryState extends State<ProductSummary> {

  late WatchConnectivity _watchConnectivity;
  String _totalItems = "0";
  String _totalPrice = "0";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Listen for incoming messages
    _watchConnectivity = WatchConnectivity();
    _watchConnectivity.messageStream.listen((message) {
      setState(() {
        _totalItems = message["totalItems"] ?? Provider.of<CartProvider>(context, listen: false).counts.toString(); // Adjust based on message format
        _totalPrice = message["totalPrice"] ?? "0";
        print("Message received from mobile: $message");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // ✅ center vertically
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Total Items : "),
                Text(_totalItems,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),),
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Total Price : "),
                Text(_totalPrice,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                  ),),
              ],
            ),
          ],
        ),
      ),

    );
  }
}
