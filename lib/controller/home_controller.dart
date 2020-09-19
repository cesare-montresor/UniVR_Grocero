import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:grocero/component/auth.dart';
import 'package:grocero/main.dart';
import 'package:grocero/model/category_model.dart';
import 'package:grocero/model/user_model.dart';
import 'package:grocero/routes.dart';
import 'package:grocero/controller/controller.dart';
import 'package:grocero/screen/menu.dart';
import 'package:grocero/screen/products.dart';

class HomeScreenController extends Controller{
  Future<List<CategoryModel>> categories;
  MainMenu mainMenu = MainMenu();
  int defaultPage = 4;
  int currentPage = 0;
  PageController pageController;
  List<String> pageOrder;
  Text appBarTitle;
  List<Widget> widgetPages;
  List<MainMenuItem> pageMenuItems;
  bool searchBarVisible = false;
  bool showSearchButton = true;

  void init(){
    mainMenu.initComponent(menuOnClick);
    this.categories = GroceroApp.sharedApp.dao.Category.all();

    pageController = PageController(initialPage: 0);
    appBarTitle = Text("");
  }

  void onPageChanged(int page) {
    menuOnClick(pageMenuItems[page]);
  }

  void menuOnClick(MainMenuItem menu_item){
    currentPage = pageMenuItems.indexOf(menu_item);
    String type = menu_item.type;
    if ( menu_item.type == 'category' ){
      type += "_${menu_item.cat_id}";
    }

    int page_num = pageOrder.indexOf(type);
    appBarTitle = Text(menu_item.text);

    mainMenu.last_selection = menu_item;
    pageController.jumpToPage(page_num);
    updateSearchbar();
  }

  void toggleSearchBar(){
    searchBarVisible = !searchBarVisible;
    updateSearchbar();

  }

  void updateSearchbar(){
    MainMenuItem itm =  pageMenuItems[currentPage];
    bool res;

    if (itm.type != MainMenuItemType.Orders && itm.type != MainMenuItemType.Profile){
      res = true;
      ProductsScreen page = widgetPages[currentPage];
      page.filter.show_searchbar = searchBarVisible;
    }else{
      res = false;
    }
    showSearchButton = res;
  }

  void jumpToProfile(){
    int page = pageOrder.indexOf(MainMenuItemType.Profile);
    pageController.jumpToPage(page);
  }

  void jumpToOrders(){
    int page = pageOrder.indexOf(MainMenuItemType.Orders);
    pageController.jumpToPage(page);
  }

  void jumpToCart(){
    int page = pageOrder.indexOf(MainMenuItemType.Cart);
    pageController.jumpToPage(page);
  }

  void jumpToCategory(int id){
    int page = pageOrder.indexOf(MainMenuItemType.Category+"_$id");
    if (page != -1 ) {
      pageController.jumpToPage(page);
    }

  }

  void dispose() {
    pageController.dispose();
  }

}