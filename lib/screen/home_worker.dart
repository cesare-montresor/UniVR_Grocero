import 'package:flutter/material.dart';
import 'package:grocero/dao/category_dao.dart';
import 'package:grocero/model/category_model.dart';
import 'package:grocero/screen/menu.dart';
import 'package:grocero/screen/orders.dart';
import 'package:grocero/screen/products.dart';
import 'package:grocero/screen/profile.dart';
import 'package:grocero/screen/warehouse.dart';




class HomeWorkerScreen extends StatefulWidget {
  @override
  _HomeScreenWorkerState createState() => _HomeScreenWorkerState();
}

class _HomeScreenWorkerState extends State<HomeWorkerScreen> {
  Future<List<CategoryModel>> categories;
  MainMenu mainMenu = MainMenu();
  int defaultPage = 4;
  int _currentPage = 0;
  PageController _pageController;
  List<String> _pageOrder;
  Text appBarTitle;
  List<Widget> _widgetPages;
  List<MainMenuItem> _pageMenuItems;
  bool searchBarVisible = false;
  bool showSearchButton = true;

  @override
  void initState() {
    super.initState();
    mainMenu.initComponent(menuOnClick);
    appBarTitle = Text("Magazzino");
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void onPageChanged(int page) {
    menuOnClick(_pageMenuItems[page]);
  }

  void menuOnClick(MainMenuItem menu_item){
    _currentPage = _pageMenuItems.indexOf(menu_item);
    setState(() {
      appBarTitle = Text(menu_item.text);
    });
    mainMenu.last_selection = menu_item;
    _pageController.jumpToPage(_currentPage);
    updateSearchbar();
  }

  void toggleSearchBar(){
    searchBarVisible = !searchBarVisible;
    updateSearchbar();

  }

  void updateSearchbar(){
    MainMenuItem itm =  _pageMenuItems[_currentPage];
    bool res;
    if (itm.type == MainMenuItemType.Warehouse){
      res = true;
      WarehouseScreen page = _widgetPages[_currentPage];
      page.filter.show_searchbar = searchBarVisible;
    }else{
      res = false;
    }
    setState(() {
      showSearchButton = res;
    });
  }

  void jumpToProfile(){
    int page = _pageOrder.indexOf(MainMenuItemType.Profile);
    _pageController.jumpToPage(page);
  }

  bool showSearchBar(){
    return showSearchButton;
  }


  Widget buildPages(BuildContext context) {

    _pageOrder = [
      MainMenuItemType.Warehouse,
      MainMenuItemType.Orders,
      MainMenuItemType.Profile,
    ];

    WarehouseFilter filter = WarehouseFilter();
    filter.show_searchbar = searchBarVisible;
    _widgetPages = [
      WarehouseScreen(filter: filter),
      OrdersScreen(),
      ProfileScreen(),
    ];

    // Carrello, Ordini, Profile
    var cart = MainMenuItem(text: "Magazzino", type: MainMenuItemType.Warehouse );
    var orders = MainMenuItem(text: "Ordini", type: MainMenuItemType.Orders );
    var profile = MainMenuItem(text: "Profilo", type: MainMenuItemType.Profile );

    mainMenu.menu_items = [cart,orders,profile] ;
    _pageMenuItems = mainMenu.menu_items;

    _pageController = PageController(initialPage: 0);
    Widget pageView = PageView(
      physics: NeverScrollableScrollPhysics(),
      controller: _pageController,
      onPageChanged: onPageChanged,
      children: _widgetPages,
    );

    Widget searchButton = showSearchButton?IconButton(icon: Icon(Icons.search), onPressed: ()=>toggleSearchBar()):Container();

    return Scaffold(
        drawer: mainMenu.build(context),
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: appBarTitle,
          backgroundColor: Colors.orange,
          actions: <Widget>[
            searchButton
          ],),
        body: SafeArea( child:pageView )
    );

  }

  @override
  Widget build(BuildContext context) {

    return buildPages(context);

  }
}

