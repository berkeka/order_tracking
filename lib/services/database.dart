import 'package:order_tracking/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  // collection reference
  final CollectionReference userCollection =
      Firestore.instance.collection('Users');

  Future<void> updateUserData(UserData userData) async {
    return await userCollection.document(uid).setData({
      'name': userData.name,
      'lastname': userData.lastName,
      'role': 'customer',
    });
  }
}
