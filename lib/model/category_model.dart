import 'package:grocero/model/model.dart';
import 'package:grocero/model/user_model.dart';

class CategoryModel extends Model {
  String name;

  static String referenceTable() => "category";
  String tableName() => referenceTable();


  @override
  CategoryModel({int id, String name}) : super(id: id) {
    this.name = name ?? "";
  }

  @override
  CategoryModel.fromMap(Map<String, dynamic> map) : super.fromMap(map){
    this.name = map['name'] ?? "";
  }

  @override
  Map<String, dynamic> toMap() {
    var data = super.toMap();
    data["name"] = this.name ?? "";
    return data;
  }


}
