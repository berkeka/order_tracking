import 'dart:async';
import 'package:flutter/material.dart';
import 'package:order_tracking/models/product.dart';
import 'package:order_tracking/models/user.dart';
import 'package:order_tracking/screens/products/product_add.dart';
import 'package:order_tracking/screens/products/product_view.dart';
import 'package:order_tracking/screens/products/product_edit.dart';
import 'package:order_tracking/shared/constants.dart';
import 'package:order_tracking/services/database.dart';
import 'package:provider/provider.dart';

class Products extends StatefulWidget {
  final UserData userData;
  Products({@required this.userData});
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  int id = 0;
  DatabaseService _databaseService = DatabaseService();
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    Future<List<Product>> _productList = _databaseService.getProducts();
    String selectedProductId;
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Continue"),
      onPressed: () {
        _databaseService.deleteProduct(selectedProductId);
        Navigator.of(context).pop();
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Warning"),
      content: Text("Do you want to delete this product?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    return Scaffold(
      backgroundColor: backgroundColor[50],
      body: Container(
        child: FutureBuilder<List<Product>>(
          future: _productList,
          builder:
              (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
            List<Widget> children = <Widget>[];
            if (snapshot.hasData) {
              List<Product> productList = snapshot.data;
              productList.forEach((product) {
                List<Widget> buttonChildren = [];
                if (widget.userData.role == 'admin') {
                  buttonChildren.add(
                    IconButton(
                      icon: Icon(
                        Icons.remove_circle_outline,
                        color: Colors.red[400],
                      ),
                      onPressed: () {
                        selectedProductId = product.productid;
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return alert;
                          },
                        ).then(onGoBack);
                      },
                    ),
                  );
                  buttonChildren.add(
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  // Product edit page
                                  ProductEdit(product: product)),
                        ).then(onGoBack);
                      },
                    ),
                  );
                }
                buttonChildren.add(
                  IconButton(
                    icon: Icon(Icons.info_outline),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ProductView(product: product)),
                      );
                    },
                  ),
                );
                children.add(Card(
                    child: ListTile(
                  title: Text(product.name),
                  subtitle: Text("Price: ${product.price}"),
                  tileColor: backgroundColor[25],
                  trailing: Wrap(
                    children: buttonChildren,
                  ),
                )));
              });
            } else if (snapshot.hasError) {
              children = <Widget>[
                Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text('Error: ${snapshot.error}'),
                )
              ];
            } else {
              children = <Widget>[
                SizedBox(
                  child: CircularProgressIndicator(),
                  width: 60,
                  height: 60,
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text('Awaiting product data...'),
                )
              ];
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: children,
                ),
              );
            }
            if (widget.userData.role == 'admin') {
              /*
              children.add(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        icon: Icon(
                          Icons.add,
                          color: backgroundColor[400],
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    // Product edit page
                                    ProductAdd()),
                          ).then(onGoBack);
                        })
                  ],
                ),
              );
              */
            }
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            );
          },
        ),
      ),
    );
  }

  // Refresh page on fallback
  FutureOr onGoBack(dynamic value) {
    setState(() {});
  }
}
