import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:state_flutter_week_seve/provider/cart_provider.dart';
import 'package:state_flutter_week_seve/provider/product_provider.dart';
import 'package:state_flutter_week_seve/screens/product_listing.dart';
import 'package:is_wear/is_wear.dart';
import 'package:state_flutter_week_seve/screens/product_summary.dart';

final _isWearPlugin = IsWear();

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  bool isWear = await _isWearPlugin.check()??false;
  runApp(
      
      MultiProvider(
        providers: [
          
          ChangeNotifierProvider(create: (_) => ProductProvider()),
          ChangeNotifierProvider(create: (_) => CartProvider()),

        ],

          child: MyApp(isWear: isWear,)));
}

class MyApp extends StatelessWidget {
  final bool isWear;
  const MyApp({super.key, required this.isWear});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home:isWear? ProductSummary() : ProductListing() ,
    );
  }
}
