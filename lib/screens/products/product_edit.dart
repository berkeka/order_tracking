import 'package:flutter/material.dart';
import 'package:order_tracking/models/product.dart';
import 'package:order_tracking/shared/constants.dart';
import 'package:order_tracking/services/database.dart';

class ProductEdit extends StatefulWidget {
  final Product product;
  ProductEdit({@required this.product});
  @override
  _ProductEditState createState() => _ProductEditState();
}

class _ProductEditState extends State<ProductEdit> {
  DatabaseService _databaseService = DatabaseService();
  final _formKey = GlobalKey<FormState>();

  String error = '';
  String name = '';
  String price = "0.0";

  final nameController = TextEditingController();
  final priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Product product = widget.product;
    name = product.name;
    price = product.price.toString();
    nameController.text = name;
    priceController.text = price;
    return Scaffold(
      appBar: AppBar(
        title: Text(projectName),
        backgroundColor: backgroundColor[400],
        elevation: 0.0,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 10.0),
              Text('Name'),
              TextFormField(
                //initialValue: name,
                controller: nameController,
              ),
              SizedBox(height: 10.0),
              Text('Price'),
              TextFormField(
                controller: priceController,
              ),
              SizedBox(height: 10.0),
              RaisedButton(
                  color: backgroundColor[400],
                  child: Text(
                    'Complete',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    if (nameController.text != "" &&
                        priceController.text != "") {
                      Product newProduct = Product(
                          productid: product.productid,
                          name: nameController.text,
                          price: double.parse(priceController.text));
                      _databaseService.updateProductData(newProduct);
                      Navigator.of(context).pop();
                    } else {
                      error = "You must fill in the text boxes.";
                    }
                  }),
              SizedBox(height: 12.0),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
              )
            ],
          ),
        ),
      ),
    );
  }
}
