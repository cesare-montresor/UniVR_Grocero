import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:grocero/model/model.dart';
import 'package:grocero/model/user_model.dart';
import 'package:path_provider/path_provider.dart';

class ProductModel extends Model {
  int category_id;
  String name;
  String brand;
  String qty;
  int available;
  double price;
  String type;
  String tags;
  Image img;

  static String referenceTable() => "product";
  String tableName() => referenceTable();

  static Image pictureByID(int product_id) {
    var path = "asset/image/product_$product_id.jpg";
    return Image.asset(path);
  }
   
  Image picture(){
    if (this.img == null){
      this.img = pictureByID(this.id);
    }
    return this.img;
  }

  @override
  ProductModel({int id, int category_id, String name, String brand, String qty, int available, double price, String type, String tags }) : super(id: id) {
    this.category_id = category_id;
    this.name = name;
    this.brand = brand;
    this.qty = qty;
    this.available = available;
    this.price = price;
    this.type = type;
    this.tags = tags;
  }

  @override
  ProductModel.fromMap(Map<String, dynamic> map) : super.fromMap(map){
    this.category_id = map['category_id'];
    this.name = map['name'];
    this.brand = map['brand'];
    this.qty = map['qty'];
    this.available = map['available'];
    this.price = map['price'];
    this.type = map['type'];
    this.tags = map['tags'];
  }

  @override
  Map<String, dynamic> toMap() {
    var data = super.toMap();
    data["category_id"] = this.category_id;
    data["name"] = this.name;
    data["brand"] = this.brand;
    data["qty"] = this.qty;
    data["available"] = this.available;
    data["price"] = this.price;
    data["type"] = this.type;
    data["tags"] = this.tags;
    return data;
  }


}
