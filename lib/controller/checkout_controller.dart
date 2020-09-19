
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocero/component/db.dart';
import 'package:grocero/model/card_model.dart';
import 'package:grocero/model/order_model.dart';
import 'package:grocero/model/user_model.dart';

import 'package:grocero/main.dart';
import 'file:///C:/Users/Cesare/Projects/projct_progII/grocero/lib/controller/controller.dart';
import 'package:intl/intl.dart';

class CheckoutScreenController extends Controller{
  UserModel user = GroceroApp.sharedApp.currentUser;
  Future<OrderModel> order;
  DateTime delivery_date;
  List<String> delivery_times;
  List<String> delivery_times_end;
  List<DropdownMenuItem<String>> payment_types;

  DropdownButton widget_payment;
  DropdownButton widget_d_time;
  DropdownButton widget_d_time_end;

  String selected_time;
  String selected_time_end;
  String selected_payment;

  void init(){
    DateTime tmp = DateTime.now();
    delivery_date = DateTime(tmp.year, tmp.month,tmp.day);

    order = GroceroApp.sharedApp.dao.Order.getCurrent();
    DateTime deliver_start = DateTime(0,0,0,9);
    DateTime deliver_close = DateTime(0,0,0,19);
    Duration delivery_gap = Duration(hours: 1);
    Duration time_step = Duration(minutes: 30);

    delivery_times=[];
    delivery_times_end=[];
    String item;
    while ( deliver_start.isBefore(deliver_close)  ){
      item = DateFormat('kk:mm').format(deliver_start);
      delivery_times.add(item);

      item = DateFormat('kk:mm').format( deliver_start.add(delivery_gap));
      delivery_times_end.add( item );

      deliver_start = deliver_start.add(time_step);
    }

    payment_types = [
      DropdownMenuItem(child: Text('Carta di credito'), value:PaymentType.Card ),
      DropdownMenuItem(child: Text('Paypal'), value:PaymentType.Paypal ),
      DropdownMenuItem(child: Text('Contanti'), value:PaymentType.Cash )
    ];

    selected_payment = user.fav_payment;
    selected_time = delivery_times[0];
    selected_time_end = delivery_times_end[0];
  }


  void showCalendar(BuildContext context) async{
    DateTime today = DateTime.now();
    today = DateTime(today.year, today.month, today.day);
    delivery_date = await showDatePicker(
      context: context,
      initialDatePickerMode: DatePickerMode.day,
      initialDate: today,
      firstDate: today,
      lastDate: today.add( Duration(days: 14) ),
    );
  }

  void delivery_time_changed(String value) async {
    int pos = delivery_times.indexOf(value);
    int pos_end = delivery_times_end.indexOf(selected_time_end);
    if (pos > pos_end){
      selected_time_end = delivery_times_end[pos];
    }
    selected_time = value;
  }
  void delivery_time_end_changed(String value) async {
    selected_time_end = value;
  }

  void payment_types_changed( String value) async {
    selected_payment = value;
  }

  void send_order() async {
    OrderModel order =  await GroceroApp.sharedApp.dao.Order.getCurrent();
    order.state = OrderState.StateConfirm;
    List<int> time_start = selected_time.split(":").map((part)=>int.parse(part)).toList();
    order.delivery_date = DateTime(
      delivery_date.year,
      delivery_date.month,
      delivery_date.day,
      time_start[0],
      time_start[1],
    ).millisecondsSinceEpoch ~/ 1000;
    List<int> end_start = selected_time_end.split(":").map((part)=>int.parse(part)).toList();
    order.delivery_interval = DateTime(
      delivery_date.year,
      delivery_date.month,
      delivery_date.day,
      end_start[0],
      end_start[1],
    ).millisecondsSinceEpoch ~/ 1000;
    order.payment_type = selected_payment;
    CardModel card = await user.cardInfo();
    card.points +=  order.price.toInt();
    order.points = card.points;
    DB.save(card);

    DB.save(order);
    OrderModel new_order =  await GroceroApp.sharedApp.dao.Order.getCurrent();
    Fluttertoast.showToast(
      msg: "Ordine inviato",
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 1,
    );


  }
}