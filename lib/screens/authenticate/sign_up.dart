import 'package:order_tracking/models/user.dart';
import 'package:order_tracking/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:order_tracking/services/database.dart';
import 'package:order_tracking/shared/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignUp extends StatefulWidget {
  final Function toggleView;
  SignUp({this.toggleView});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = '';

  // text field state
  String email = '';
  String name = '';
  String lastname = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    final _localizations = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: backgroundColor[50],
      appBar: AppBar(
        backgroundColor: backgroundColor[400],
        elevation: 0.0,
        title: Text('Sign up to $projectName'),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text(_localizations.signIn),
            onPressed: () => widget.toggleView(),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 10.0),
              TextFormField(
                validator: (val) =>
                    val.isEmpty ? _localizations.enterEmail : null,
                onChanged: (val) {
                  setState(() => email = val);
                },
                decoration: InputDecoration(labelText: 'email'),
              ),
              SizedBox(height: 10.0),
              TextFormField(
                validator: (val) =>
                    val.isEmpty ? _localizations.enterName : null,
                onChanged: (val) {
                  setState(() => name = val);
                },
                decoration: InputDecoration(labelText: _localizations.name),
              ),
              SizedBox(height: 10.0),
              TextFormField(
                validator: (val) =>
                    val.isEmpty ? _localizations.enterLastname : null,
                onChanged: (val) {
                  setState(() => lastname = val);
                },
                decoration: InputDecoration(labelText: _localizations.lastname),
              ),
              SizedBox(height: 10.0),
              TextFormField(
                obscureText: true,
                validator: (val) => val.length < 6
                    ? _localizations.passwordLengthWarning
                    : null,
                onChanged: (val) {
                  setState(() => password = val);
                },
                decoration: InputDecoration(labelText: _localizations.password),
              ),
              SizedBox(height: 10.0),
              RaisedButton(
                  color: backgroundColor[400],
                  child: Text(
                    _localizations.signUp,
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      dynamic result = await _auth.registerWithEmailAndPassword(
                          email, password);
                      if (result == null) {
                        setState(() {
                          error = _localizations.validEmailWarning;
                        });
                      } else {
                        DatabaseService ds = DatabaseService();
                        UserData userData = UserData(
                            uid: result.uid,
                            name: name,
                            lastname: lastname,
                            role: 'customer');
                        ds.updateUserData(userData);
                        if (userData.role == 'courier') {
                          ds.createCourierLocation(userData.uid);
                        }
                      }
                    }
                  }),
              SizedBox(height: 12.0),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
              )
            ],
          ),
        ),
      ),
    );
  }
}
