import 'package:grocero/dao/product_dao.dart';
import 'package:grocero/model/model.dart';
import 'package:grocero/model/product_model.dart';
import 'package:grocero/model/user_model.dart';

class OrderItemModel extends Model {
  int order_id;
  int product_id;
  int amount;

  /* from product table*/
  String name;
  String brand;
  String qty;
  int available;
  double price;

  static String referenceTable() => "order_item";
  String tableName() => referenceTable();

  @override
  OrderItemModel({int id, int order_id, int product_id, int amount, String name, String brand, String qty, int available, double price }) : super(id: id) {
    this.order_id = order_id;
    this.product_id=product_id;
    this.amount=amount ?? 0;
    /* product table*/
    this.name = name;
    this.brand = brand;
    this.qty = qty;
    this.available = available;
    this.price = price;
  }

  @override
  OrderItemModel.fromMap(Map<String, dynamic> map) : super.fromMap(map){
    this.order_id = map['order_id'];
    this.product_id = map['product_id'];
    this.amount=map['amount'] ?? 0;
    /* product table*/
    this.name = map['name'];
    this.brand = map['brand'];
    this.qty = map['qty'];
    this.available = map['available'];
    this.price = map['price'];
  }

  @override
  Map<String, dynamic> toMap() {
    var data = super.toMap();
    data["order_id"] = this.order_id;
    data["product_id"] = this.product_id;
    data["amount"] = this.amount;
    return data;
  }

}
