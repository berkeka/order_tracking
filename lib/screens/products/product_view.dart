import 'package:flutter/material.dart';
import 'package:order_tracking/models/product.dart';
import 'package:order_tracking/models/user.dart';
import 'package:order_tracking/shared/constants.dart';
import 'package:order_tracking/services/database.dart';
import 'package:provider/provider.dart';

class ProductView extends StatefulWidget {
  final Product product;
  ProductView({@required this.product});
  @override
  _ProductViewState createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  DatabaseService _databaseService = DatabaseService();
  @override
  Widget build(BuildContext context) {
    Product product = widget.product;
    return Scaffold(
      appBar: AppBar(
        title: Text(projectName),
        backgroundColor: backgroundColor[400],
        elevation: 0.0,
      ),
      body: Container(
        child: Text(product.name),
      ),
    );
  }
}
