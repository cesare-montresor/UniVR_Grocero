import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:grocero/component/dateutils.dart';
import 'package:grocero/component/db.dart';
import 'package:grocero/dao/order_dao.dart';
import 'package:grocero/dao/order_item_dao.dart';
import 'package:grocero/dao/product_dao.dart';
import 'package:grocero/main.dart';
import 'package:grocero/model/order_item_model.dart';
import 'package:grocero/model/order_model.dart';
import 'package:grocero/model/product_model.dart';
import 'package:grocero/model/user_model.dart';
import 'package:grocero/screen/product_cell.dart';

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
typedef ProductsScreenRequest = void Function(String request);

class ProductFilter{
  int category_id;
  int order_id;
  bool modal=false;
  bool show_button_order=true;
  String button_order_text = '';
  String button_order_request= '';
  bool show_searchbar = false;
}

class ProductsScreen extends StatefulWidget {
  //TODO: add order by col asc/desc
  final ProductFilter filter;
  final ProductsScreenRequest onRequest;
  const ProductsScreen ({ Key key, this.filter, this.onRequest }): super(key: key);

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  UserModel user = GroceroApp.sharedApp.currentUser;
  Future<List<ProductModel>> products;
  Future<OrderModel> order;

  //Searchbar
  TextEditingController _searchController;
  bool searchBarVisible = false;
  String searchBy = '';
  String orderBy = 'brand';
  bool reverse = false;
  bool searchChanged = false;
  Widget last_product_widget = Container(width: 0.0, height: 0.0);
  Widget last_order_widget = Container(width: 0.0, height: 0.0);

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: "");
    refreshData();
  }

  void toggleSearchBar(){
    widget.filter.show_searchbar = !widget.filter.show_searchbar;
    setState(() {});
  }

  void refreshData(){
    refreshProduct();
    refreshOrder();
  }

  void refreshProduct(){
    if (widget.filter.category_id != null){
      // view products in shopping cart
      products = ProductDAO.getByCategoryID(widget.filter.category_id, searchBy: searchBy, orderBy: orderBy, reverse: reverse);
    }
    else if (widget.filter.order_id != null){
      // View products in order_id
      products = ProductDAO.getOrderID(widget.filter.order_id, searchBy: searchBy, orderBy: orderBy, reverse: reverse);
    }else{
      // view products in shopping cart
      products = ProductDAO.getCurrentOrder(searchBy: searchBy, orderBy: orderBy, reverse: reverse);
    }
  }

  void refreshOrder(){
    if (widget.filter.category_id != null){
      // view products in shopping cart
      order = OrderDAO.getCurrent();
    }
    else if (widget.filter.order_id != null){
      // View products in order_id
      order = OrderDAO.get(widget.filter.order_id);
    }else{
      // view products in shopping cart
      order = OrderDAO.getCurrent();
    }
  }


  void cellChanged(int amount) async{
    //if (widget.filter.category_id != null )
    refreshData();
    setState(() {});
  }

  Future<bool> findUnavailable() async {
    OrderModel o = await order;
    List<ProductModel> ps = await products;
    List<OrderItemModel> oi = await OrderItemDAO.getByOrderID(o.id);


    return true;
  }

  void removeUnavailable() async{
    OrderModel o = await order;
    int i = await OrderItemDAO.deleteUnavailableItems(o.id);
    refreshData();
    setState(() {});
    Navigator.of(context).pop();
  }

  void removeCancel(){
    Navigator.of(context).pop();
    //setState(() {});
  }

  void sendRequest(BuildContext context, String request) async {
    OrderModel o = await order;
    if (request == 'open_checkout'){
      int unavailNum = await OrderItemDAO.countUnavailableItems(o.id);
      if ( unavailNum > 0 ){
        showDialog(context: context, builder: (_)=>
          AlertDialog(
            title: Text("Prodotti non disponibili"),
            content: Text("Rimuovere ${unavailNum} prodotto completare l'ordine?"),
            actions: <Widget>[
              FlatButton(child: Text("Rimuovi"), onPressed: ()=>removeUnavailable() ),
              FlatButton(child: Text("Annulla"), onPressed: ()=>removeCancel() ),
            ],
          )
        );

        return;
      }

    }

    if (widget.onRequest != null){
      widget.onRequest(request);
    }
  }

  void toggleOrder(String column_name){
    if (orderBy == column_name){
      reverse = !reverse;
    }else{
      orderBy=column_name;
      reverse = false;
    }
    searchChanged=!searchChanged;
    refreshData();
    setState(() {});
  }

  void resetSearch(){
    bool changed = false;
    if ( searchBy != ''  || reverse != false || searchBy != 'brand' ){
      changed = true;
    }

    searchBy = '';
    orderBy = 'brand';
    reverse = false;
    _searchController.text = searchBy;

    if ( changed ) {
      searchChanged=!searchChanged;
      refreshData();
      setState(() {});
    }
  }

  void searchTextChanged(String text){
    searchBy = text;
    refreshData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    Widget searchBar = Container(
        color: Colors.transparent,
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child:  Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                boxShadow: [
                    BoxShadow(
                    color: Colors.black.withOpacity(.0),
                    offset: Offset(0, 0),
                    blurRadius: 20,
                    spreadRadius: 3)
                ]
            ),

            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            key: ValueKey(widget.filter.show_searchbar),
            height: widget.filter.show_searchbar ?110:0,
            child: Column(children: <Widget>[
              TextField(decoration: InputDecoration(hintText: "Cerca"), controller: _searchController, onChanged: (text)=>searchTextChanged(text),),
              Row(children: <Widget>[
                RaisedButton(
                  onPressed: ()=>toggleOrder('brand'),
                  child: Row(children: <Widget>[
                    Icon(Icons.sort_by_alpha),
                    orderBy == 'brand' ? reverse ? Icon(Icons.keyboard_arrow_down):Icon(Icons.keyboard_arrow_up):Icon(Icons.sort),
                  ],)
                  ,),
                RaisedButton(
                  onPressed: ()=>toggleOrder('price'),
                  child: Row(children: <Widget>[
                    Icon(Icons.attach_money),
                    orderBy == 'price' ? reverse ? Icon(Icons.keyboard_arrow_down):Icon(Icons.keyboard_arrow_up):Icon(Icons.sort),
                  ],)
                  ,),
                  Expanded(child: Container(),),
                  RaisedButton(
                      onPressed: ()=>resetSearch(),
                      child: Text("Reset")
                  ),


              ],)
            ],),
        )
    );


    return  FutureBuilder<List<ProductModel>>(
        future: this.products,
        builder: (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot) {
          if (snapshot.hasData){
            var products = snapshot.data;
            last_product_widget = FutureBuilder<OrderModel>(
                future: this.order,
                builder: (BuildContext context, AsyncSnapshot<OrderModel> snapshot) {
                  if (snapshot.hasData){
                    var order = snapshot.data;

                    Widget orderButton = widget.filter.show_button_order ?
                      RaisedButton(child: Text(widget.filter.button_order_text), onPressed: order.price==0?null:()=>sendRequest(context, widget.filter.button_order_request) ,):
                      Container();

                    Widget core = Container(
                      color: Color.fromRGBO(240, 240, 240, 1),
                      child: Column(children: <Widget>[
                        searchBar,
                        Expanded(
                          child: ListView.builder(
                            key: ValueKey(products.length > 0 ? products.last.id/products.first.id+products.length*0.1: products),
                            itemCount: products.length,
                            itemBuilder: (BuildContext ctxt, int index) => ProductCell(product:products[index], order:order, onChange: cellChanged, ),
                          ),
                        ),
                        Container(
                            height: 50,
                            color: Colors.orange,
                            padding: EdgeInsets.all(10),
                            child: Row(children: <Widget>[
                              Text("Totale", key: ValueKey(order.price), style: TextStyle(color:Colors.white, fontSize: 30),),
                              Expanded(child:Text("€ "+order.price.toStringAsFixed(2), style: TextStyle(color:Colors.white, fontSize: 30), textAlign: TextAlign.center,),),
                              orderButton
                            ],)
                        )
                      ],

                      )
                    );

                    if (widget.filter.modal){
                      last_order_widget = Scaffold(
                        appBar: AppBar(
                            title:Text("Nr ${order.id} del ${DateUtils.formatDate(order.creation_date)}"),
                            actions: <Widget>[
                              IconButton(icon: Icon(Icons.search), onPressed: ()=>toggleSearchBar())
                            ],

                        ),
                        body: core,
                      );
                    }else{
                      last_order_widget = core;
                    }
                  }
                  return last_order_widget;
                }
            );
          }
          return last_product_widget;
        }
    );
  }
}