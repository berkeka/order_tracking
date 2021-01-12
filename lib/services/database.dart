import 'package:order_tracking/models/product.dart';
import 'package:order_tracking/models/user.dart';
import 'package:order_tracking/models/order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
        productList.add(Product(name: doc.data['name'], price: price));
      });
    });
    return productList;
  }
}
