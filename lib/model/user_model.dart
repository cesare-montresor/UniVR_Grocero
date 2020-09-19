import 'dart:core';

import 'package:grocero/dao/card_dao.dart';
import 'package:grocero/dao/worker_dao.dart';
import 'package:grocero/main.dart';
import 'package:grocero/model/card_model.dart';
import 'package:grocero/model/model.dart';
import 'package:grocero/model/worker_model.dart';


class UserRole{
  static String Client = 'client';
  static String Worker = 'worker';
}

class PaymentType{
  static String Paypal = 'paypal';
  static String Card = 'card';
  static String Cash = 'cash';
}

class UserModel extends Model {

  String role;
  String name;
  String surname;
  String email;
  String password;
  String address;
  String zipcode;
  String city;
  String phone;
  String fav_payment;


  static String referenceTable() => "user";
  String tableName() => referenceTable();


  @override
  UserModel({int id, String role, String name, String surname, String email, String password, String address, String zipcode, String city, String phone, String fav_payment}) : super(id: id) {
    this.role = role ?? UserRole.Client;
    this.name=name ?? "";
    this.surname=surname ?? "";
    this.email=email ?? "";
    this.password=password ?? "";
    this.address=address ?? "";
    this.zipcode=zipcode ?? "";
    this.city=city ?? "";
    this.phone=phone ?? "";
    this.fav_payment=fav_payment ?? PaymentType.Paypal;
  }

  @override
  UserModel.fromMap(Map<String, dynamic> map) : super.fromMap(map){
    this.role = map['role'] ?? UserRole.Client;
    this.name=map['name'] ?? "";
    this.surname=map['surname'] ?? "";
    this.email=map['email'] ?? "";
    this.password=map['password'] ?? "";
    this.address=map['address'] ?? "";
    this.zipcode=map['zipcode'] ?? "";
    this.city=map['city'] ?? "";
    this.phone=map['phone'] ?? "";
    this.fav_payment=map['fav_payment'] ?? PaymentType.Paypal;
  }



  @override
  Map<String, dynamic> toMap() {
    var data = super.toMap();
    data["id"] = this.id;
    data["role"] = this.role;
    data["name"] = this.name;
    data["surname"] = this.surname;
    data["email"] = this.email;
    data["password"] = this.password;
    data["address"] = this.address;
    data["zipcode"] = this.zipcode;
    data["city"] = this.city;
    data["phone"] = this.phone;
    data["fav_payment"] = this.fav_payment;
    return data;
  }

  Future<CardModel> cardInfo() async{
    return await GroceroApp.sharedApp.dao.Card.getByUserID(this.id);
  }

  bool isWorker(){
    return role == UserRole.Worker;
  }

  Future<WorkerModel> workerInfo() async{
    if (isWorker()){
      return await GroceroApp.sharedApp.dao.Worker.getByUserID(this.id);
    }
    return null;
  }

}
