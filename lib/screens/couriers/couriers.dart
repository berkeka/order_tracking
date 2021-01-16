import 'package:flutter/material.dart';
import 'package:order_tracking/models/user.dart';
import 'package:order_tracking/screens/products/product_add.dart';
import 'package:order_tracking/shared/constants.dart';
import 'package:order_tracking/services/database.dart';
import 'courier_add.dart';
import 'dart:async';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Couriers extends StatefulWidget {
  final UserData userData;
  Couriers({@required this.userData});
  @override
  _CouriersState createState() => _CouriersState();
}

class _CouriersState extends State<Couriers> {
  DatabaseService _databaseService = DatabaseService();
  @override
  Widget build(BuildContext context) {
    final _localizations = AppLocalizations.of(context);
    Future<List<UserData>> _courierList = _databaseService.getCouriers();
    UserData selectedCourierData;
    Widget cancelButton = FlatButton(
      child: Text(_localizations.cancel),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text(_localizations.continueMessage),
      onPressed: () {
        selectedCourierData.role = 'customer';
        _databaseService.updateUserData(selectedCourierData);
        Navigator.of(context).pop();
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text(_localizations.warning),
      content: Text(_localizations.deleteCourierQuestion),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(projectName),
        backgroundColor: backgroundColor[400],
        elevation: 0.0,
      ),
      backgroundColor: backgroundColor[50],
      body: Container(
        child: FutureBuilder<List<UserData>>(
          future: _courierList,
          builder:
              (BuildContext context, AsyncSnapshot<List<UserData>> snapshot) {
            List<Widget> children = <Widget>[];
            List<Widget> finalChildren = [
              ListView(
                children: children,
              ),
            ];
            if (snapshot.hasData) {
              List<UserData> courierList = snapshot.data;
              courierList.forEach((courier) {
                List<Widget> buttonChildren = [];
                if (widget.userData.role == 'admin') {
                  buttonChildren.add(
                    IconButton(
                      icon: Icon(
                        Icons.remove_circle_outline,
                        color: Colors.red[400],
                      ),
                      onPressed: () {
                        selectedCourierData = courier;
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return alert;
                          },
                        ).then(onGoBack);
                      },
                    ),
                  );                                    
                }                
                children.add(Card(
                    child: ListTile(
                  title: Text("${courier.name} ${courier.lastname}"),
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
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text(_localizations.awaitingCourierData),
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
              finalChildren.add(
                    Positioned(
                      left: 10.0,
                      bottom: 10.0,
                      child: Container(
                        width: 75.0,
                        height: 75.0,
                        child: IconButton(
                            padding: const EdgeInsets.all(0),
                            icon: Icon(
                              Icons.add_box,
                              color: backgroundColor[400],
                              size: 70,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        // Add courier page
                                        CourierAdd()),
                              ).then(onGoBack);
                            }),
                      ),
                    ),
                  );
            }
            return Center(
              child: Stack(
                children: finalChildren,
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
