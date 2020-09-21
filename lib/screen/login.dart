
import 'package:flutter/material.dart';
import 'package:grocero/controller/login_controller.dart';


class LoginScreen extends StatelessWidget{
  LoginScreenController ctrl = LoginScreenController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(50),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(hintText: "E-mail"),
                onChanged: (text){ctrl.email=text.trim(); },
              ),
              TextField(
                obscureText: true,
                decoration: InputDecoration(hintText: "Password"),
                onChanged: (text){ctrl.password=text.trim(); },
              ),
              RaisedButton(
                  child: Text("Login"),
                  onPressed:  () => ctrl.tryLogin(context)
              ),
              Text("oppure"),
              FlatButton(
                  child: Text("Registrati", style: TextStyle(color: Colors.blue),),
                  onPressed:  () => ctrl.openRegister(context)
              ),

            ],
          ),
        ),
      ),
    );
  }

}