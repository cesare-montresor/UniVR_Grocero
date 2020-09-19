import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:grocero/component/auth.dart';
import 'package:grocero/main.dart';
import 'package:grocero/model/user_model.dart';
import 'package:grocero/routes.dart';
import 'package:grocero/controller/controller.dart';

class SplashScreenController extends Controller{
  Timer timer;
  int delay = 2;

  void startTimer(BuildContext context) {
    if ( timer != null){
      timer.cancel();
      timer = null;
    }

    timer = new Timer(
      Duration(seconds: delay),
          ()=>this.changeScreen(context),
    );
  }


  void changeScreen(BuildContext context) async{
    if ( Auth.isAuth() ){
      UserModel user = GroceroApp.sharedApp.currentUser;
      if (user.isWorker()) {
        Navigator.of(context).pushReplacementNamed(Router.RouteHomeWorker);
      }else{
        Navigator.of(context).pushReplacementNamed(Router.RouteHome);
      }
    }
    else {
      Navigator.of(context).pushReplacementNamed(Router.RouteLogin);
    }
  }
}