import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:grocero/component/db.dart';
import 'package:grocero/model/card_model.dart';
import 'package:grocero/model/user_model.dart';
import 'package:grocero/routes.dart';

class RegisterScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    String name  = '';
    String surname  = '';
    String address  = '';
    String zipcode  = '';
    String city  = '';
    String phone  = '';
    String email = '';
    String password = '';
    String password_repeat = '';


    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(50),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 10),
                Text("Account"),
                TextField( decoration: InputDecoration(hintText: "E-mail"),           onChanged: (text){ email=text.trim(); } ),
                TextField( decoration: InputDecoration(hintText: "Password"),         onChanged: (text){ password=text.trim(); }, obscureText: true ),
                TextField( decoration: InputDecoration(hintText: "Password Repeat"),  onChanged: (text){ password_repeat=text.trim(); }, obscureText: true ),
                SizedBox(height: 30),
                Text("Delivery"),
                TextField( decoration: InputDecoration(hintText: "Nome"),             onChanged: (text){ name=text.trim(); } ),
                TextField( decoration: InputDecoration(hintText: "Cognome"),          onChanged: (text){ surname=text.trim();} ),
                TextField( decoration: InputDecoration(hintText: "Indirizzo"),        onChanged: (text){ address=text.trim(); } ),
                TextField( decoration: InputDecoration(hintText: "CAP"),              onChanged: (text){ zipcode=text.trim(); } ),
                TextField( decoration: InputDecoration(hintText: "Città"),            onChanged: (text){ city=text.trim(); } ),
                TextField( decoration: InputDecoration(hintText: "Telefono"),         onChanged: (text){ phone=text.trim(); } ),
                SizedBox(height: 20),
                RaisedButton(
                    child: Text("Registra"),
                    onPressed:  () async {
                      if (
                            email != "" &&
                            password != "" &&
                            password == password_repeat &&
                            surname != "" &&
                            address != "" &&
                            zipcode != "" &&
                            city != "" &&
                            phone != "" &&
                            email != ""
                      ){
                        // Create User
                        var new_user = UserModel(
                          role: UserRole.Client,
                          name: name,
                          surname: surname,
                          address: address,
                          zipcode: zipcode,
                          city: city,
                          phone: phone,
                          email: email,
                          password: password
                        );
                        int new_user_id = await DB.insert(new_user);
                        // Create Card
                        var new_card = CardModel(
                          user_id: new_user_id,
                          creation_date: DateTime.now().millisecondsSinceEpoch,
                        );
                        await DB.insert(new_card);


                        Navigator.of(context).pushReplacementNamed(Router.RouteLogin);
                      }else{
                        Fluttertoast.showToast(
                          msg: "Anagrafica incompleta.",
                          toastLength: Toast.LENGTH_SHORT,
                          timeInSecForIosWeb: 1,
                        );
                      }
                    }
                ),
                SizedBox(height: 10),
                Text("oppure"),
                FlatButton(
                    child: Text("Login", style: TextStyle(color: Colors.blue),),
                    onPressed:  (){
                      Navigator.of(context).pushReplacementNamed(Router.RouteLogin);
                    }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}