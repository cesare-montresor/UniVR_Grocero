import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grocero/controller/checkout_controller.dart';
import 'package:grocero/model/order_model.dart';
import 'package:intl/intl.dart';



typedef CheckoutScreenSuccess =  void Function();

class CheckoutScreen extends StatefulWidget {
  final CheckoutScreenSuccess onSuccess;
  const CheckoutScreen({Key key, this.onSuccess}) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  CheckoutScreenController ctrl;

  @override
  void initState() {
    super.initState();
    ctrl = CheckoutScreenController();
    ctrl.init();
  }

  void showCalendar(BuildContext context) async{
    ctrl.showCalendar(context);
    setState(() {});
  }

  void delivery_time_changed(String value) async {
    ctrl.delivery_time_changed(value);
    setState(() {});
  }
  void delivery_time_end_changed(String value) async {
    ctrl.delivery_time_end_changed(value);
    setState(() {});
  }

  void payment_types_changed( String value) async {
    ctrl.payment_types_changed(value);
    setState(() {});
  }

  void send_order() async {
    ctrl.send_order();
    if (widget.onSuccess != null){
      widget.onSuccess();
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {

    TextStyle title_style = TextStyle(fontSize: 30);
    TextStyle label_style = TextStyle(fontSize: 20);

    ctrl.widget_d_time = DropdownButton(
      items: ctrl.delivery_times.map((label)=>DropdownMenuItem(child: Text(label), value:label)).toList(),
      value: ctrl.selected_time,
      onChanged: (value) => delivery_time_changed(value),
    );

    ctrl.widget_d_time_end = DropdownButton(
      items: ctrl.delivery_times_end.map((label)=>DropdownMenuItem(child: Text(label), value:label)).toList(),
      value: ctrl.selected_time_end,
      onChanged: (value) => delivery_time_end_changed(value),
    );

    ctrl.widget_payment = DropdownButton(
      items: ctrl.payment_types,
      value: ctrl.selected_payment,
      onChanged: (value) => payment_types_changed(value),
    );


    Widget widget_date = ctrl.delivery_date == null?Text("- - -"):Text(DateFormat('dd MMM yyyy').format( ctrl.delivery_date ));

    Widget total = FutureBuilder<OrderModel>(
      future: ctrl.order,
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
                  ctrl.widget_d_time,
                  Text(" alle ",   textAlign: TextAlign.center),
                  ctrl.widget_d_time_end,
                ]),
                SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text("Tipo di pagamento",  style: label_style),
                    Expanded(child: Container(),),
                    ctrl.widget_payment
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