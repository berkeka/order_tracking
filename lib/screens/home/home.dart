import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:order_tracking/models/user.dart';
import 'package:order_tracking/screens/home/home_content.dart';
import 'package:order_tracking/screens/map.dart';
import 'package:order_tracking/screens/products/products.dart';
import 'package:order_tracking/services/auth.dart';
import 'package:order_tracking/services/database.dart';
import 'package:order_tracking/services/location_service.dart';
import 'package:provider/provider.dart';
import 'package:order_tracking/shared/constants.dart';
import 'package:location/location.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  final DatabaseService _databaseService = DatabaseService();

  // Init selected index
  int _selectedIndex = 0;

  // Callback method when selected navbar item changes
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _localizations = AppLocalizations.of(context);
    //var userLocation = Provider.of<UserLocation>(context);
    // Get user
    User user = Provider.of<User>(context);
    // Get user data as a future
    Future<UserData> _userData = _databaseService.getUserData(user.uid);
    List<Widget> actions = <Widget>[
      FlatButton.icon(
        icon: Icon(Icons.person),
        label: Text(_localizations.signout),
        onPressed: () async {
          await _auth.signOut();
        },
      ),
    ];
    return StreamProvider<UserLocation>(
      create: (context) => LocationService().locationStream,
      child: Scaffold(
        appBar: AppBar(
            title: Text(projectName),
            backgroundColor: backgroundColor[400],
            elevation: 0.0,
            actions: actions),
        body: Container(
          // This future builder will work until we receive the user data
          // Until we receive the data we will return a loading circle
          // After the data we will return the selected screen and send the userdata
          child: FutureBuilder<UserData>(
            future: _userData,
            builder: (BuildContext context, AsyncSnapshot<UserData> snapshot) {
              List<Widget> children;
              List<Widget> _widgetOptions;
              var userLocation = Provider.of<UserLocation>(context);
              UserLocation lastUserLocation;
              if (snapshot.hasData) {
                UserData userData = UserData(
                    uid: snapshot.data.uid,
                    name: snapshot.data.name,
                    lastname: snapshot.data.lastname,
                    role: snapshot.data.role);
                // Set widget options for navbar
                _widgetOptions = <Widget>[
                  HomeContent(userData: userData),
                  Map(userData: userData),
                  Products(userData: userData),
                ];
                if (userData.role == 'customer' && _selectedIndex == 2) {
                  actions.insert(
                    0,
                    IconButton(
                      icon: Icon(Icons.shopping_cart),
                      color: Colors.black,
                      onPressed: () {
                        // Navigate to cart page
                      },
                    ),
                  );
                } else if (userData.role == 'courier') {
                  // If location data changed
                  // Send it to the database
                  if (userLocation != null &&
                      userLocation != lastUserLocation) {
                    lastUserLocation = userLocation;
                    _databaseService.updateCourierLocation(
                      CourierLocation(
                        uid: userData.uid,
                        location: GeoPoint(
                          userLocation.latitude,
                          userLocation.longitude,
                        ),
                      ),
                    );
                  }
                }
                // If userdata is present return selected screen
                return Scaffold(
                  body: Center(
                    child: _widgetOptions.elementAt(_selectedIndex),
                  ),
                );
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
                    child: Text(_localizations.awaitingUserData),
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
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.home), label: _localizations.home),
            BottomNavigationBarItem(
                icon: Icon(Icons.map), label: _localizations.map),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart),
                label: _localizations.products),
          ],
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          backgroundColor: Colors.blue[400],
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white.withOpacity(.60),
          selectedFontSize: 14,
          unselectedFontSize: 14,
        ),
      ),
    );
  }
}
