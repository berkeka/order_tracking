import 'dart:async';

import 'package:flutter/material.dart';
import 'package:order_tracking/models/user.dart';
import 'package:order_tracking/models/order.dart';
import 'package:order_tracking/screens/couriers/choose_courier.dart';
import 'package:order_tracking/shared/constants.dart';
import 'package:order_tracking/services/database.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Orders extends StatefulWidget {
  final UserData userData;
  Orders({@required this.userData});
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  DatabaseService _databaseService = DatabaseService();
  @override
  Widget build(BuildContext context) {
    final _localizations = AppLocalizations.of(context);
    Future<List<Order>> _orderList = _databaseService.getOrders();
    return Scaffold(
      appBar: AppBar(
        title: Text(projectName),
        backgroundColor: backgroundColor[400],
        elevation: 0.0,
      ),
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
                Color color;
                Widget trailing;
                if (order.courierid == '') {
                  color = Colors.red[300];
                  trailing = IconButton(
                    icon: Icon(
                      Icons.add,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChooseCourier(order: order)),
                      ).then(onGoBack);
                    },
                  );
                } else {
                  color = Colors.green[300];
                  trailing = null;
                }
                children.add(Card(
                    child: ListTile(
                  title: Text(order.orderid),
                  subtitle: Text(_localizations.orderDate +
                      ": " +
                      order.orderdate.toString()),
                  leading: Icon(
                    Icons.circle,
                    color: color,
                    size: 45,
                  ),
                  trailing: trailing,
                  tileColor: backgroundColor[25],
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

  FutureOr onGoBack(dynamic value) {
    setState(() {});
  }
}
