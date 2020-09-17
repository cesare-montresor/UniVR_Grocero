import 'package:grocero/dao/order_dao.dart';
import 'package:grocero/model/card_model.dart';
import 'package:grocero/model/order_item_model.dart';
import 'package:grocero/model/order_model.dart';
import 'package:grocero/model/product_model.dart';
import 'package:grocero/model/user_model.dart';
import '../component/db.dart';

class ProductDAO{
  static Future<ProductModel> get(int id) async {
    var rows = await DB.query( ProductModel.referenceTable(), where: 'id = ?', whereArgs: [id] );
    if (rows.length == 0) { return null; }
    return ProductModel.fromMap(rows[0]);
  }

  static Future<List<ProductModel>> all({String searchBy, String orderBy, bool reverse}) async {
    if (orderBy == null){ orderBy = 'brand'; }
    if (reverse == null){ reverse = false; }
    orderBy += (reverse?' ASC':' DESC');

    searchBy = searchBy.trim();
    String where;
    List<dynamic> whereArgs;
    if (searchBy != null && searchBy !='') {
      String s = '%' + searchBy.replaceAll('%', '') + '%';
      where = ' name LIKE ? OR brand LIKE ? OR type LIKE ? OR tags LIKE ? ';
      whereArgs = [s, s, s, s];
    }

    var rows = await DB.query( ProductModel.referenceTable(), where: where, whereArgs: whereArgs, orderBy: orderBy );

    List<ProductModel> products = [];
    for ( var row in rows ){
      products.add(ProductModel.fromMap(row));
    }
    return products;
  }


  static Future<List<ProductModel>> getByCategoryID(int category_id, {String searchBy, String orderBy, bool reverse}) async {
    if (orderBy == null){ orderBy = 'brand'; }
    if (reverse == null){ reverse = false; }
    orderBy += (reverse?' DESC':' ASC');

    searchBy = searchBy.trim();
    String where = 'category_id = ?';
    List<dynamic> whereArgs = [category_id];
    if (searchBy != null && searchBy !='') {
      String s = '%' + searchBy.replaceAll('%', '') + '%';
      where +=
      ' AND ( name LIKE ? OR brand LIKE ? OR type LIKE ? OR tags LIKE ? )';
      whereArgs.addAll([s, s, s, s]);
    }

    var rows = await DB.query( ProductModel.referenceTable(), where: where, whereArgs: whereArgs, orderBy: orderBy );
    List<ProductModel> products = [];
    for ( var row in rows ){
      products.add(ProductModel.fromMap(row));
    }
    return products;
  }

  static Future<List<ProductModel>> getCurrentOrder({String searchBy, String orderBy, bool reverse}) async {
    OrderModel order = await OrderDAO.getCurrent();
    return await getOrderID(order.id, searchBy:searchBy, orderBy: orderBy, reverse: reverse );
  }

  static Future<List<ProductModel>> getOrderID(int order_id, {String searchBy, String orderBy, bool reverse}) async {
    if (orderBy == null){ orderBy = 'brand'; }
    if (reverse == null){ reverse = false; }
    orderBy += (reverse?' ASC':' DESC');

    searchBy = searchBy.trim();
    String whereSearch = '';
    List<dynamic> args = [order_id] ;
    if (searchBy != null && searchBy !='') {
      String s = '%' + searchBy.replaceAll('%', '') + '%';
      whereSearch += ' AND ( p.name LIKE ? OR p.brand LIKE ? OR p.type LIKE ? OR p.tags LIKE ? )';
      args.addAll([s, s, s, s]);
    }

    String sql = """
        SELECT distinct p.*   
        FROM product p, order_item oi 
        WHERE 
          p.id = oi.product_id AND 
          oi.order_id = ? $whereSearch
        ORDER by $orderBy
    """;
    var rows = await DB.rawQuery( sql , args);

    List<ProductModel> products = [];
    for ( var row in rows ){
      products.add(ProductModel.fromMap(row));
    }
    return products;
  }




}