class Order {
  String orderid;
  String courierid;
  String customerid;
  List<dynamic> products;
  DateTime orderdate;
  bool isdelivered;

  Order(
      {this.orderid,
      this.courierid,
      this.customerid,
      this.products,
      this.orderdate,
      this.isdelivered});
}
