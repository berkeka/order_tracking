import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;

  User({this.uid});
}

class UserData {
  final String uid;
  String name;
  String lastname;
  String role;

  UserData({this.uid, this.name, this.lastname, this.role});
}

class CourierLocation {
  final String uid;
  GeoPoint location;
  bool hasorder;
  String customerid;
  CourierLocation({this.uid, this.location, this.hasorder, this.customerid});
}
