import 'package:flutter/material.dart';
import 'package:grocero/component/auth.dart';
import 'package:grocero/dao/category_dao.dart';
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
    this.categories = CategoryDAO.all();

    _pageController = PageController(initialPage: 0);
    appBarTitle = Text("");
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
    String type = menu_item.type;
    if ( menu_item.type == 'category' ){
      type += "_${menu_item.cat_id}";
    }
    
    int page_num = _pageOrder.indexOf(type);
    setState(() {
      appBarTitle = Text(menu_item.text);
    });
    mainMenu.last_selection = menu_item;
    _pageController.jumpToPage(page_num);
    updateSearchbar();
  }

  void toggleSearchBar(){
    searchBarVisible = !searchBarVisible;
    updateSearchbar();

  }

  void updateSearchbar(){
    MainMenuItem itm =  _pageMenuItems[_currentPage];
    bool res;


    if (itm.type != MainMenuItemType.Orders && itm.type != MainMenuItemType.Profile){
      res = true;
      ProductsScreen page = _widgetPages[_currentPage];
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

  void jumpToOrders(){
    int page = _pageOrder.indexOf(MainMenuItemType.Orders);
    _pageController.jumpToPage(page);
  }

  void jumpToCart(){
    int page = _pageOrder.indexOf(MainMenuItemType.Cart);
    _pageController.jumpToPage(page);
  }

  void jumpToCategory(int id){
    int page = _pageOrder.indexOf(MainMenuItemType.Category+"_$id");
    if (page != -1 ) {
      _pageController.jumpToPage(page);
    }

  }

  void onRequest(String request){
    if (request == 'open_cart'){
      jumpToCart();
    }else if (request == 'open_orders'){
      jumpToOrders();
    }else if (request == 'open_checkout'){
      Navigator.pushNamed(context, Router.RouteCheckout, arguments: {'onSuccess':()=>onRequest('open_orders')} );
    }
  }

  bool showSearchBar(){
    return showSearchButton;
  }


  Widget buildPages(BuildContext context, List<CategoryModel> cats) {

    _pageOrder = [
      MainMenuItemType.Cart,
      MainMenuItemType.Orders,
      MainMenuItemType.Profile,
    ];

    ProductFilter filter = ProductFilter();
    filter.button_order_text = 'Checkout';
    filter.button_order_request = 'open_checkout';
    filter.show_searchbar = searchBarVisible;
    _widgetPages = [
      ProductsScreen(filter: filter, onRequest: onRequest),
      OrdersScreen(),
      ProfileScreen(),
    ];

    for (CategoryModel cat in cats){
      ProductFilter filter = ProductFilter();
      filter.category_id = cat.id;
      filter.button_order_text = 'Carrello';
      filter.button_order_request = 'open_cart';
      filter.show_searchbar = searchBarVisible;
      _widgetPages.add(ProductsScreen(filter: filter, onRequest: onRequest,));
      _pageOrder.add(MainMenuItemType.Category + "_${cat.id}");
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

    mainMenu.menu_items = [];
    mainMenu.menu_items.addAll( [cart,orders,profile] );
    mainMenu.menu_items.addAll( [divider,label_cat] );
    mainMenu.menu_items.addAll( categories );

    _pageMenuItems = [cart,orders,profile];
    _pageMenuItems.addAll(categories);

    //appBarTitle = Text(_pageMenuItems[_pageController.page.toInt()].text);

    Widget pageView = PageView(
      key: ValueKey(cats),
      physics: NeverScrollableScrollPhysics(),
      controller: _pageController,
      pageSnapping: true,
      onPageChanged: onPageChanged,
      children: _widgetPages,
    );

    Widget searchButton = showSearchButton?IconButton(icon: Icon(Icons.search), onPressed: ()=>toggleSearchBar()):Container();

    return Scaffold(
        drawer: mainMenu.build(context),
        backgroundColor: Colors.white,
        appBar: AppBar(title: appBarTitle, backgroundColor: Colors.orange, actions: <Widget>[
          searchButton
        ],),
        body: SafeArea( child:pageView )
    );

  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<List<CategoryModel>>(
        future: this.categories,
        builder: (BuildContext context, AsyncSnapshot<List<CategoryModel>> snapshot) {
          if (snapshot.hasData){
            return buildPages(context, snapshot.data);
          }
          return Container(width: 0,height: 0,);
        });

  }
}

