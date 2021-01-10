import 'package:flutter/material.dart';
import 'package:order_tracking/models/user.dart';
import 'package:order_tracking/shared/constants.dart';

class HomeContent extends StatefulWidget {
  final UserData userData;
  HomeContent({@required this.userData});
  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
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
