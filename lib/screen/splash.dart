import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grocero/controller/spash_controller.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashScreenController _ctrl = SplashScreenController();
  @override
  Widget build(BuildContext context) {
    _ctrl.startTimer(context);
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

}