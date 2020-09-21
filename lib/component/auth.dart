import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:grocero/dao/user_dao.dart';
import 'package:grocero/main.dart';
import 'package:grocero/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth {
  static final String KeyCurrentUser = "current_user_id";

  static Future<bool> TryAutologin() async{
    final SharedPreferences sp = await SharedPreferences.getInstance();
    int user_id = sp.getInt(KeyCurrentUser);
    if (user_id != null){
      //TODO: replace user_id with token and store authtoken in db.
      var user = await GroceroApp.sharedApp.dao.User.get(user_id);
      GroceroApp.sharedApp.currentUser = user;
      return true;
    }
    return false;
  }

  static Future<bool> writeSettings() async{
    final SharedPreferences sp = await SharedPreferences.getInstance();
    if (GroceroApp.sharedApp.currentUser == null) {
      sp.remove(KeyCurrentUser);
    }else{
      sp.setInt(KeyCurrentUser, GroceroApp.sharedApp.currentUser.id);
    }
    return true;
  }

  static bool isAuth(){
    return GroceroApp.sharedApp.currentUser != null;
  }

  static int userID(){
    if (isAuth()){
      return GroceroApp.sharedApp.currentUser.id;
    }
    return -1;
  }

  static Future<void> logout() async{
    GroceroApp.sharedApp.currentUser = null;
    await writeSettings();
  }

  static Future<bool> login(String email, String pass) async {
    var user = await GroceroApp.sharedApp.dao.User.searchByEmail(email);
    if (user != null && user.password == pass) {
      GroceroApp.sharedApp.currentUser = user;
      await writeSettings();
      return true;
    }
    return false;
  }



}