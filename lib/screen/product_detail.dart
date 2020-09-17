import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocero/component/db.dart';
import 'package:grocero/dao/category_dao.dart';
import 'package:grocero/main.dart';
import 'package:grocero/model/category_model.dart';
import 'package:grocero/model/product_model.dart';
import 'package:grocero/model/user_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as ImgLib;

typedef ProductDetailSuccess =  void Function();

class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;
  final ProductDetailSuccess onSuccess;
  const ProductDetailScreen({Key key, this.onSuccess, this.product}) : super(key: key);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  UserModel user = GroceroApp.sharedApp.currentUser;
  ProductModel product;
  Future<List<CategoryModel>> categories;
  Map<int, CategoryModel> catByID;
  final image_picker = ImagePicker();

  TextEditingController name;
  int selected_category;
  TextEditingController brand;
  TextEditingController qty;
  TextEditingController available;
  TextEditingController price;
  TextEditingController type;
  TextEditingController tags;
  Image img;
  File imgFile;

  Widget widget_cat_list;

  void dismiss(){
    name.dispose();
    brand.dispose();
    qty.dispose();
    available.dispose();
    price.dispose();
    type.dispose();
    tags.dispose();
  }

  @override
  void initState() {
    super.initState();
    product = widget.product;
    categories = CategoryDAO.all();
    bool has_product = (product != null);
    if ( product == null){
      product = ProductModel();
    }

    //For Listbox
    catByID = {};
    //for  (CategoryModel cat in categories){
    //  catByID[cat.id] = cat;
    //}

    name= TextEditingController(text: has_product ? product.name :'' );
    // selected_category = has_product && catByID.containsKey(product.category_id)? catByID[product.category_id] : categories[0]?.id ; //TODO category selector
    // selected_category = 0;

    brand= TextEditingController(text: has_product ? product.brand :'');
    qty= TextEditingController(text: has_product ? product.qty :'');
    available= TextEditingController(text: has_product ? product?.available?.toString() : '0');
    price= TextEditingController(text: has_product ? product?.price?.toStringAsFixed(2) : '0.0');
    type= TextEditingController(text: has_product ? product.type :'');
    tags= TextEditingController(text: has_product ? product.tags :'');
  }

  category_changed( int value) async {
    selected_category = value;
    setState(() {});
  }

  save_product({bool close}) async {
    await DB.save(product);
    if (imgFile != null) {
      final directory = await getApplicationDocumentsDirectory();
      String img_path = join(
          directory.path, 'image', 'product_${product.id}.jpg');
      imgFile.copy(img_path);
      Fluttertoast.showToast(
        msg: "Prodotto salvato",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );

      if (widget.onSuccess != null) {
        widget.onSuccess();
      }

      if (close) {
        Navigator.of(this.context).pop();
      }
    }
  }

  open_picker() async{
    File tmp_file = await ImagePicker.pickImage(source: ImageSource.camera);
    if (tmp_file != null) {
      imgFile = tmp_file;
      setState(() {
        img = Image.file(tmp_file);
      });
    }
  }

  remove_image(){
    setState(() {
      img = null;
      imgFile = null;
    });
  }

  Widget FlexRow(Widget left, Widget right, {double ratio}){
    ratio = ratio == null?0.5:ratio;
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
      Expanded(
        child: left,
        flex: (10*ratio).toInt()
      ),
      Expanded(
        child: right,
        flex: (10*(1-ratio)).toInt()
      ),

    ]);
  }

  @override
  Widget build(BuildContext context) {
    Widget delete_image_button = ( img == null ) ?
      RaisedButton(child: Text("Selezione immagine"), onPressed: ()=>open_picker(),):
      RaisedButton(child: Text("Elimina immagine"), onPressed: ()=>remove_image(),);


    widget_cat_list = FutureBuilder<List<CategoryModel>>(
      future: categories,
      builder: (BuildContext context, AsyncSnapshot<List<CategoryModel>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done){
          var cats = snapshot.data;
          return DropdownButton(
            items: cats.map((cat)=>DropdownMenuItem(child: Text(cat.name), value:cat.id)).toList(),
            value: selected_category,
            onChanged: (value) => category_changed(value),
          );
        }
        return DropdownButton(items: [], onChanged: (value) {  },);
      },
    );



    List<Widget> fields =  [
        // Nome
        Text("Nome"),
        TextField(controller: name, onChanged: (text){product.name=text.trim(); },),

        //Brand
        FlexRow(
          Text("Brand"),
          TextField(controller: brand, textAlign:  TextAlign.left , onChanged: (text){product.brand=text.trim(); },)
        ),
        FlexRow(
          Text("Categoria"),
          widget_cat_list,
        ),
        FlexRow(
          Text("Quantità"),
          TextField(controller: qty, textAlign: TextAlign.right, onChanged: (text){product.qty=text.trim(); },),
        ),
        FlexRow(
          Text("Disponibilità"),
          TextField(controller:  available, textAlign: TextAlign.right, onChanged: (text){
            text = text.trim();
            String clean = text.replaceAll('[^0-9]', '');
            if (clean != text){
              name.text = clean;
            }
            int value = int.tryParse(clean) ?? 0;
            if (value < 0){ value = 0;}
            product.available = value;
          },),
        ),
        FlexRow(
          Text("Prezzo €"),
          TextField(controller: price, textAlign: TextAlign.right, onChanged: (text){
            text = text.trim();
            String clean = text.replaceAll(',', '.');
            clean = clean.replaceAll('[^.0-9]', '');
            if (clean != text){
              name.text = clean;
            }
            double value = double.tryParse(clean) ?? 0;
            if (value < 0){ value = 0;}
            product.price = value;
          },),
        ),
        FlexRow(
          Text("Tipo"),
          TextField(controller: type,  textAlign:  TextAlign.left,  onChanged: (text){product.type=text.trim(); },),
        ),
        //Tags
        Text("Tags"),
        TextField(controller: tags,  textAlign:  TextAlign.left, onChanged: (text){product.tags=text.trim(); },),
        //Image
        FlexRow(
          delete_image_button,
          Container(

            key: ValueKey(img),
            child: Container( height: 100, child: img) ?? Container(width: 100,),
          ),
        ),
        FlexRow(
          RaisedButton(child: Text("Salva"), onPressed: ()=>save_product()),
          RaisedButton(child: Text("Salva e chiudi"), onPressed: ()=>save_product(close:true)),
        ),
    ];


    AppBar topbar = AppBar(
        title: Text(product?.name != null ? product.name :  "Nuovo Prodotto"),
        actions: [
          IconButton(icon: Icon(Icons.save_alt), onPressed: ()=>save_product())
        ]
    );



    return Scaffold(
      appBar: topbar,
      body: SafeArea(
          child: Container(
            padding: EdgeInsets.all(10),
            child: ListView(
              shrinkWrap: true,
              children: fields
            ),
          ),
      ),
    );

  }

}