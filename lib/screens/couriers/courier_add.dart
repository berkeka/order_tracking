import 'package:flutter/material.dart';
import 'package:order_tracking/models/user.dart';
import 'package:order_tracking/screens/products/product_add.dart';
import 'package:order_tracking/shared/constants.dart';
import 'package:order_tracking/services/database.dart';
import 'courier_add.dart';
import 'dart:async';

class CourierAdd extends StatefulWidget {  
  @override
  _CourierAddState createState() => _CourierAddState();
}

class _CourierAddState extends State<CourierAdd> {
  DatabaseService _databaseService = DatabaseService();
  @override
  Widget build(BuildContext context) {
    Future<List<UserData>> _customerList = _databaseService.getCustomers();
    
    return Scaffold(
      appBar: AppBar(
        title: Text(projectName),
        backgroundColor: backgroundColor[400],
        elevation: 0.0,
      ),
      backgroundColor: backgroundColor[50],
      body: Container(
        child: FutureBuilder<List<UserData>>(
          future: _customerList,
          builder:
              (BuildContext context, AsyncSnapshot<List<UserData>> snapshot) {
            List<Widget> children = <Widget>[];
            if (snapshot.hasData) {
              List<UserData> customerList = snapshot.data;
              customerList.forEach((customer) {
                List<Widget> buttonChildren = [];
                children.add(Card(
                    child: ListTile(
                  title: Text("${customer.name} ${customer.lastname}"),
                  tileColor: backgroundColor[25],
                  trailing:
                    IconButton(
                      icon: Icon(Icons.add), 
                      onPressed: () => {customer.role = 'courier', _databaseService.updateUserData(customer), Navigator.of(context).pop()}
                    ),
                  ),
                )
                );
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
            return Center(
              child: ListView(
                children: children,
              ),
            );
          },
        ),
      ),
    );
  }

  /*

*/
  // Refresh page on fallback
  FutureOr onGoBack(dynamic value) {
    setState(() {});
  }
}
