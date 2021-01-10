import 'package:flutter/material.dart';
import 'package:order_tracking/models/user.dart';
import 'package:order_tracking/shared/constants.dart';

class Products extends StatefulWidget {
  final UserData userData;
  Products({@required this.userData});
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor[50],
      body: Container(
        child: Column(
          children: [Text(widget.userData.role)],
        ),
      ),
    );
  }
}
