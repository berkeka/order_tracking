import 'package:flutter/material.dart';
import 'package:order_tracking/models/cart.dart' as c;
import 'package:order_tracking/models/product.dart';
import 'package:order_tracking/shared/constants.dart';

class CartView extends StatefulWidget {
  @override
  _CartViewState createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  @override
  Widget build(BuildContext context) {
    List<Widget> children = <Widget>[];
    c.Cart.cartItems.forEach((item) {
      Product product = item.keys.first;
      int amount = item.values.first;
      children.add(
        Card(
          child: ListTile(
            title: Text(product.name),
            subtitle: Text(amount.toString()),
          ),
        ),
      );
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(projectName),
        backgroundColor: backgroundColor[400],
        elevation: 0.0,
      ),
      body: ListView(
        children: children,
      ),
    );
  }
}
