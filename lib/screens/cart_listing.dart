import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:state_flutter_week_seve/model/product_model.dart';
import 'package:state_flutter_week_seve/provider/cart_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:watch_connectivity/watch_connectivity.dart';

class CartListing extends StatefulWidget {
  const CartListing({super.key});

  @override
  State<CartListing> createState() => _CartListingState();
}

class _CartListingState extends State<CartListing> {

  late WatchConnectivity _watchConnectivity;
  @override
  void initState() {
    super.initState();
    _watchConnectivity = WatchConnectivity();
    Provider.of<CartProvider>(context, listen: false).loadCart();
    Provider.of<CartProvider>(context, listen: false).counts;

  }
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final items = cart.cats;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carts'),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (ctx, i) {
          final Product_Model product_model = items[i];
          return ListTile(
            leading: CachedNetworkImage
              (
                imageUrl: product_model.image, width: 60, fit: BoxFit.cover),
            title: Text(product_model.name),
            subtitle: Text('\$${product_model.price}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                cart.removeFromCart(product_model);
              },
            ),
          );
        },
      ),
    );
  }
}
