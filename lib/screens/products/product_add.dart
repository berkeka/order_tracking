import 'dart:io';

import 'package:image_picker/image_picker.dart';
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
              //For image picker
              Column(
                children: <Widget>[
                  SizedBox(
                    height: 32,
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        _showPicker(context);
                      },
                      child: CircleAvatar(
                        radius: 55,
                        backgroundColor: Color(0xffFDCF09),
                        child: _image != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.file(
                                  _image,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.fitHeight,
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(50)),
                                width: 100,
                                height: 100,
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.grey[800],
                                ),
                              ),
                      ),
                    ),
                  )
                ],
              ),
              //For image picker
              RaisedButton(
                  color: backgroundColor[400],
                  child: Text(
                    'Complete',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      String url;
                      await _databaseService.uploadImageToFirebase(_image).then((value) => url = value);
                      Product newProduct =
                          Product(name: name, description: description, price: double.parse(price), imageURL: url);
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
