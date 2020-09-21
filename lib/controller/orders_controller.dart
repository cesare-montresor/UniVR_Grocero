import 'package:flutter/widgets.dart';
import 'package:grocero/component/auth.dart';
import 'package:grocero/component/dateutils.dart';
import 'package:grocero/controller/controller.dart';
import 'package:grocero/main.dart';
import 'package:grocero/model/user_model.dart';
import 'package:grocero/routes.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocero/model/product_model.dart';
import 'package:grocero/model/user_model.dart';
import 'package:grocero/dao/order_dao.dart';
import 'package:grocero/main.dart';
import 'package:grocero/model/order_model.dart';

class OrdersScreenController extends Controller{
  Future<List<OrderModel>> orders;

  void init() {
    UserModel user = GroceroApp.sharedApp.currentUser;
    if (user.isWorker()) {
      this.orders = GroceroApp.sharedApp.dao.Order.all();
    }else{
      this.orders = GroceroApp.sharedApp.dao.Order.getHistory();
    }
  }

  String stateToText(String state){
    if ( state == OrderState.StateCurrent ) {return "Aperto";}
    if ( state == OrderState.StateConfirm ) {return "Confermato";}
    if ( state == OrderState.StateProcess ) {return "In lavorazione";}
    if ( state == OrderState.StateDelivery ) {return "Spedito";}
    return state;
  }

  void onTapRow(BuildContext context, OrderModel order){
    Navigator.of(context).pushNamed( Router.RouteOrderDetail , arguments: {'order_id':order.id} );
  }

  String formatCreationDate(int timestamp){
    return DateUtils.formatDate(timestamp);
  }

  String formatCreationAge(int timestamp){
    return DateUtils.formatAge(timestamp);
  }


}