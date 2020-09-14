import 'package:grocero/dao/order_item_dao.dart';
import 'package:grocero/model/model.dart';
import 'package:grocero/model/order_item_model.dart';
import 'package:grocero/model/user_model.dart';

class OrderState{
  static String StateCurrent = "current";
  static String StateConfirm = "confirm";
  static String StateProcess = "process";
  static String StateDelivery = "delivery";
}

class OrderModel extends Model {
  int user_id;
  String state;
  int creation_date;
  int delivery_date;
  int delivery_interval;
  double price;
  String payment_type;
  int points;
  List<OrderItemModel> _items;

  static String referenceTable() => "order";
  String tableName() => referenceTable();

  @override
  OrderModel({int id, int user_id, String state, int creation_date, int delivery_date, int delivery_interval, double price, String payment_type, int points}) : super(id: id) {
    this.user_id = user_id;
    this.state=state ?? "";
    this.creation_date=creation_date ?? 0;
    this.delivery_date=delivery_date ?? 0;
    this.delivery_interval=delivery_interval ?? 0;
    this.price=price ?? 0.0;
    this.payment_type=payment_type ?? PaymentType.Cash;
    this.points=points ?? 0;
  }

  @override
  OrderModel.fromMap(Map<String, dynamic> map) : super.fromMap(map){
    this.user_id = map['user_id'];
    this.state = map['state'];
    this.creation_date=map['creation_date'] ?? 0;
    this.delivery_date = map['delivery_date'];
    this.delivery_interval = map['delivery_interval'];
    this.price =  (map['price']??0.0)*1.0;
    this.payment_type = map['payment_type'];
    this.points=map['points'] ?? 0;
  }



  @override
  Map<String, dynamic> toMap() {
    var data = super.toMap();
    data["user_id"] = this.user_id;
    data["state"] = this.state;
    data["creation_date"] = this.creation_date;
    data["delivery_date"] = this.delivery_date;
    data["delivery_interval"] = this.delivery_interval;
    data["price"] = this.price;
    data["payment_type"] = this.payment_type;
    data["points"] = this.points;
    return data;
  }

  Future<List<OrderItemModel>> getItems() async {
    if (_items == null){
      _items = await OrderItemDAO.getByOrderID(this.id);
    }
    return _items;
  }


}
