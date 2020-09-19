import 'package:flutter/material.dart';
import 'package:grocero/component/auth.dart';
import 'package:grocero/controller/home_controller.dart';
import 'package:grocero/dao/category_dao.dart';
import 'package:grocero/main.dart';
import 'package:grocero/model/category_model.dart';
import 'package:grocero/routes.dart';
import 'package:grocero/screen/menu.dart';
import 'package:grocero/screen/orders.dart';
import 'package:grocero/screen/products.dart';
import 'package:grocero/screen/profile.dart';




class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeScreenController ctrl = HomeScreenController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    ctrl.dispose();
  }

  void onPageChanged(int page) {
    ctrl.onPageChanged(page);
  }

  void menuOnClick(MainMenuItem menu_item){
    ctrl.menuOnClick(menu_item);
    setState(() {});
  }

  void toggleSearchBar(){
    ctrl.toggleSearchBar();
  }

  void updateSearchbar(){
    ctrl.updateSearchbar();
    setState(() {});
  }

  void jumpToProfile(){
    ctrl.jumpToProfile();
  }

  void jumpToOrders(){
    ctrl.jumpToOrders();
  }

  void jumpToCart(){
    ctrl.jumpToCart();
  }

  void jumpToCategory(int id){
    ctrl.jumpToCategory(id);
  }

  void onRequest(String request){
    if (request == 'open_cart'){
      ctrl.jumpToCart();
    }else if (request == 'open_orders'){
      ctrl.jumpToOrders();
    }else if (request == 'open_checkout'){
      Navigator.pushNamed(context, Router.RouteCheckout, arguments: {'onSuccess':()=>onRequest('open_orders')} );
    }
  }

  Widget buildPages(BuildContext context, List<CategoryModel> cats) {

    ctrl.pageOrder = [
      MainMenuItemType.Cart,
      MainMenuItemType.Orders,
      MainMenuItemType.Profile,
    ];

    ProductFilter filter = ProductFilter();
    filter.button_order_text = 'Checkout';
    filter.button_order_request = 'open_checkout';
    filter.show_searchbar = ctrl.searchBarVisible;
    ctrl.widgetPages = [
      ProductsScreen(filter: filter, onRequest: onRequest),
      OrdersScreen(),
      ProfileScreen(),
    ];

    for (CategoryModel cat in cats){
      ProductFilter filter = ProductFilter();
      filter.category_id = cat.id;
      filter.button_order_text = 'Carrello';
      filter.button_order_request = 'open_cart';
      filter.show_searchbar = ctrl.searchBarVisible;
      ctrl.widgetPages.add(ProductsScreen(filter: filter, onRequest: onRequest,));
      ctrl.pageOrder.add(MainMenuItemType.Category + "_${cat.id}");
    }

    // Reparti (Category) from the Fututre
    var categories = cats.map(  (cat) =>  MainMenuItem(text: cat.name, type: MainMenuItemType.Category, cat_id: cat.id)) ;
    // Labels
    var label_cat = MainMenuItem(text:"REPARTI", type: MainMenuItemType.Label );
    //var section_cat = ListTile(title: Text("S E Z I O N I", style: TextStyle(color: Colors.grey),) ,enabled: false );

    // Carrello, Ordini, Profile, [Categories], Space, Logout
    var divider = MainMenuItem(type: MainMenuItemType.Divider );
    var cart = MainMenuItem(text: "Carrello", type: MainMenuItemType.Cart );
    var orders = MainMenuItem(text: "Ordini", type: MainMenuItemType.Orders );
    var profile = MainMenuItem(text: "Profilo", type: MainMenuItemType.Profile );

    ctrl.mainMenu.menu_items = [];
    ctrl.mainMenu.menu_items.addAll( [cart,orders,profile] );
    ctrl.mainMenu.menu_items.addAll( [divider,label_cat] );
    ctrl.mainMenu.menu_items.addAll( categories );

    ctrl.pageMenuItems = [cart,orders,profile];
    ctrl.pageMenuItems.addAll(categories);

    //appBarTitle = Text(_pageMenuItems[_pageController.page.toInt()].text);

    Widget pageView = PageView(
      key: ValueKey(cats),
      physics: NeverScrollableScrollPhysics(),
      controller: ctrl.pageController,
      pageSnapping: true,
      onPageChanged: onPageChanged,
      children: ctrl.widgetPages,
    );

    Widget searchButton = ctrl.showSearchButton?IconButton(icon: Icon(Icons.search), onPressed: ()=>toggleSearchBar()):Container();

    return Scaffold(
        drawer: ctrl.mainMenu.build(context),
        backgroundColor: Colors.white,
        appBar: AppBar(title: ctrl.appBarTitle, backgroundColor: Colors.orange, actions: <Widget>[
          searchButton
        ],),
        body: SafeArea( child:pageView )
    );

  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<List<CategoryModel>>(
        future: ctrl.categories,
        builder: (BuildContext context, AsyncSnapshot<List<CategoryModel>> snapshot) {
          if (snapshot.hasData){
            return buildPages(context, snapshot.data);
          }
          return Container(width: 0,height: 0,);
        });

  }
}

