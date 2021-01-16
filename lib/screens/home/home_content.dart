import 'package:flutter/material.dart';
import 'package:order_tracking/models/user.dart';
import 'package:order_tracking/screens/couriers/couriers.dart';
import 'package:order_tracking/screens/orders/orders.dart';
import 'package:order_tracking/shared/constants.dart';
import 'package:order_tracking/screens/charts/pie_chart.dart';

class HomeContent extends StatefulWidget {
  final UserData userData;
  HomeContent({@required this.userData});
  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  @override
  Widget build(BuildContext context) {
    List<Widget> children = List<Widget>();
    if (widget.userData.role == 'admin') {
      children = [
        Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: ElevatedButton(
            child: Text('Couriers'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Couriers(
                          userData: widget.userData,
                        )),
              );
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: ElevatedButton(
            child: Text('Orders'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Orders(
                          userData: widget.userData,
                        )),
              );
            },
          ),
        ),
      ];
    } else if (widget.userData.role == 'courier') {
    } else {}
    return Scaffold(
      backgroundColor: backgroundColor[50],
      body: Column(children: [
        Row(
          children: children,
          ),
      BestSellingChart()
      ],
      ),
    );
  }
}
