import 'package:order_tracking/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  // collection reference
  final CollectionReference userCollection =
      Firestore.instance.collection('Users');

  Future<void> updateUserData(User user) async {
    return await userCollection.document(user.uid).setData({
      'name': '',
      'lastname': '',
      'role': 'customer',
    });
  }
}
