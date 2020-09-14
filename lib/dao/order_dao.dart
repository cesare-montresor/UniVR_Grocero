import 'package:grocero/component/dateutils.dart';
import 'package:grocero/main.dart';
import 'package:grocero/model/card_model.dart';
import 'package:grocero/model/order_item_model.dart';
import 'package:grocero/model/order_model.dart';
import 'package:grocero/model/user_model.dart';
import '../component/db.dart';

class OrderDAO{

  static void updateTotal(int order_id) async {
    String sql = """
      UPDATE 'order' SET 
      price = ( 
        SELECT sum(p.price * oi.amount) as tot  
        FROM product p, order_item oi 
        WHERE 
          p.id = oi.product_id AND 
          oi.order_id = "order".id 
      )
      WHERE 'order'.id = ?
    """;
    await DB.rawQuery( sql , [order_id] );
  }

  static Future<OrderModel> get(int id) async {
    var row = await DB.get( OrderModel.referenceTable(), id );
    if ( row.length == 0 ){ return null; }
    return OrderModel.fromMap(row);
  }


  static Future<OrderModel> getCurrent() async {
    UserModel user = GroceroApp.sharedApp.currentUser;
    //Search for cart
    var rows = await DB.query( OrderModel.referenceTable(), where: 'user_id = ? AND state = ?', whereArgs:[user.id, OrderState.StateCurrent] );
    if (rows.length > 0){
      return OrderModel.fromMap(rows[0]);
    }
    //Not found -> create new empty cart
    OrderModel new_order = OrderModel(
      user_id: user.id,
      creation_date: DateUtils.now(),
      price: 0.0,
      state: OrderState.StateCurrent,
    );
    int new_id = await DB.insert(new_order);
    new_order.id = new_id;
    return new_order;
  }

  //TODO add sort by
  static Future<List<OrderModel>> getHistory() async {
    UserModel user = GroceroApp.sharedApp.currentUser;
    var rows = await DB.query( OrderModel.referenceTable(), where: 'user_id = ? AND state != ?', whereArgs: [user.id,OrderState.StateCurrent] );
    List<OrderModel> orders = rows.map((row)=>OrderModel.fromMap(row)).toList();
    return orders;
  }

  static Future<List<OrderModel>> all() async {
    var rows = await DB.query( OrderModel.referenceTable());
    List<OrderModel> orders = rows.map((row)=>OrderModel.fromMap(row)).toList();
    return orders;
  }


}