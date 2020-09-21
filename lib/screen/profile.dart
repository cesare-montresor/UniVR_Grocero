import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocero/component/db.dart';
import 'package:grocero/controller/profile_controller.dart';
import 'package:grocero/main.dart';
import 'package:grocero/model/card_model.dart';
import 'package:grocero/model/user_model.dart';
import 'package:grocero/model/worker_model.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileScreenController ctrl;

  @override
  void initState() {
    super.initState();
    ctrl = ProfileScreenController();
    ctrl.init();
  }

  void onSavePressed() async {
    await ctrl.saveUser();
    Fluttertoast.showToast(
      msg: "Profilo aggiornato",
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 1,
    );
    //Navigator.of(context).pop();
  }

  void payment_types_changed( String value) async {
    ctrl.payment_types_changed(value);
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    Widget workBox = Container(width: 0.0, height: 0.0);
    Widget cardBox = Container(width: 0.0, height: 0.0);

    if (ctrl.user.isWorker()){
      workBox = FutureBuilder<WorkerModel>(
          future: ctrl.workerInfo,
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
                    Text( ctrl.roleToTitle(workerInfo.role), style: TextStyle(color: Colors.grey, fontSize: 16),),
                  ],)
                ] ,
              );
            }
            return Container(width: 0.0, height: 0.0);
          }
      );
    }
    cardBox = FutureBuilder<CardModel>(
        future: ctrl.cardInfo,
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


    var name = TextEditingController(text: ctrl.user.name);
    var surname = TextEditingController(text: ctrl.user.surname);
    var address = TextEditingController(text: ctrl.user.address);
    var zipcode = TextEditingController(text: ctrl.user.zipcode);
    var city = TextEditingController(text: ctrl.user.city);
    var phone = TextEditingController(text: ctrl.user.phone);




    Widget fav_payment = Row(
      children: <Widget>[
        Text("Tipo di pagamento"),
        Expanded(child: Container(),),
        DropdownButton(
          items: ctrl.payment_types,
          value: ctrl.user.fav_payment,
          onChanged: (value) => payment_types_changed(value),
        )
    ],);

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
                TextField( controller:name, decoration: InputDecoration(hintText: "Nome"),             onChanged: (text){  ctrl.user.name = text.trim(); } ),
                TextField( controller:surname, decoration: InputDecoration(hintText: "Cognome"),       onChanged: (text){ ctrl.user.surname=text.trim();} ),
                TextField( controller:address, decoration: InputDecoration(hintText: "Indirizzo"),     onChanged: (text){ ctrl.user.address=text.trim(); } ),
                TextField( controller:zipcode, decoration: InputDecoration(hintText: "CAP"),           onChanged: (text){ ctrl.user.zipcode=text.trim(); } ),
                TextField( controller:city, decoration: InputDecoration(hintText: "Città"),            onChanged: (text){ ctrl.user.city=text.trim(); } ),
                TextField( controller:phone, decoration: InputDecoration(hintText: "Telefono"),        onChanged: (text){ ctrl.user.phone=text.trim(); } ),
                (ctrl.user.isWorker() ? Container(width: 0.0, height: 0.0,):fav_payment),
                cardBox,
                SizedBox(height: 20),
                RaisedButton(
                    child: Text("Salva"),
                    onPressed:  () => onSavePressed()
                ),
              ],
            ),
          ),
        ),
      ),
    );

  }

}