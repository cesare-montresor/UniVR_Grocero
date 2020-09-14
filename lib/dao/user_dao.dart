import 'package:grocero/model/user_model.dart';
import '../component/db.dart';

class UserDAO{

  static Future<UserModel> get(int id) async {
    var rows = await DB.query(UserModel.referenceTable(),
        where:'id = ?',
        whereArgs:[id]
    );
    if ( rows.length == 0){ return null; }
    return UserModel.fromMap(rows[0]);
  }

  static Future<UserModel> searchByEmail(String email) async {
    var rows = await DB.query(UserModel.referenceTable(),
        where:'email = ?',
        whereArgs:[email]
    );
    if ( rows.length == 0){ return null; }
    return UserModel.fromMap(rows[0]);
  }

}