import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grocero/component/db.dart';
import 'package:grocero/dao/order_dao.dart';
import 'package:grocero/dao/order_item_dao.dart';
import 'package:grocero/dao/product_dao.dart';
import 'package:grocero/model/model.dart';
import 'package:grocero/model/order_item_model.dart';
import 'package:grocero/model/order_model.dart';
import 'package:grocero/model/product.dart';
import 'package:grocero/screen/products.dart';

typedef WarehouseCellOnChange = void Function(int amount);

class WarehouseCell extends StatefulWidget {
  final ProductModel product;
  final WarehouseCellOnChange onChange;
  const WarehouseCell ({ Key key, this.product, this.onChange }): super(key: key);

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
    product = await ProductDAO.get(product.id);
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

  Widget buildCell(BuildContext context) {
    qty_controller.text = product.available.toString();

    Widget qtyControls = Container(
      width: 40,
      child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            RaisedButton(child: Text("+", style: TextStyle(
                fontSize: 20)), onPressed: () =>
                changeQuantity(1),),
            RaisedButton(child: Text("-", style: TextStyle(
                fontSize: 20)), onPressed: () =>
                changeQuantity(-1),)
          ]
      ),
    );

    Widget qtyText = Container(
        width: 50,
        height: 50,
        padding: EdgeInsets.all(1.0),
        margin: EdgeInsets.all(10),
        color: Colors.grey,
        child: TextField(
          controller: qty_controller,
          textAlign: TextAlign.center,
          onEditingComplete: (){
            changeQuantity(0);
            FocusScope.of(context).unfocus();
          },
        )
    );


    return Container(
      color: Color.fromRGBO(240, 240, 240, 1),
      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),

      child: Container(
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
                    qtyText,
                    Container(width: 50, child:qtyControls ),
                  ],
                ),
              ),
              Text("${product.type.trim()} ${product.tags.trim()}",
                  style: TextStyle(fontSize: 10)),
            ],
          )
      ),
    );
  }

}
