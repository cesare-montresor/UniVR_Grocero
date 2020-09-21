import 'package:flutter/material.dart';
import 'package:grocero/component/db.dart';
import 'package:grocero/controller/controller.dart';
import 'package:grocero/main.dart';
import 'package:grocero/model/card_model.dart';
import 'package:grocero/model/user_model.dart';
import 'package:grocero/model/worker_model.dart';

class ProfileScreenController extends Controller{

  UserModel user = GroceroApp.sharedApp.currentUser;
  Future<CardModel> cardInfo;
  Future<WorkerModel> workerInfo;

  List<DropdownMenuItem> payment_types = [
    DropdownMenuItem(child: Text('Carta di credito'), value:PaymentType.Card ),
    DropdownMenuItem(child: Text('Paypal'), value:PaymentType.Paypal ),
    DropdownMenuItem(child: Text('Contanti'), value:PaymentType.Cash )
  ];

  String roleToTitle(String worker_role){
    if (worker_role == WorkerRole.Peon) {return 'Impiegato';}
    if (worker_role == WorkerRole.Supervisor) {return 'Supervisore';}
    return "Sconosciuto"; //Capitalize
  }

  void init(){
    cardInfo = user.cardInfo();
    workerInfo = user.workerInfo();
  }

  void saveUser() async {
    await DB.update(user);
  }

  void payment_types_changed(String value){
    user.fav_payment = value;
  }
}
