import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grocero/component/dateutils.dart';
import 'package:grocero/dao/order_dao.dart';
import 'package:grocero/main.dart';
import 'package:grocero/model/order_model.dart';
import 'package:grocero/model/product_model.dart';
import 'package:grocero/model/user_model.dart';
import 'package:grocero/routes.dart';

/*
int user_id;
String state;
int creation_date;
int delivery_date;
int delivery_interval;
double price;
String payment_type;
int points;
*/
class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future<List<OrderModel>> orders;

  @override
  void initState() {
    super.initState();
    UserModel user = GroceroApp.sharedApp.currentUser;
    if (user.isWorker()) {
      this.orders = OrderDAO.all();
    }else{
      this.orders = OrderDAO.getHistory();
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
    //TODO: handle row tap, open details
    Navigator.of(context).pushNamed( Router.RouteOrderDetail , arguments: {'order_id':order.id} );
  }

  Widget buildOrderRow(BuildContext context, OrderModel order){
    var creation_date = DateUtils.formatDate(order.creation_date);
    var creation_age = DateUtils.formatAge(order.creation_date);
    var state = stateToText(order.state);
    /*
    int delivery_date;
    int delivery_interval;
    String payment_type;
    */

    return Container(
      color: Color.fromRGBO(240, 240, 240, 1),
      padding: EdgeInsets.all(0),
      margin: EdgeInsets.all(0),
      child: ListTile(
        contentPadding: EdgeInsets.all(0),
        onTap: ()=>onTapRow(context, order),
        title: Container(
          color: Color.fromRGBO(240, 240, 240, 1),
          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: Container(
              height: 100,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
              ),
              padding: EdgeInsets.all(10),
              child:Row(
                children: <Widget>[
                  //Left
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Nr ${order.id} del $creation_date"),
                        Text("$creation_age ago", style: TextStyle(color: Colors.grey, fontSize: 13)),
                        Expanded(child: Container()),

                        Row(children: <Widget>[
                          Text("Consegna "),
                          Text(order.delivery_date != null ? DateUtils.formatDate(order.delivery_date):' --- '),
                        ],),
                        Row(children: <Widget>[
                          Text("Dalle "),
                          Text(order.delivery_date != null ? DateUtils.formatTime(order.delivery_date):' --- '),
                          Text(" alle "),
                          Text(order.delivery_date != null ? DateUtils.formatTime(order.delivery_interval):' --- '),
                        ],)


                  ]),
                  Expanded(child: Container(),),
                  //Right
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text("${state.toUpperCase()}", style: TextStyle(fontSize: 20, decoration: TextDecoration.underline), ),
                      Expanded(child: Container()),
                      Text("saldo punti ${order.points}"),
                      Text("€ ${order.price.toStringAsFixed(2)}", style: TextStyle(fontSize: 30), ),
                    ],
                  ),
                  Container(
                    width: 30,
                    alignment: Alignment.centerRight,
                    child: Icon(Icons.arrow_forward_ios)
                  )
                ],
              )
            ),
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<OrderModel>>(
      future: this.orders,
      builder: (BuildContext context, AsyncSnapshot<List<OrderModel>> snapshot) {
        if (snapshot.hasData){
          var orders = snapshot.data;
          return ListView.builder(
              padding: EdgeInsets.all(0),
              itemCount: orders.length,
              itemBuilder: (BuildContext ctxt, int index) {
              return buildOrderRow(context,orders[index]);
            }
          );
        }
        return Container(width: 0.0, height: 0.0);
      }
    );
  }
}