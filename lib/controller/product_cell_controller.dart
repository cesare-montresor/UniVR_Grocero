import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grocero/component/auth.dart';
import 'package:grocero/component/db.dart';
import 'package:grocero/controller/controller.dart';
import 'package:grocero/main.dart';
import 'package:grocero/model/order_item_model.dart';
import 'package:grocero/model/order_model.dart';
import 'package:grocero/model/product_model.dart';
import 'package:grocero/model/user_model.dart';
import 'package:grocero/routes.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProductCellController extends Controller{
  bool activeOrder;
  Future<List<OrderItemModel>> order_item;
  OrderModel order;
  ProductModel product;
  Widget availableText;
  TextEditingController qty_controller;
  Widget last_order_item_widget = Container();

  void init( ProductModel product, OrderModel order){
    this.product = product;
    this.order = order;
    activeOrder = (order.state == OrderState.StateCurrent);

    product = product;
    order = order;

    availableText = (product.available > 0) ? Container(width: 0, height: 0) : Text("NON DISPONIBILE", style: TextStyle(color: Colors.deepOrange, fontSize: 10));
    qty_controller = TextEditingController();
    refreshData();
  }

  void dispose() {
    qty_controller.dispose();
  }

  void refreshData(){
    order_item = GroceroApp.sharedApp.dao.OrderItem.getOrderProduct(order.id, product.id);
  }

  Future<void> changeQuantity(int delta, {String text})  async {
    // Update UI

    int amount = int.tryParse(text == null? qty_controller.text: text) + delta;
    if (amount < 0) {
      amount = 0;
    }
    if (amount>product.available){
      amount=product.available;
    }


    List<OrderItemModel> item_list = await GroceroApp.sharedApp.dao.OrderItem.getOrderProduct(order.id, product.id);
    OrderItemModel item;
    if (item_list.length == 0) {
      if (amount > 0){
        item = OrderItemModel(order_id: order.id, amount: amount, product_id: product.id);
        await DB.save(item);
      }
    } else {
      item = item_list[0];
      if (amount == 0) {
        await DB.delete(item);

      }else {
        item.amount = amount;
        await DB.save(item);
      }
    }

    await GroceroApp.sharedApp.dao.Order.updateTotal(order.id);
    order = await GroceroApp.sharedApp.dao.Order.get(order.id);

    if (delta!=0) {
      qty_controller.text = "$amount";
    }
    refreshData();

  }





}