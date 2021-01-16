import 'package:flutter/material.dart';
import 'package:order_tracking/models/user.dart';
import 'package:order_tracking/shared/constants.dart';
import 'package:order_tracking/services/database.dart';
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
            List<Widget> children;
            if (snapshot.hasData) {
              children = <Widget>[];
              List<UserData> courierList = snapshot.data;
              courierList.forEach((user) {
                children.add(Card(
                    child: ListTile(
                  title: Text("${user.name} ${user.lastname}"),
                  tileColor: backgroundColor[25],
                  trailing: Wrap(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.remove_circle_outline),
                        onPressed: () {
                          selectedCourierData = user;
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return alert;
                            },
                          );
                        },
                      ),
                    ],
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
}
