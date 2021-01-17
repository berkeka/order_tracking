import 'dart:async';

import 'package:flutter/material.dart';
import 'package:order_tracking/models/user.dart';
import 'package:order_tracking/models/order.dart';
import 'package:order_tracking/shared/constants.dart';
import 'package:order_tracking/services/database.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CompleteSale extends StatefulWidget {
  final UserData userData;
  CompleteSale({@required this.userData});
  @override
  _CompleteSaleState createState() => _CompleteSaleState();
}

class _CompleteSaleState extends State<CompleteSale> {
  DatabaseService _databaseService = DatabaseService();
  @override
  Widget build(BuildContext context) {
    final _localizations = AppLocalizations.of(context);
    String selectedOrderID;
    Widget cancelButton = FlatButton(
      child: Text(_localizations.cancel),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget debitButton = FlatButton(
      child: Text(_localizations.debitMessage),
      onPressed: () {
        _databaseService.orderCollection
            .document(selectedOrderID)
            .get()
            .then((value) => {
                  _databaseService.courierLocationCollection
                      .document(value.data["courierid"])
                      .updateData({"customerid": ""})
                });
        _databaseService.orderCollection.document(selectedOrderID).updateData(
            {"isdelivered": true, "paymentoption": "debit", "courierid": ""});
        Navigator.of(context).pop();
      },
    );
    Widget cashButton = FlatButton(
      child: Text(_localizations.cashMessage),
      onPressed: () {
        _databaseService.orderCollection
            .document(selectedOrderID)
            .get()
            .then((value) => {
                  _databaseService.courierLocationCollection
                      .document(value.data["courierid"])
                      .updateData({"customerid": ""})
                });
        _databaseService.orderCollection.document(selectedOrderID).updateData(
            {"isdelivered": true, "paymentoption": "cash", "courierid": ""});
        Navigator.of(context).pop();
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text(_localizations.warning),
      content: Text(_localizations.selectPaymentQuestion),
      actions: [
        cancelButton,
        debitButton,
        cashButton,
      ],
    );

    Future<List<Order>> _orderList = _databaseService.getOrders();
    return Scaffold(
      backgroundColor: backgroundColor[50],
      body: Container(
        child: FutureBuilder<List<Order>>(
          future: _orderList,
          builder: (BuildContext context, AsyncSnapshot<List<Order>> snapshot) {
            List<Widget> children;
            if (snapshot.hasData) {
              children = <Widget>[];
              List<Order> orderList = snapshot.data;
              orderList.forEach((order) {
                List<Widget> buttonChildren = [];
                if (order.courierid == widget.userData.uid) {
                  buttonChildren.add(
                    IconButton(
                      icon: Icon(
                        Icons.done,
                        color: Colors.blue[400],
                      ),
                      onPressed: () {
                        selectedOrderID = order.orderid;
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return alert;
                          },
                        ).then(onGoBack);
                      },
                    ),
                  );
                  children.add(Card(
                      child: ListTile(
                    title: Text(order.orderid),
                    subtitle: Text(_localizations.orderDate +
                        ": " +
                        order.orderdate.toString()),
                    tileColor: backgroundColor[25],
                    trailing: Wrap(
                      children: buttonChildren,
                    ),
                  )));
                }
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
                  child: Text(_localizations.awaitingOrderData),
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
            return Wrap(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.07,
                  child: Center(
                    child: Text(
                      _localizations.ordersToDeliver,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: Center(
                    child: ListView(
                      children: children,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  FutureOr onGoBack(dynamic value) {
    setState(() {});
  }
}
