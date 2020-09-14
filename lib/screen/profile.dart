import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocero/component/db.dart';
import 'package:grocero/main.dart';
import 'package:grocero/model/card_model.dart';
import 'package:grocero/model/user_model.dart';
import 'package:grocero/model/worker_model.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel user = GroceroApp.sharedApp.currentUser;
  Future<CardModel> cardInfo;
  Future<WorkerModel> workerInfo;

  String roleToTitle(String worker_role){
    if (worker_role == WorkerRole.Peon) {return 'Impiegato';}
    if (worker_role == WorkerRole.Supervisor) {return 'Supervisore';}
    return "Sconosciuto"; //Capitalize
  }


  @override
  void initState() {
    super.initState();
    cardInfo = user.cardInfo();
    workerInfo = user.workerInfo();
  }

  @override
  Widget build(BuildContext context) {
    Widget workBox = Container(width: 0.0, height: 0.0);
    Widget cardBox = Container(width: 0.0, height: 0.0);

    if (user.isWorker()){
      workBox = FutureBuilder<WorkerModel>(
          future: workerInfo,
          builder: (BuildContext context, AsyncSnapshot<WorkerModel> snapshot) {
            if (snapshot.hasData){
              final workerInfo = snapshot.data;
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(children: <Widget>[
                    Text("Matricola", style: TextStyle(color: Colors.black54, fontSize: 16),),
                    Expanded(child: Container(),),
                    Text(workerInfo.badge_number, style: TextStyle(color: Colors.grey, fontSize: 16),),
                  ],),
                  SizedBox(height: 10),
                  Row(children: <Widget>[
                    Text("Ruolo", style: TextStyle(color: Colors.black54, fontSize: 16),),
                    Expanded(child: Container(),),
                    Text( roleToTitle(workerInfo.role), style: TextStyle(color: Colors.grey, fontSize: 16),),
                  ],)
                ] ,
              );
            }
            return Container(width: 0.0, height: 0.0);
          }
      );
    }
    cardBox = FutureBuilder<CardModel>(
        future: cardInfo,
        builder: (BuildContext context, AsyncSnapshot<CardModel> snapshot) {
          if (snapshot.hasData){
            final card_info = snapshot.data;
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 20),
                Row(children: <Widget>[
                  Text("Tessera Numero", style: TextStyle(color: Colors.black54 , fontSize: 16),),
                  Expanded(child: Container(),),
                  Text(card_info.id.toString(), style: TextStyle(color: Colors.grey),),
                ],),
                SizedBox(height: 10),
                Row(children: <Widget>[
                  Text("Saldo Punti", style: TextStyle(color: Colors.black54 , fontSize: 16),),
                  Expanded(child: Container(),),
                  Text(card_info.points.toString(), style: TextStyle(color: Colors.grey),),
                ],),
              ] ,
            );
          }
          return Container(width: 0.0, height: 0.0);
        }
    );


    var name = TextEditingController(text: user.name);
    var surname = TextEditingController(text: user.surname);
    var address = TextEditingController(text: user.address);
    var zipcode = TextEditingController(text: user.zipcode);
    var city = TextEditingController(text: user.city);
    var phone = TextEditingController(text: user.phone);

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(50),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                workBox,
                SizedBox(height: 10),
                Text("Anagrafica"),
                TextField( controller:name, decoration: InputDecoration(hintText: "Nome"),             onChanged: (text){  user.name = text.trim(); } ),
                TextField( controller:surname, decoration: InputDecoration(hintText: "Cognome"),          onChanged: (text){ user.surname=text.trim();} ),
                TextField( controller:address, decoration: InputDecoration(hintText: "Indirizzo"),        onChanged: (text){ user.address=text.trim(); } ),
                TextField( controller:zipcode, decoration: InputDecoration(hintText: "CAP"),              onChanged: (text){ user.zipcode=text.trim(); } ),
                TextField( controller:city, decoration: InputDecoration(hintText: "Città"),            onChanged: (text){ user.city=text.trim(); } ),
                TextField( controller:phone, decoration: InputDecoration(hintText: "Telefono"),         onChanged: (text){ user.phone=text.trim(); } ),
                cardBox,
                SizedBox(height: 20),
                RaisedButton(
                    child: Text("Salva"),
                    onPressed:  () async {
                        await DB.update(user);
                        Fluttertoast.showToast(
                          msg: "Profilo aggiornato",
                          toastLength: Toast.LENGTH_SHORT,
                          timeInSecForIosWeb: 1,
                        );
                        //Navigator.of(context).pop();
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