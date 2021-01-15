import 'dart:io';

import 'package:order_tracking/models/product.dart';
import 'package:order_tracking/models/user.dart';
import 'package:order_tracking/models/order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' ;
import 'package:path/path.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  // collection reference
  final CollectionReference userCollection =
      Firestore.instance.collection('Users');

  final CollectionReference productCollection =
      Firestore.instance.collection('Products');

  final CollectionReference orderCollection =
      Firestore.instance.collection('Orders');

  final CollectionReference courierLocationCollection =
      Firestore.instance.collection('CourierLocations');

  Future<void> updateUserData(UserData userData) async {
    return await userCollection.document(userData.uid).setData({
      'name': userData.name,
      'lastname': userData.lastname,
      'role': userData.role,
    });
  }

  Future<void> updateOrderData(Order order) async {
    return await orderCollection.document(order.orderid).setData({
      'courierid': order.courierid,
      'customerid': order.customerid,
      'isdelivered': order.isdelivered,
      'orderdate': Timestamp.fromDate(order.orderdate),
      'products': order.products,
    });
  }

  Future updateProductData(Product product) async {
    //print(product.name + " " + product.price.toString());
    return await productCollection.document(product.productid).setData({
      'name': product.name,
      'description' : product.description,
      'price': product.price.toString(),
    });
  }

  Future createCourierLocation(String courierID) async {
    return await courierLocationCollection.document(courierID).setData({
      'hasorder': false,
      'location': GeoPoint(0.0, 0.0),
    });
  }

  Future updateCourierLocation(CourierLocation courierLocation) async {
    return await courierLocationCollection
        .document(courierLocation.uid)
        .updateData({
      'hasorder': courierLocation.hasorder,
      'location': courierLocation.location,
    });
  }

  Future createProductData(Product product) async {
    return await productCollection.document().setData({
      'name': product.name,
      'description': product.description,
      'price': product.price.toString(),
    });
  }

  Future deleteProduct(String productid) async {
    await productCollection.document(productid).delete();
  }

  Future<UserData> getUserData(String uid) async {
    UserData userData = UserData(uid: uid);
    await userCollection.document(uid).get().then((snapshot) {
      var data = snapshot.data;
      userData.name = data['name'];
      userData.lastname = data['lastname'];
      userData.role = data['role'];
    });
    return userData;
  }

  Future<List<UserData>> getCouriers() async {
    List<UserData> courierList = List<UserData>();
    await userCollection
        .where('role', isEqualTo: 'courier')
        .getDocuments()
        .then((snapshot) {
      snapshot.documents.forEach((user) {
        courierList.add(UserData(
            uid: user.documentID,
            name: user.data['name'],
            lastname: user.data['lastname'],
            role: user.data['role']));
      });
    });
    return courierList;
  }

  Future<List<Order>> getOrders() async {
    List<Order> orderList = List<Order>();
    await orderCollection
        .where('isdelivered', isEqualTo: false)
        .getDocuments()
        .then((snapshot) {
      snapshot.documents.forEach((order) {
        Timestamp orderts = order.data['orderdate'];
        orderList.add(Order(
            orderid: order.documentID,
            courierid: order.data['courierid'],
            customerid: order.data['customerid'],
            products: order.data['products'],
            orderdate: orderts.toDate(),
            isdelivered: false));
      });
    });
    return orderList;
  }

  Future<List<Product>> getProducts() async {
    List<Product> productList = List<Product>();
    await productCollection.getDocuments().then((snapshot) {
      snapshot.documents.forEach((doc) {
        double price = double.parse(doc.data['price']);
        productList.add(Product(
            name: doc.data['name'], description: doc.data['description'], price: price, productid: doc.documentID));
      });
    });
    return productList;
  }

  Future<List<CourierLocation>> getCourierLocations() async {
    List<CourierLocation> _courierLocations = List<CourierLocation>();
    await courierLocationCollection.getDocuments().then((snapshot) {
      snapshot.documents.forEach((document) {
        _courierLocations.add(CourierLocation(
          uid: document.documentID,
          location: document.data['location'],
          hasorder: document.data['hasorder'],
        ));
      });
    });
    return _courierLocations;
  }

  Future<List<CourierLocation>> getCouriersForCustomer(
      String customerid) async {
    List<int> _courierIDs = List<int>();
    List<CourierLocation> _courierLocations = List<CourierLocation>();
    // Get courier ids for every order which are related to our customer and not delivered
    await orderCollection.getDocuments().then((snapshot) {
      snapshot.documents
          .where((document) =>
              document.data['isdelivered'] == false &&
              document.data['customerid'] == customerid)
          .forEach((order) {
        _courierIDs.add(order.data['courierid']);
      });
    });

    // Using the courier ids we gathered in the method above
    // We now get locations of our couriers
    await courierLocationCollection.getDocuments().then((snapshot) {
      snapshot.documents.forEach((document) {
        if (_courierIDs.contains(document.data['courierid'])) {
          _courierLocations.add(CourierLocation(
            uid: document.documentID,
            location: document.data['location'],
            hasorder: document.data['hasorder'],
          ));
        }
      });
    });
    return _courierLocations;
  }

  Future<List<CourierLocation>> getDeliveryLocationforCourier(
      String courierid) async {
    List<CourierLocation> _deliveryLocations = List<CourierLocation>();
    // Get courier ids for every order which are related to our customer and not delivered
    await orderCollection.getDocuments().then((snapshot) {
      snapshot.documents
          .where((document) =>
              document.data['isdelivered'] == false &&
              document.data['courierid'] == courierid)
          .forEach((order) {
        _deliveryLocations.add(CourierLocation(
            uid: order.data['customerid'],
            location: order.data['deliverylocation']));
      });
    });
    return _deliveryLocations;
  }
  
  Future<String> uploadImageToFirebase(var imageFile) async {
    StorageReference ref = FirebaseStorage.instance.ref().child("/photo.jpg");
    StorageUploadTask uploadTask = ref.putFile(imageFile);

    var dowurl = await (await uploadTask.onComplete).ref.getDownloadURL();
    String url = dowurl.toString();

    return url; 
  }
}