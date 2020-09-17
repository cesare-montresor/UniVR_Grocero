import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:grocero/component/dateutils.dart';
import 'package:grocero/component/db.dart';
import 'package:grocero/dao/order_dao.dart';
import 'package:grocero/dao/product_dao.dart';
import 'package:grocero/main.dart';
import 'package:grocero/model/order_item_model.dart';
import 'package:grocero/model/order_model.dart';
import 'package:grocero/model/product_model.dart';
import 'package:grocero/model/user_model.dart';
import 'package:grocero/routes.dart';
import 'package:grocero/screen/product_cell.dart';
import 'package:grocero/screen/warehouse_cell.dart';

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

class WarehouseFilter{
  int order_id;
  bool show_searchbar = false;
}

class WarehouseScreen extends StatefulWidget {
  //TODO: add order by col asc/desc
  final WarehouseFilter filter;
  const WarehouseScreen ({ Key key, this.filter }): super(key: key);

  @override
  _WarehouseScreenState createState() => _WarehouseScreenState();
}

class _WarehouseScreenState extends State<WarehouseScreen> {
  UserModel user = GroceroApp.sharedApp.currentUser;
  Future<List<ProductModel>> products;
  List<OrderItemModel> order_items;

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
    products = ProductDAO.all(searchBy: searchBy, orderBy: orderBy, reverse: reverse);
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

  void onProductSaved(){
    refreshData();
    setState(() {});
  }

  void onSelectProduct(ProductModel product){
    Navigator.of(context).pushNamed(
        Router.RouteProductDetail,
        arguments: {
          'product':product,
          'onSuccess': onProductSaved
        }
    );
  }

  Widget searchBar(){
    return Container(
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
  }



  @override
  Widget build(BuildContext context) {
    return  FutureBuilder<List<ProductModel>>(
        future: this.products,
        builder: (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot) {
            if (snapshot.hasData){
                var products = snapshot.data;
                last_product_widget = Container(
                    color: Color.fromRGBO(240, 240, 240, 1),
                    child: Column(children: <Widget>[
                      searchBar(),
                      Expanded(
                          child: ListView.builder(
                              key: ValueKey(products.length > 0 ? products.last.id-products.first.id+products.length*0.1: products),
                              itemCount: products.length,
                              itemBuilder: (BuildContext ctxt, int index) => WarehouseCell(product:products[index], onSelectProduct: onSelectProduct),
                          ),
                      )
                    ])
                );
            }
          return last_product_widget;
        }
    );
  }
}