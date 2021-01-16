import 'dart:io';

import 'package:flutter/material.dart';
import 'package:order_tracking/models/product.dart';
import 'package:order_tracking/shared/constants.dart';
import 'package:order_tracking/services/database.dart';
import 'package:image_picker/image_picker.dart';

class ProductEdit extends StatefulWidget {
  final Product product;
  ProductEdit({@required this.product});
  @override
  _ProductEditState createState() => _ProductEditState();
}

class _ProductEditState extends State<ProductEdit> {
  DatabaseService _databaseService = DatabaseService();
  final _formKey = GlobalKey<FormState>();

  //For image picker
  File _image;
  final _picker = ImagePicker();

  _imgFromCamera() async {
    PickedFile image = await _picker.getImage(
      source: ImageSource.camera, imageQuality: 50
    );

    setState(() {
      _image = File(image.path);
    });
  }

  _imgFromGallery() async {
    PickedFile image = await  _picker.getImage(
        source: ImageSource.gallery, imageQuality: 50
    );

    setState(() {
      _image = File(image.path);      
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        }
      );
  }
  //For image picker

  String error = '';
  String name = '';
  String price = "0.0";
  String description = '';

  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Product product = widget.product;
    name = product.name;
    price = product.price.toString();
    description = product.description;
    nameController.text = name;
    priceController.text = price;
    descriptionController.text = description;
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
              Text('Description'),
              TextFormField(
                controller: descriptionController,
              ),
              Container(
                padding: EdgeInsets.only(top: 40.0),
                child: Text("Picture"),
              ),
              Column(
                children: <Widget>[
                  SizedBox(
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        _showPicker(context);
                      },
                      child: Container(
                        child: _image != null
                            ? Container(
                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                child : ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8.0),
                                        topRight: Radius.circular(8.0),
                                      ),
                                      child: Image.file(
                                          _image,
                                          // width: 300,
                                          height: 150,
                                          fit:BoxFit.fill
                                      ),
                                    ),
                              )
                            : Container(
                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                child : ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8.0),
                                        topRight: Radius.circular(8.0),
                                      ),
                                      child: Image.network(
                                          '${product.imageURL}',
                                          // width: 300,
                                          height: 150,
                                          fit:BoxFit.fill
                                      ),
                                    ),
                              ),
                      ),
                    ),
                  )
                ],
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
                        priceController.text != "" &&
                        descriptionController.text != "") {
                      Product newProduct = Product(
                          productid: product.productid,
                          name: nameController.text,
                          price: double.parse(priceController.text),
                          description: descriptionController.text);
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
