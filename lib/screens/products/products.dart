import 'package:flutter/material.dart';
import 'package:order_tracking/models/product.dart';
import 'package:order_tracking/models/user.dart';
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
  DatabaseService _databaseService = DatabaseService();
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    Future<List<Product>> _productList = _databaseService.getProducts();
    return Scaffold(
      backgroundColor: backgroundColor[50],
      body: Container(
        child: FutureBuilder<List<Product>>(
          future: _productList,
          builder:
              (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
            List<Widget> children;
            if (snapshot.hasData) {
              children = <Widget>[];
              List<Product> productList = snapshot.data;
              productList.forEach((product) {
                children.add(Card(
                    child: ListTile(
                  title: Text(product.name),
                  subtitle: Text("Price: ${product.price}"),
                  tileColor: backgroundColor[25],
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
}
