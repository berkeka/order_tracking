import 'package:flutter/material.dart';
import 'package:order_tracking/models/order.dart';
import 'package:order_tracking/models/user.dart';
import 'package:order_tracking/shared/constants.dart';
import 'package:order_tracking/services/database.dart';

class ChooseCourier extends StatefulWidget {
  final Order order;
  ChooseCourier({@required this.order});
  @override
  _ChooseCourierState createState() => _ChooseCourierState();
}

class _ChooseCourierState extends State<ChooseCourier> {
  DatabaseService _databaseService = DatabaseService();
  @override
  Widget build(BuildContext context) {
    Future<List<UserData>> _courierList = _databaseService.getCouriers();
    String selectedCourierID;
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Continue"),
      onPressed: () {
        Order newOrder = widget.order;
        newOrder.courierid = selectedCourierID;
        _databaseService.updateOrderData(newOrder);
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Warning"),
      content: Text("Do you want to select this courier?"),
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
                        icon: Icon(Icons.add),
                        onPressed: () {
                          selectedCourierID = user.uid;
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
                const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text('Awaiting courier data...'),
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
