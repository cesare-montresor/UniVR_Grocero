import 'package:flutter/material.dart';
import 'package:grocero/component/auth.dart';
import 'package:grocero/model/order_model.dart';
import 'package:grocero/model/user_model.dart';
import 'package:grocero/routes.dart';
import 'package:grocero/theme/MainTheme.dart';

import 'component/db.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DB.init(); //init DB
  await Auth.TryAutologin();

  runApp(GroceroApp.sharedApp);
}

class GroceroApp extends StatelessWidget {
  static GroceroApp sharedApp = GroceroApp();
  UserModel currentUser;
  Router router = Router();
  //OrderModel currentOrder;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grocero',
      theme: MainTheme.themeData,
      onGenerateRoute: router.generateRoute,
      initialRoute: Router.RouteSplash,
    );
  }
}
