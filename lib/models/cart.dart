import 'package:order_tracking/models/product.dart';

class Cart {
  static Map<String, CartData> cartItems = Map<String, CartData>();
}

class CartData{
  Product product;
  int amount;
  CartData({this.amount, this.product});
}