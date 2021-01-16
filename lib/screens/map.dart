import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:order_tracking/models/user.dart';
import 'package:order_tracking/shared/constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:order_tracking/services/database.dart';
import 'package:order_tracking/services/location_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Map extends StatefulWidget {
  final UserData userData;
  Map({@required this.userData});
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  Completer<GoogleMapController> _controller = Completer();
  DatabaseService _databaseService = DatabaseService();

  Set<Marker> _markers = Set<Marker>();

  @override
  Widget build(BuildContext context) {
    final _localizations = AppLocalizations.of(context);
    // Get location data from stream
    var userLocation = Provider.of<UserLocation>(context);
    final CameraPosition _startPos = CameraPosition(
        target: LatLng(userLocation.latitude, userLocation.longitude),
        zoom: 15.0);
    // Create a future list for locations
    Future<List<CourierLocation>> _locations;
    Future<Stream> _locStream;
    switch (widget.userData.role) {
      case 'customer':
        // Customer will see only the couriers that will deliver them their orders
        _locations =
            _databaseService.getCouriersForCustomer(widget.userData.uid);
        break;
      case 'courier':
        // Courier will see only the address the address he/she needs to deliver
        _locations =
            _databaseService.getDeliveryLocationforCourier(widget.userData.uid);
        break;
      default:
        // Admin will see all of the couriers on the map
        _locStream = _databaseService.getLocationChange();
        _locations = _databaseService.getCourierLocations();
    }
    return Scaffold(
      backgroundColor: backgroundColor[50],
      body: Container(
        child: FutureBuilder<List<dynamic>>(
          future: Future.wait([_locations, _locStream]),
          builder:
              (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
            List<Widget> children;
            if (snapshot.hasData) {
              snapshot.data[0].forEach((locData) {
                _markers.add(Marker(
                  markerId: MarkerId(locData.uid),
                  position: LatLng(
                      locData.location.latitude, locData.location.longitude),
                ));
              });
              snapshot.data[1].listen((QuerySnapshot value) {
                value.documentChanges.forEach((documentChange) {
                  DocumentSnapshot document = documentChange.document;
                  // If marker for this courier exists
                  // Update or create marker data
                  if (document != null) {
                    _markers.add(
                      Marker(
                        markerId: MarkerId(document.documentID),
                        position: LatLng(document.data['location'].latitude,
                            document.data['location'].longitude),
                      ),
                    );
                  }
                });
              });
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
                  child: Text(_localizations.awaitingLocationData),
                )
              ];
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: children,
                ),
              );
            }
            return Scaffold(
              body: GoogleMap(
                mapType: MapType.hybrid,
                initialCameraPosition: _startPos,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                markers: _markers,
              ),
            );
          },
        ),
      ),
    );
  }
}
