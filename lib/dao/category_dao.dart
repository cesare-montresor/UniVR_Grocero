import 'package:grocero/model/category_model.dart';
import 'package:grocero/model/user_model.dart';
import '../component/db.dart';

abstract class CategoryDAO{
  Future<List<CategoryModel>> all();
}

class LocalCategoryDAO implements CategoryDAO{
  Future<List<CategoryModel>> all() async {
    var rows = await DB.query( CategoryModel.referenceTable() );
    List<CategoryModel> cats = [];
    for (var row in rows ){
      cats.add(CategoryModel.fromMap(row));
    }
    return cats;
  }
}