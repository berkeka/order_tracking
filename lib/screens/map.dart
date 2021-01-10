import 'package:flutter/material.dart';
import 'package:order_tracking/models/user.dart';
import 'package:order_tracking/shared/constants.dart';

class Map extends StatefulWidget {
  final UserData userData;
  Map({@required this.userData});
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor[50],
      body: Container(
        child: Column(
          children: [Text(widget.userData.role)],
        ),
      ),
    );
  }
}
