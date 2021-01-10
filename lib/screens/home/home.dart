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
    Future<UserData> _userData = _databaseService.getUserData(user.uid);

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
          child: FutureBuilder<UserData>(
            future: _userData, // a previously-obtained Future<String> or null
            builder: (BuildContext context, AsyncSnapshot<UserData> snapshot) {
              List<Widget> children;
              if (snapshot.hasData) {
                if (snapshot.data.role == 'admin') {
                  children = <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text('${snapshot.data.role}'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text('Name: ${snapshot.data.name}'),
                    )
                  ];
                } else if (snapshot.data.role == 'courier') {
                  children = <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text('${snapshot.data.role}'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text('Name: ${snapshot.data.name}'),
                    )
                  ];
                } else {
                  children = <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text('${snapshot.data.role}'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text('Name: ${snapshot.data.name}'),
                    )
                  ];
                }
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
                    child: Text('Awaiting result...'),
                  )
                ];
              }
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: children,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
