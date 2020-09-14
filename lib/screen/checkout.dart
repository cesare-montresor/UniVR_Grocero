import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocero/component/db.dart';
import 'package:grocero/dao/order_dao.dart';
import 'package:grocero/main.dart';
import 'package:grocero/model/card_model.dart';
import 'package:grocero/model/order_model.dart';
import 'package:grocero/model/user_model.dart';
import 'package:grocero/model/worker_model.dart';
import 'package:grocero/routes.dart';
import 'package:intl/intl.dart';

typedef CheckoutScreenSuccess =  void Function();

class CheckoutScreen extends StatefulWidget {
  final CheckoutScreenSuccess onSuccess;
  const CheckoutScreen({Key key, this.onSuccess}) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
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

  @override
  void initState() {
    super.initState();

    DateTime tmp = DateTime.now();
    delivery_date = DateTime(tmp.year, tmp.month,tmp.day);

    order = OrderDAO.getCurrent();
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

  showCalendar(BuildContext context) async{
    DateTime today = DateTime.now();
    today = DateTime(today.year, today.month, today.day);
    delivery_date = await showDatePicker(
      context: context,
      initialDatePickerMode: DatePickerMode.day,
      initialDate: today,
      firstDate: today,
      lastDate: today.add( Duration(days: 14) ),
    );
    setState(() {});
  }

  delivery_time_changed(String value) async {
    int pos = delivery_times.indexOf(value);
    int pos_end = delivery_times_end.indexOf(selected_time_end);
    if (pos > pos_end){
      selected_time_end = delivery_times_end[pos];
    }
    selected_time = value;
    setState(() {});
  }
  delivery_time_end_changed(String value) async {
    selected_time_end = value;
    setState(() {});
  }

  payment_types_changed( String value) async {
    selected_payment = value;
    setState(() {});
  }

  send_order() async {
    OrderModel order =  await OrderDAO.getCurrent();
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
    OrderModel new_order =  await OrderDAO.getCurrent();
    Fluttertoast.showToast(
      msg: "Ordine inviato",
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 1,
    );

    if (widget.onSuccess != null){
      widget.onSuccess();
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {

    TextStyle title_style = TextStyle(fontSize: 30);
    TextStyle label_style = TextStyle(fontSize: 20);

    widget_d_time = DropdownButton(
      items: delivery_times.map((label)=>DropdownMenuItem(child: Text(label), value:label)).toList(),
      value: selected_time,
      onChanged: (value) => delivery_time_changed(value),
    );

    widget_d_time_end = DropdownButton(
      items: delivery_times_end.map((label)=>DropdownMenuItem(child: Text(label), value:label)).toList(),
      value: selected_time_end,
      onChanged: (value) => delivery_time_end_changed(value),
    );

    widget_payment = DropdownButton(
      items: payment_types,
      value: selected_payment,
      onChanged: (value) => payment_types_changed(value),
    );


    Widget widget_date = delivery_date == null?Text("- - -"):Text(DateFormat('dd MMM yyyy').format( delivery_date ));

    Widget total = FutureBuilder<OrderModel>(
      future: order,
      builder:  (BuildContext context, AsyncSnapshot<OrderModel> snapshot) {
        if (snapshot.hasData){
          OrderModel order_data = snapshot.data;
          return Text("€ ${order_data.price.toStringAsFixed(2)}", style: label_style, textAlign: TextAlign.right,);
        }
        return Text("");
    });


    return Scaffold(
      appBar: AppBar(title: Text("Checkout")),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Riepilogo", style: title_style, ),
                SizedBox(height: 10),


                Row( children: <Widget>[
                  Text("Giorno",  style: label_style),
                  Expanded(child: Container(),),
                  widget_date,
                  Container(
                      margin: EdgeInsets.all(5),
                       width: 35,
                       height: 35,
                       child: RaisedButton(
                           padding: EdgeInsets.all(0),
                           child: Icon(Icons.calendar_today),
                           onPressed: ()=>showCalendar(context)
                       )
                   ),
                ]),
                SizedBox(height: 10),

                Row( children: <Widget>[
                  Text("Orario",  style: label_style),
                  Expanded(child: Container(),),
                  Text("dalle ", ),
                  widget_d_time,
                  Text(" alle ",   textAlign: TextAlign.center),
                  widget_d_time_end,
                ]),
                SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text("Tipo di pagamento",  style: label_style),
                    Expanded(child: Container(),),
                    widget_payment
                  ]
                ),
                SizedBox(height: 15),
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text("Totale", style: label_style,),
                      Expanded(child: total),
                    ]),

                Divider(),
                SizedBox(height: 10),
                Center(
                  child: RaisedButton(
                      child: Text("Conferma Ordine"),
                      onPressed: () => send_order(),

                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

  }

}