import 'dart:async';

import 'package:flutter/material.dart';
import 'package:order_tracking/models/product.dart';
import 'package:order_tracking/models/user.dart';
import 'package:order_tracking/models/cart.dart' as c;
import 'package:order_tracking/shared/constants.dart';
import 'package:order_tracking/services/database.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProductView extends StatefulWidget {
  final Product product;
  ProductView({@required this.product});
  @override
  _ProductViewState createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  DatabaseService _databaseService = DatabaseService();

  int _n = 0;

  @override
  void add() {
    setState(() {
      _n++;
    });
  }

  @override
  void minus() {
    setState(() {
      if (_n != 0) _n--;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _localizations = AppLocalizations.of(context);
    Product product = widget.product;
    return Scaffold(
        appBar: AppBar(
          title: Text(projectName),
          backgroundColor: backgroundColor[400],
          elevation: 0.0,
        ),
        body: Column(
          children: [
            Align(
                alignment: Alignment.center,
                child: Text(
                  product.name,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0,
                      color: Colors.orange[500]),
                )),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: Text(
                          product.description,
                          style: TextStyle(fontSize: 14),
                        ))),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      topRight: Radius.circular(8.0),
                    ),
                    child: Image.network(
                        '${product.imageURL}', //doesn't work, will be fixed
                        // width: 300,
                        height: 150,
                        fit: BoxFit.fill),
                  ),
                )
              ],
            ),
            Container(
              padding: EdgeInsets.only(top: 40),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FloatingActionButton(
                      heroTag: "btn1",
                      onPressed: minus,
                      child: Icon(Icons.remove, color: Colors.black),
                      backgroundColor: Colors.white,
                    ),
                    Text('$_n', style: TextStyle(fontSize: 60.0)),
                    FloatingActionButton(
                      heroTag: "btn2",
                      onPressed: add,
                      child: Icon(Icons.add, color: Colors.black),
                      backgroundColor: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
            Container(
                padding: EdgeInsets.only(top: 20),
                child: Center(
                    child: RaisedButton(
                  child: Text(
                    _localizations.addToCart,
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    c.Cart.cartItems.add({product: 2});
                  },
                  color: Colors.red,
                )))
          ],
        ));
  }
}
