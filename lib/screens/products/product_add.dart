import 'package:flutter/material.dart';
import 'package:order_tracking/models/product.dart';
import 'package:order_tracking/shared/constants.dart';
import 'package:order_tracking/services/database.dart';

class ProductAdd extends StatefulWidget {
  @override
  _ProductAddState createState() => _ProductAddState();
}

class _ProductAddState extends State<ProductAdd> {
  DatabaseService _databaseService = DatabaseService();
  final _formKey = GlobalKey<FormState>();

  String error = '';
  String name = '';
  String price = '';
  String description = '';

  @override
  Widget build(BuildContext context) {
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
                validator: (val) =>
                    (val.isEmpty) ? 'Enter a different name' : null,
                onChanged: (val) {
                  setState(() => name = val);
                },
              ),
              SizedBox(height: 10.0),
              Text('Price'),
              TextFormField(
                validator: (val) =>
                    val.isEmpty ? 'Enter a different price' : null,
                onChanged: (val) {
                  setState(() => price = val);
                },
              ),
              SizedBox(height: 10.0),
              Text('Description'),
              TextFormField(
                validator: (val) =>
                    val.isEmpty ? 'Enter a different description' : null,
                onChanged: (val) {
                  setState(() => description = val);
                },
              ),
              SizedBox(height: 10.0),
              RaisedButton(
                  color: backgroundColor[400],
                  child: Text(
                    'Complete',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      Product newProduct =
                          Product(name: name, description: description, price: double.parse(price));
                      _databaseService.createProductData(newProduct);
                      Navigator.of(context).pop();
                    }
                  }),
              SizedBox(height: 12.0),
            ],
          ),
        ),
      ),
    );
  }
}
