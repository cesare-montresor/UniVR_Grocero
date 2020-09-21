import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grocero/model/product_model.dart';
import 'package:grocero/screen/checkout.dart';
import 'package:grocero/screen/home.dart';
import 'package:grocero/screen/home_worker.dart';
import 'package:grocero/screen/login.dart';
import 'package:grocero/screen/product_detail.dart';
import 'package:grocero/screen/products.dart';
import 'package:grocero/screen/register.dart';
import 'package:grocero/screen/splash.dart';

class Router {
  static const String RouteSplash = '/';
  static const String RouteLogin = '/login';
  static const String RouteRegister = '/register';
  static const String RouteHome = "/home";
  static const String RouteHomeWorker = "/home_worker";
  static const String RouteCheckout = '/checkout';
  static const String RouteOrderDetail = '/order_detail';
  static const String RouteProductDetail = '/product_detail';

  Widget homeScreen = HomeScreen();
  Widget homeWorkerScreen = HomeWorkerScreen();

  Route<dynamic> generateRoute(RouteSettings settings) {

    switch (settings.name) {
      case RouteSplash: return MaterialPageRoute(builder: (_) => SplashScreen());
      case RouteLogin: return MaterialPageRoute(builder: (_) => LoginScreen());
      case RouteRegister: return MaterialPageRoute(builder: (_) => RegisterScreen());
      case RouteHome : return MaterialPageRoute(builder: (_) => homeScreen);
      case RouteHomeWorker : return MaterialPageRoute(builder: (_) => homeWorkerScreen);

      case RouteCheckout: return MaterialPageRoute(builder: (_) {
        Map<String,dynamic > args = settings.arguments;
        CheckoutScreenSuccess onSuccess = args == null ? null : args['onSuccess'];
        return CheckoutScreen(onSuccess: onSuccess);
      });

      case RouteOrderDetail: return MaterialPageRoute(builder: (_) {
        Map<String,dynamic > args = settings.arguments;
        ProductFilter filter = ProductFilter();
        filter.order_id = args == null ? null : args['order_id'];
        filter.show_button_order = false;
        filter.modal = true;
        return ProductsScreen(filter: filter);
      });

      case RouteProductDetail: return MaterialPageRoute(builder: (_) {
        Map<String, dynamic > args = settings.arguments;
        ProductModel product = (args == null) ? null : args['product'];
        ProductDetailSuccess onSuccess = (args == null) ? null : args['onSuccess'];
        ProductDetailScreen screen = ProductDetailScreen(product: product, onSuccess: onSuccess);
        return screen;
      });


      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
              body: Center(
                  child: Text('No route defined for ${settings.name}')),
            ));
    }
  }
}
