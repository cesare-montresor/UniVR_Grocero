import 'package:grocero/dao/order_dao.dart';
import 'package:grocero/model/card_model.dart';
import 'package:grocero/model/order_item_model.dart';
import 'package:grocero/model/order_model.dart';
import 'package:grocero/model/user_model.dart';
import '../component/db.dart';

class OrderItemDAO{
  static Future<List<OrderItemModel>> getCurrentOrderProduct(int product_id) async {
    OrderModel current = await OrderDAO.getCurrent();
    return await getOrderProduct(current.id, product_id);
  }

  static Future<List<OrderItemModel>> getOrderProduct(int order_id, int product_id) async {
    var rows = await DB.query(OrderItemModel.referenceTable(), where: 'order_id = ? AND product_id = ?', whereArgs: [order_id, product_id] );
    if (rows.length == 0 ){return [];}
    return [OrderItemModel.fromMap(rows[0])];
  }


  static Future<List<OrderItemModel>> getByOrderID(int order_id) async {
    String sql = """
        SELECT oi.id, order_id, product_id, amount, name, brand, qty, available, price
        FROM product p, order_item oi 
        WHERE 
          p.id = oi.product_id AND 
          oi.order_id = ?
    """;
    var rows = await DB.rawQuery( sql , [order_id] );
    List<OrderItemModel> items = [];
    for ( var row in rows ){
      items.add(OrderItemModel.fromMap(row));
    }
    return items;
  }

  static Future<int> deleteUnavailableItems(int order_id) async{
    String sql = """
      DELETE FROM order_item WHERE order_item.id IN (  
        SELECT oi.id
        FROM product p, order_item oi 
        WHERE 
          p.id = oi.product_id AND
          p.available < oi.amount AND 
          oi.order_id = ?)
    """;
    return await DB.rawDelete( sql , [ order_id ] );
  }

  static Future<int> countUnavailableItems(int order_id) async{
    String sql = """
        SELECT count(*) as count
        FROM product p, order_item oi 
        WHERE 
          p.id = oi.product_id AND
          p.available < oi.amount AND 
          oi.order_id = ?
    """;
    var rows = await DB.rawQuery( sql , [order_id] );
    if (rows.length>0){
      return rows[0]['count'];
    }
    return -1;

  }

}