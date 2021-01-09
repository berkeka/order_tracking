import 'package:flutter/material.dart';
import 'package:order_tracking/services/auth.dart';
import 'package:order_tracking/shared/constants.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: backgroundColor[50],
        appBar: AppBar(
          title: Text(projectName),
          backgroundColor: backgroundColor[400],
          elevation: 0.0,
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.person),
              label: Text('Logout'),
              onPressed: () async {
                await _auth.signOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}
