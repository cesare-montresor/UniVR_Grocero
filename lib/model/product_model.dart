import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:grocero/main.dart';
import 'package:grocero/model/model.dart';
import 'package:grocero/model/user_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';


//TODO: Move Image widget generation to Extension for Product (requires flutter>2.7 )
/*
extension LoadImage on ProductModel {

}
 */

class ProductImage{
  static final String document_path = GroceroApp.sharedApp.documentPath.toString();
  static Widget ImageNotFound = Container();

  static Widget loadProductImage(int product_id) {
    String filename = 'product_${product_id}.jpg';
    String docPath = join(document_path, 'image', filename );
    File docFile = File(docPath);
    if ( docFile.existsSync() ){
      return Image.file(docFile);
    }else{
      String assetPath = join('asset', 'image', filename);
      /*
      rootBundle.load(assetPath).then((data){
        List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        File(docPath).writeAsBytes(bytes).then((value){});
      });
       */
      try {
        return Image.asset(assetPath);
      } catch (error) {
        return ImageNotFound;
      }
    }
    return ImageNotFound;
  }

  static Widget loadIamge(String imgPath) {
    File imgFile = File(imgPath);
    if ( imgFile.existsSync() ){
      return Image.file(imgFile);
    }else{
      return ImageNotFound;
    }
  }

}


class ProductModel extends Model {
  int category_id;
  String name;
  String brand;
  String qty;
  int available;
  double price;
  String type;
  String tags;

  static String referenceTable() => "product";
  String tableName() => referenceTable();

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
