import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:grocero/dao/dao.dart';
import 'package:grocero/main.dart';
import 'package:grocero/model/order_model.dart';
import 'package:grocero/model/product_model.dart';
import 'package:grocero/model/user_model.dart';
import 'package:grocero/controller/controller.dart';
import 'package:grocero/screen/products.dart';

class ProductsScreenController extends Controller{
  ProductFilter filter;
  DAO dao = GroceroApp.sharedApp.dao;
  UserModel user = GroceroApp.sharedApp.currentUser;
  Future<List<ProductModel>> products;
  Future<OrderModel> order;

  //Searchbar
  TextEditingController searchController;
  bool searchBarVisible = false;
  String searchBy = '';
  String orderBy = 'brand';
  bool reverse = false;
  bool searchChanged = false;


  void toggleSearchBar(){
    filter.show_searchbar = !filter.show_searchbar;
  }

  @override
  void init(ProductFilter filter){
    this.filter = filter;
    searchController = TextEditingController(text: "");
    refreshData();
  }

  void refreshData(){
    refreshProduct();
    refreshOrder();
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
  }

  void resetSearch(){
    bool changed = false;
    if ( searchBy != ''  || reverse != false || searchBy != 'brand' ){
      changed = true;
    }

    searchBy = '';
    orderBy = 'brand';
    reverse = false;
    searchController.text = searchBy;

    if ( changed ) {
      searchChanged=!searchChanged;
      refreshData();
    }
  }

  void searchTextChanged(String text){
    searchBy = text;
    refreshData();
  }


  void refreshProduct(){
    if (filter.category_id != null){
      // view products in shopping cart
      products = dao.Product.getByCategoryID(filter.category_id, searchBy: searchBy, orderBy: orderBy, reverse: reverse);
    }
    else if (filter.order_id != null){
      // View products in order_id
      products = dao.Product.getOrderID(filter.order_id, searchBy: searchBy, orderBy: orderBy, reverse: reverse);
    }else{
      // view products in shopping cart
      products = dao.Product.getCurrentOrder(searchBy: searchBy, orderBy: orderBy, reverse: reverse);
    }
  }

  void refreshOrder(){

    if (filter.category_id != null){
      // view products in shopping cart
      order = dao.Order.getCurrent();
    }
    else if (filter.order_id != null){
      // View products in order_id
      order = dao.Order.get(filter.order_id);
    }else{
      // view products in shopping cart
      order = dao.Order.getCurrent();
    }
  }

  void removeUnavailable() async{
    OrderModel o = await order;
    int i = await dao.OrderItem.deleteUnavailableItems(o.id);
    refreshData();
  }

  Future<int> countUnavailable() async{
    OrderModel o = await order;
    return await dao.OrderItem.countUnavailableItems(o.id);
  }
}