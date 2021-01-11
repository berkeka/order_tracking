import 'package:order_tracking/models/product.dart';
import 'package:order_tracking/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  // collection reference
  final CollectionReference userCollection =
      Firestore.instance.collection('Users');

  final CollectionReference productCollection =
      Firestore.instance.collection('Products');

  Future<void> updateUserData(UserData userData) async {
    return await userCollection.document(userData.uid).setData({
      'name': userData.name,
      'lastname': userData.lastName,
      'role': 'customer',
    });
  }

  Future<UserData> getUserData(String uid) async {
    UserData userData = UserData(uid: uid);
    await userCollection.document(uid).get().then((snapshot) {
      var data = snapshot.data;
      userData.name = data['name'];
      userData.lastName = data['lastName'];
      userData.role = data['role'];
    });
    return userData;
  }

  Future<List<Product>> getProducts() async {
    List<Product> productList = List<Product>();
    await productCollection.getDocuments().then((snapshot) {
      snapshot.documents.forEach((doc) {
        int price = doc.data['price'];
        productList
            .add(Product(name: doc.data['name'], price: price.toDouble()));
      });
    });
    return productList;
  }
}
