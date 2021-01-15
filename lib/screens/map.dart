import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:order_tracking/models/user.dart';
import 'package:order_tracking/shared/constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:order_tracking/services/database.dart';

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

  void updateMarkers(/* changed values */) {
    _markers.forEach((marker) {});
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);
  @override
  Widget build(BuildContext context) {
    Future<List<CourierLocation>> _locations;
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
        _locations = _databaseService.getCourierLocations();
    }
    return Scaffold(
      backgroundColor: backgroundColor[50],
      body: Container(
        child: FutureBuilder<List<CourierLocation>>(
          future: _locations,
          builder: (BuildContext context,
              AsyncSnapshot<List<CourierLocation>> snapshot) {
            List<Widget> children;
            if (snapshot.hasData) {
              snapshot.data.forEach((locData) {
                _markers.add(Marker(
                  markerId: MarkerId(locData.uid),
                  position: LatLng(
                      locData.location.latitude, locData.location.longitude),
                ));
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
                const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text('Awaiting location data...'),
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
                initialCameraPosition: _kGooglePlex,
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
