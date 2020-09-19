import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grocero/component/db.dart';
import 'package:grocero/dao/order_dao.dart';
import 'package:grocero/dao/order_item_dao.dart';
import 'package:grocero/dao/product_dao.dart';
import 'package:grocero/main.dart';
import 'package:grocero/model/model.dart';
import 'package:grocero/model/order_item_model.dart';
import 'package:grocero/model/order_model.dart';
import 'package:grocero/model/product_model.dart';
import 'package:grocero/screen/products.dart';

typedef WarehouseCellOnSelectProduct = void Function(ProductModel product);

class WarehouseCell extends StatefulWidget {
  final ProductModel product;
  final WarehouseCellOnSelectProduct onSelectProduct;
  const WarehouseCell ({ Key key, this.product, this.onSelectProduct }): super(key: key);

  @override
  _WarehouseCellState createState() => _WarehouseCellState();
}

class _WarehouseCellState extends State<WarehouseCell> {
  ProductModel product;
  TextEditingController qty_controller;
  Widget last_order_item_widget = Container();

  @override
  void initState() {
    super.initState();

    product = widget.product;

    qty_controller = TextEditingController();
    refreshData();
  }

  void refreshData() async {
    product = await GroceroApp.sharedApp.dao.Product.get(product.id);
  }

  @override
  void dispose() {
    qty_controller.dispose();
    super.dispose();
  }

  // mario.rossi@gmail.com
  // luigi.bianchi@gmail.com

  void changeQuantity(int delta, {String text}) async {
    // Update UI

    int amount = int.parse(text == null ? qty_controller.text: text) + delta;
    if (amount < 0) {
      amount = 0;
    }
    product.available = amount;
    await DB.save(product);
    qty_controller.text = "$amount";
    refreshData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return buildCell(context);
  }

  void open_details(){
    if (widget.onSelectProduct != null){
      widget.onSelectProduct(product);
    };
  }

  Widget buildCell(BuildContext context) {
    qty_controller.text = product.available.toString();

    return Container(
      color: Color.fromRGBO(240, 240, 240, 1),
      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),

      child: ListTile(
        onTap: ()=>open_details(),
        contentPadding: EdgeInsets.all(0),
        title: Container(
            height: 160,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10)
            ),
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(product.name, style: TextStyle(fontSize: 20)),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        height: 90,
                        child: ProductModel.pictureByID(product.id),
                      ),
                      Expanded(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(product.brand.toUpperCase(),
                                  style: TextStyle(fontSize: 18,)),
                              Text(product.qty),
                              Text("€ ${product.price.toStringAsFixed(2)}",
                                style: TextStyle(fontSize: 30),),
                            ]
                        ),
                      ),
                      Container(width: 50, child:Icon(Icons.arrow_forward_ios)),
                    ],
                  ),
                ),
                Text("${product.type.trim()} ${product.tags.trim()}",
                    style: TextStyle(fontSize: 10)),
              ],
            )
        ),
      ),
    );
  }

}
