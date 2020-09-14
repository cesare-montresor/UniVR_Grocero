
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grocero/component/auth.dart';
import 'package:grocero/dao/category_dao.dart';
import 'package:grocero/model/category_model.dart';
import 'package:grocero/routes.dart';

typedef MainMenuOnClick = void Function(MainMenuItem menu_item);

//Menu type, affect behaviour on click
class MainMenuItemType {
  static String Divider = 'divisor';
  static String Label = 'label';
  static String Category = 'category';
  static String Cart = 'cart';
  static String Orders = 'orders';
  static String Profile = 'profile';
  static String Warehouse = 'warehouse';
  static String Logout = 'logout';
  static String Expanded = 'expanded';
}

//Menu Item
class MainMenuItem{
  String text;
  String type;
  int cat_id;

  MainMenuItem({String text, String type, int cat_id}){
    this.text = text;
    this.type = type;
    this.cat_id = cat_id;
  }

  bool equals(MainMenuItem other){
    if (other == this) {return true;}
    //if (other.text != this.text) {return false;}
    if (other.type != this.type) {return false;}
    if (this.type == 'category' && other.cat_id != this.cat_id){return false;}
    return true;
  }
}


class MainMenu extends StatelessWidget{
  Future<List<CategoryModel>> categories;
  MainMenuOnClick onClick;
  MainMenuItem last_selection;
  List<MainMenuItem> menu_items=[];

  void initComponent(MainMenuOnClick onClick){
    this.categories =  CategoryDAO.all();
    this.onClick = onClick;
  }

  Color colorForItem(MainMenuItem item){
    if (item == null || last_selection == null){ return Colors.black54; }
    if (item.equals(last_selection)){ return Colors.blueAccent; }
    return Colors.black54;
  }

  Widget buildMenuItem(BuildContext context, MainMenuItem item){
    if (item.type == MainMenuItemType.Label){
      return ListTile(title: Text(item.text.toUpperCase(), style: TextStyle(color: Colors.grey, letterSpacing: 5) ), enabled: false );
    }

    if (item.type == MainMenuItemType.Divider){
      return Divider();
    }

    if (item.type == MainMenuItemType.Expanded){
      return Flexible(child: Container(width: 1,),);
    }

    if (item.type == MainMenuItemType.Logout){
      return FlatButton(
        color: Colors.red,
        onPressed: (){
            Auth.logout();
            Navigator.of(context).pushReplacementNamed(Router.RouteLogin);
        },
        child:Container(
          height: 50,
          alignment: Alignment.center,
          child: IntrinsicWidth(child: Text(item.text.toUpperCase(), style: TextStyle(color: Colors.white, letterSpacing: 5) , )),

        ),
      );
    }

    return ListTile(
      title: Text( item.text, style: TextStyle( color: colorForItem(item) ) ),
      onTap: () {
        Navigator.pop(context);
        onClick( item );
      },
    );
  }


  Widget build(BuildContext context) {
    List<Widget> menuItems = menu_items.map((item)=>buildMenuItem(context,item)).toList();

    return Drawer(
        child: SafeArea(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                key: ValueKey(menuItems.length),
                //physics: NeverScrollableScrollPhysics(),
                //shrinkWrap: true,
                children: menuItems,
            )
        )
    );
  }

}