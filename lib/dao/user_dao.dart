import 'package:grocero/model/user_model.dart';
import '../component/db.dart';

abstract class UserDAO{
  Future<UserModel> get(int id);
  Future<UserModel> searchByEmail(String email);
}

class LocalUserDAO implements UserDAO{

  Future<UserModel> get(int id) async {
    var rows = await DB.query(UserModel.referenceTable(),
        where:'id = ?',
        whereArgs:[id]
    );
    if ( rows.length == 0){ return null; }
    return UserModel.fromMap(rows[0]);
  }

  Future<UserModel> searchByEmail(String email) async {
    var rows = await DB.query(UserModel.referenceTable(),
        where:'email = ?',
        whereArgs:[email]
    );
    if ( rows.length == 0){ return null; }
    return UserModel.fromMap(rows[0]);
  }

}