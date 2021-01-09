import 'package:flutter/material.dart';
import 'package:order_tracking/models/user.dart';
import 'package:order_tracking/services/auth.dart';
import 'package:order_tracking/services/database.dart';
import 'package:order_tracking/shared/constants.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();
  final DatabaseService _databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);

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
        body: Container(
          child: Text(user.uid),
        ),
      ),
    );
  }
}
