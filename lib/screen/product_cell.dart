import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grocero/component/db.dart';
import 'package:grocero/dao/order_dao.dart';
import 'package:grocero/dao/order_item_dao.dart';
import 'package:grocero/model/model.dart';
import 'package:grocero/model/order_item_model.dart';
import 'package:grocero/model/order_model.dart';
import 'package:grocero/model/product_model.dart';
import 'package:grocero/screen/products.dart';

typedef ProductCellOnChange = void Function(int amount);

class ProductCell extends StatefulWidget {
  //TODO: add order by col asc/desc
  final OrderModel order;
  final ProductModel product;
  final ProductCellOnChange onChange;
  const ProductCell ({ Key key, this.product, this.order, this.onChange }): super(key: key);

  @override
  _ProductCellState createState() => _ProductCellState();
}

class _ProductCellState extends State<ProductCell> {
  bool activeOrder;
  Future<List<OrderItemModel>> order_item;
  OrderModel order;
  ProductModel product;
  Widget availableText;
  TextEditingController qty_controller;
  Widget last_order_item_widget = Container();

  @override
  void initState() {
    super.initState();
    activeOrder = (widget.order.state == OrderState.StateCurrent);

    product = widget.product;
    order = widget.order;

    availableText = (product.available > 0) ? Container(width: 0, height: 0) : Text("NON DISPONIBILE", style: TextStyle(color: Colors.deepOrange, fontSize: 10));
    qty_controller = TextEditingController();
    refresh();
  }

  void refresh(){
    order_item = OrderItemDAO.getOrderProduct(order.id, product.id);
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

    int amount = int.parse(text == null? qty_controller.text: text) + delta;
    if (amount < 0) {
      amount = 0;
    }
    if (amount>product.available){
      amount=product.available;
    }


    List<OrderItemModel> item_list = await OrderItemDAO.getOrderProduct(order.id, product.id);
    OrderItemModel item;
    if (item_list.length == 0) {
      if (amount > 0){
        item = OrderItemModel(order_id: order.id, amount: amount, product_id: product.id);
        DB.save(item);
      }
    } else {
      item = item_list[0];
      if (amount == 0) {
        await DB.delete(item);

      }else {
        item.amount = amount;
        DB.save(item);
      }
    }
    OrderDAO.updateTotal(order.id);
    order = await OrderDAO.get(order.id);

    if (widget.onChange != null){
      widget.onChange(amount);
    }
    if (delta!=0) {
      qty_controller.text = "$amount";
    }
    refresh();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    order_item = OrderItemDAO.getOrderProduct(order.id, product.id);
    return FutureBuilder<List<OrderItemModel>>(
        future: order_item,
        builder: (BuildContext context, AsyncSnapshot<List<OrderItemModel>> snapshot) {
          if (snapshot.hasData ) {
            last_order_item_widget  =  buildCell(context, (snapshot.data.length>0? snapshot.data[0]: null) );
          }
          return last_order_item_widget;
        }
    );
  }

  Widget buildCell(BuildContext context, OrderItemModel order_item) {
    qty_controller.text = order_item == null ? "0" : order_item.amount.toString();

    Widget qtyControls = Container(width: 0, height: 0);
    if (activeOrder && product.available > 0) {
      qtyControls = Container(
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

    }

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
          //onChanged: (text) => changeQuantity(0),
          enabled: activeOrder && product.available > 0,
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
                            availableText,
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
