import 'package:grocero/dao/product_dao.dart';
import 'package:grocero/model/model.dart';
import 'package:grocero/model/product_model.dart';
import 'package:grocero/model/user_model.dart';

class OrderItemModel extends Model {
  int order_id;
  int product_id;
  int amount;


  static String referenceTable() => "order_item";
  String tableName() => referenceTable();

  @override
  OrderItemModel({int id, int order_id, int product_id, int amount}) : super(id: id) {
    this.order_id = order_id;
    this.product_id=product_id;
    this.amount=amount ?? 0;
  }

  @override
  OrderItemModel.fromMap(Map<String, dynamic> map) : super.fromMap(map){
    this.order_id = map['order_id'];
    this.product_id = map['product_id'];
    this.amount=map['amount'] ?? 0;
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
