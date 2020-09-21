import 'package:flutter/widgets.dart';
import 'package:grocero/component/auth.dart';
import 'package:grocero/controller/controller.dart';
import 'package:grocero/main.dart';
import 'package:grocero/model/user_model.dart';
import 'package:grocero/routes.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreenController extends Controller{
  String email = '';
  String password = '';

  void tryLogin(BuildContext context)async {
    bool did_auth = await Auth.login(email, password);
    if (did_auth) {
      UserModel user = GroceroApp.sharedApp.currentUser;
      if (user.isWorker()) {
        Navigator.of(context).pushReplacementNamed(Router.RouteHomeWorker);
      } else {
        Navigator.of(context).pushReplacementNamed(Router.RouteHome);
      }
    } else {
      Fluttertoast.showToast(
        msg: "Login fallito.",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    }
  }

  void openRegister(BuildContext context)async {
    Navigator.of(context).pushReplacementNamed(Router.RouteRegister);
  }
}