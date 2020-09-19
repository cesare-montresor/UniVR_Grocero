import 'package:grocero/dao/card_dao.dart';
import 'package:grocero/dao/category_dao.dart';
import 'package:grocero/dao/order_dao.dart';
import 'package:grocero/dao/order_item_dao.dart';
import 'package:grocero/dao/product_dao.dart';
import 'package:grocero/dao/user_dao.dart';
import 'package:grocero/dao/worker_dao.dart';

abstract class DAO{
  CardDAO get Card;
  CategoryDAO get Category;
  OrderDAO get Order;
  OrderItemDAO get OrderItem;
  ProductDAO get Product;
  UserDAO get User;
  WorkerDAO get Worker;
}

class LocalDAO implements DAO{
  final CardDAO _card = LocalCardDAO();
  final CategoryDAO _category= LocalCategoryDAO();
  final OrderDAO _order= LocalOrderDAO();
  final OrderItemDAO _order_item= LocalOrderItemDAO();
  final ProductDAO _product=LocalProductDAO();
  final UserDAO _user=LocalUserDAO();
  final WorkerDAO _worker=LocalWorkerDAO();

  CardDAO get Card=>_card;
  CategoryDAO get Category=>_category;
  OrderDAO get Order=>_order;
  OrderItemDAO get OrderItem=>_order_item;
  ProductDAO get Product=>_product;
  UserDAO get User=>_user;
  WorkerDAO get Worker=>_worker;

  LocalDAO();
}