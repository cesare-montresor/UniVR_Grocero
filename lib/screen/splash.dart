
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grocero/component/auth.dart';
import 'package:grocero/main.dart';
import 'package:grocero/model/user_model.dart';
import 'package:grocero/routes.dart';


Timer timer;


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer _timer;
  int delay = 2;

  void startTimer(BuildContext context) {
    if ( _timer != null){
      _timer.cancel();
      _timer = null;
    }

    _timer = new Timer(
        Duration(seconds: delay),
        ()=>changeScreen(context)
    );
  }

  @override
  Widget build(BuildContext context) {
    startTimer(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('asset/image/grocero-logo-big.png'),
          ],
        ),
      ),
        
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