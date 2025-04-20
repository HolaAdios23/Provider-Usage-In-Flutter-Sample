import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:state_flutter_week_seve/model/product_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:state_flutter_week_seve/provider/cart_provider.dart';
import 'package:state_flutter_week_seve/provider/product_provider.dart';
import 'package:state_flutter_week_seve/screens/cart_listing.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:watch_connectivity/watch_connectivity.dart';
class ProductListing extends StatefulWidget {
  const ProductListing({super.key});

  @override
  State<ProductListing> createState() => _ProductListingState();
}

class _ProductListingState extends State<ProductListing> {

  String _receivedMessage = "No message received yet";
  late WatchConnectivity _watchConnectivity;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _watchConnectivity = WatchConnectivity();
    loadProducts();




  }



  Future<void> loadProducts() async{
    await Provider.of<ProductProvider>(context, listen: false).fetchProducts();
    await Provider.of<CartProvider>(context, listen: false).loadCart();
    await Provider.of<CartProvider>(context, listen: false).counts;


  }



  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductProvider>(context).products;
    final carts = Provider.of<CartProvider>(context);


    return Scaffold(

      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const CartListing()),
                  );
                },
              ),
              Positioned(
                right: 6,
                top: 6,
                child: CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.red,
                  child: Text(
                    '${carts.counts}',
                    style: const TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
              )
            ],
          )
        ],
      ),

      body: ListView.builder(
        itemCount: products.length,
          itemBuilder: (context, index){
          final Product_Model product_model = products[index];

          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              leading: CachedNetworkImage(

                width: 70,
                height: 80,
                fit: BoxFit.cover, imageUrl:  product_model.image,
              ),
              title: Text(
                product_model.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 16),
              ),
              subtitle: SizedBox(
                height: 40,
                child: Text(
                  '\$${product_model.price}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.red
                  ),
                ),
              ),
              trailing: SizedBox(
                width: 120,
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    carts.addToCart(product_model);

                    double cal_price = 0.0;
                    for(var list in carts.cats)
                      {
                        cal_price += list.price;
                      }
                    String formattedPrice = cal_price.toStringAsFixed(2);

                    sendToMobile(carts.counts.toString(),formattedPrice);

                  },
                  child: Text(
                    "Add to Cart",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ),





          );



          }),




    );
  }
  void sendToMobile(String items, String price) async {
    if (await _watchConnectivity.isReachable) {
      // Send a message to the mobile app
      await _watchConnectivity.sendMessage({
        "totalItems": items,
        "totalPrice" : price
      });


      print("Message sent to Mobile");
    } else {
      print("Mobile app is not reachable");
    }
  }
}
