import 'package:flutter/material.dart';
import 'package:order_tracking/models/user.dart';
import 'package:order_tracking/screens/couriers/couriers.dart';
import 'package:order_tracking/screens/orders/orders.dart';
import 'package:order_tracking/shared/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeContent extends StatefulWidget {
  final UserData userData;
  HomeContent({@required this.userData});
  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  @override
  Widget build(BuildContext context) {
    final _localizations = AppLocalizations.of(context);
    List<Widget> children = List<Widget>();
    if (widget.userData.role == 'admin') {
      children = [
        Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: ElevatedButton(
            child: Text(_localizations.couriers),
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
            child: Text(_localizations.orders),
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
      body: Container(
        child: Row(
          children: children,
        ),
      ),
    );
  }
}
