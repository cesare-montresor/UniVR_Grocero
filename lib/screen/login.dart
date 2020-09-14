import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:grocero/component/auth.dart';
import 'package:grocero/dao/user_dao.dart';
import 'package:grocero/main.dart';
import 'package:grocero/model/user_model.dart';
import 'package:grocero/routes.dart';

class LoginScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    String email = '';
    String password = '';
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(50),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(hintText: "E-mail"),
                onChanged: (text){email=text.trim(); },
              ),
              TextField(
                obscureText: true,
                decoration: InputDecoration(hintText: "Password"),
                onChanged: (text){password=text.trim(); },
              ),
              RaisedButton(
                  child: Text("Login"),
                  onPressed:  () async {
                    bool did_auth = await Auth.login(email, password);
                    if ( did_auth ){
                      UserModel user = GroceroApp.sharedApp.currentUser;
                      if (user.isWorker()) {
                        Navigator.of(context).pushReplacementNamed(Router.RouteHomeWorker);
                      }else{
                        Navigator.of(context).pushReplacementNamed(Router.RouteHome);
                      }
                    }else{
                      Fluttertoast.showToast(
                          msg: "Login failed",
                          toastLength: Toast.LENGTH_SHORT,
                          timeInSecForIosWeb: 1,
                      );
                    }
                  }
              ),
              Text("or"),
              FlatButton(
                  child: Text("Register", style: TextStyle(color: Colors.blue),),
                  onPressed:  (){
                    Navigator.of(context).pushReplacementNamed(Router.RouteRegister);
                  }
              ),

            ],
          ),
        ),
      ),
    );
  }

}