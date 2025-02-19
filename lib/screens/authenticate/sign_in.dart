import 'package:order_tracking/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:order_tracking/shared/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = '';

  // text field state
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    final _localizations = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: backgroundColor[50],
      appBar: AppBar(
        backgroundColor: backgroundColor[400],
        elevation: 0.0,
        title: Text('Sign in to $projectName'),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text(_localizations.signUp),
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
                    _localizations.signIn,
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      dynamic result = await _auth.signInWithEmailAndPassword(
                          email, password);
                      if (result == null) {
                        setState(() {
                          error = _localizations.wrongCreds;
                        });
                      }
                    }
                  }),
              SizedBox(height: 12.0),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
