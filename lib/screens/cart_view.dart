import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:order_tracking/models/cart.dart' as c;
import 'package:order_tracking/models/product.dart';
import 'package:order_tracking/models/user.dart';
import 'package:order_tracking/services/database.dart';
import 'package:order_tracking/shared/constants.dart';
import 'package:provider/provider.dart';
import 'package:location/location.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CartView extends StatefulWidget {
  @override
  _CartViewState createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  DatabaseService _databaseService = DatabaseService();
  Location location = new Location();
  

  @override
  Widget build(BuildContext context) {
    final _localizations = AppLocalizations.of(context);

    User user = Provider.of<User>(context);
    List<Map<String, int>> latestCartItems = List<Map<String, int>>();
    List<Widget> children = <Widget>[];
    double sum = 0;
    c.Cart.cartItems.forEach((key, value) {
      latestCartItems.add({key: value.amount});
      children.add(
        Card(
          child: ListTile(
            title: Text(value.product.name),
            subtitle: Text(value.amount.toString() + " " + _localizations.amount),
            leading: Text((value.amount * value.product.price).toString() + "₺"),
            trailing: IconButton(
              icon: Icon(
                Icons.remove_circle,
                color: Colors.red[400],
              ),
              onPressed: () => {
                latestCartItems.asMap().forEach((index, value) => {
                      if (value.keys.first == key)
                        {
                          latestCartItems[index] = {},
                          c.Cart.cartItems.remove(key),
                          setState(() {}),
                        }
                    }),
              },
            ),
          ),
        ),
      );
      sum += (value.amount * value.product.price);
    });

    return Scaffold(
        appBar: AppBar(
          title: Text(projectName),
          backgroundColor: backgroundColor[400],
          elevation: 0.0,
        ),
        body: Wrap(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.78,
              child: Center(
                child: ListView(
                  children: children,
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Text(sum.toString() + "₺"),
            ),
            Container(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: RaisedButton(
                    color: backgroundColor[400],
                    child: Text(
                      "Sepeti Onayla",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if(c.Cart.cartItems.isNotEmpty){
                      LocationData _locationData = await location.getLocation();
                      _databaseService.createOrder(
                          latestCartItems,
                          user.uid,
                          GeoPoint(
                              _locationData.latitude, _locationData.longitude),
                              sum);
                          latestCartItems.clear();
                          c.Cart.cartItems.clear();
                          Navigator.of(context).pop();
                    }
                    }),
              ),
            ),
          ],
        ));
  }
}
