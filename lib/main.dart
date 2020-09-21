import 'dart:io';

import 'package:flutter/material.dart';
import 'package:grocero/component/auth.dart';
import 'package:grocero/dao/dao.dart';
import 'package:grocero/model/order_model.dart';
import 'package:grocero/model/user_model.dart';
import 'package:grocero/routes.dart';
import 'package:grocero/theme/MainTheme.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'component/db.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DB.init(); //init DB
  await Auth.TryAutologin();
  GroceroApp app = GroceroApp.sharedApp;
  app.setupDocumentPath(
      await getApplicationDocumentsDirectory()
  );
  runApp(app);
}

class GroceroApp extends StatelessWidget {
  static final GroceroApp sharedApp = GroceroApp();
  UserModel currentUser;
  DAO dao = LocalDAO();
  Router router = Router();
  String documentPath;
  //OrderModel currentOrder;

  void setupDocumentPath(Directory docPath){
    documentPath = docPath.path;
    String img_path = join(documentPath, 'image');
    Directory(img_path).create(recursive: true);
  }

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
