import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grocero/component/db.dart';
import 'package:grocero/controller/product_cell_controller.dart';
import 'package:grocero/dao/order_dao.dart';
import 'package:grocero/dao/order_item_dao.dart';
import 'package:grocero/main.dart';
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
  ProductCellController ctrl;

  @override
  void initState() {
    super.initState();
    ctrl = ProductCellController();
    ctrl.init(widget.product, widget.order);
  }

  @override
  void dispose() {
    ctrl.dispose();
    super.dispose();

  }

  // mario.rossi@gmail.com
  // luigi.bianchi@gmail.com

  void changeQuantity(int delta, {String text}) async {
    await ctrl.changeQuantity(delta, text: text);
    if (widget.onChange != null){
      widget.onChange( int.tryParse(ctrl.qty_controller.text) );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ctrl.order_item = GroceroApp.sharedApp.dao.OrderItem.getOrderProduct(ctrl.order.id, ctrl.product.id);
    return FutureBuilder<List<OrderItemModel>>(
        future: ctrl.order_item,
        builder: (BuildContext context, AsyncSnapshot<List<OrderItemModel>> snapshot) {
          if (snapshot.hasData ) {
            ctrl.last_order_item_widget  =  buildCell(context, (snapshot.data.length>0? snapshot.data[0]: null) );
          }
          return ctrl.last_order_item_widget;
        }
    );
  }

  Widget buildCell(BuildContext context, OrderItemModel order_item) {
    ctrl.qty_controller.text = order_item == null ? "0" : order_item.amount.toString();

    Widget qtyControls = Container(width: 0, height: 0);
    if (ctrl.activeOrder && ctrl.product.available > 0) {
      qtyControls = Container(
        padding: EdgeInsets.all(1.0),
        margin: EdgeInsets.all(5),
        width: 50,
        height: 100,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              RaisedButton(child: Container(
                child: Text("+", style: TextStyle(
                    fontSize: 25)),
              ), onPressed: () =>
                  changeQuantity(1),),
              RaisedButton(child: Container(
                child: Text("-", style: TextStyle(
                    fontSize: 25)),
              ), onPressed: () =>
                  changeQuantity(-1),)
            ]
        ),
      );

    }

    int amount = int.tryParse(ctrl.qty_controller.text) ?? 0;
    double total = ctrl.product.price*amount;
    Widget rowTotal;
    if (total > 0) {
      rowTotal = Container(
          width: 50,
          height: 50,
          alignment: Alignment.center,
          child: Text("€\n" + total.toStringAsFixed(2), textAlign: TextAlign.center,)
      );
    }else{
      rowTotal = Container();
    }

    Widget qtyText = Container(
        width: 50,
        height: 100,
        padding: EdgeInsets.all(1.0),
        margin: EdgeInsets.all(5),
        color: Colors.grey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              controller: ctrl.qty_controller,
              textAlign: TextAlign.center,
              onEditingComplete: (){
                changeQuantity(0);
                FocusScope.of(context).unfocus();
              },
              onSubmitted:(value) {
                changeQuantity(0);
                FocusScope.of(context).unfocus();
              },
              //onChanged: (text) => changeQuantity(0),
              enabled: ctrl.activeOrder && ctrl.product.available > 0,
            ),
            rowTotal
          ],
        )
    );

    Widget controls = Container(
        //color: Colors.red,
        child:Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        qtyText,
        qtyControls
      ],
    ));

    Widget prod_info = Column(children: [
      Row(
          children: [
        Container(
          height: 90,
          child: ProductImage.loadProductImage(ctrl.product.id),
        ),
        Expanded(child:Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              ctrl.availableText,
              Text(ctrl.product.brand.toUpperCase(), style: TextStyle(fontSize: 18,)),
              Text(ctrl.product.qty),
              Text("€ ${ctrl.product.price.toStringAsFixed(2)}",
                style: TextStyle(fontSize: 30),),
            ]),
        )
      ]),

      Text("${ctrl.product.type.trim()} ${ctrl.product.tags.trim()}",
          style: TextStyle(fontSize: 10)),
    ],);


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
              Text(ctrl.product.name, style: TextStyle(fontSize: 20)),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Expanded(child: prod_info),
                  controls
                ],),
              )
            ],
          )
        ),
      );
  }

}
