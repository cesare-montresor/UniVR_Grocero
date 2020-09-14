import 'package:grocero/model/card_model.dart';
import 'package:grocero/model/user_model.dart';
import 'package:grocero/model/worker_model.dart';
import '../component/db.dart';

class WorkerDAO{
  static Future<WorkerModel> getByUserID(int user_id) async {
    var row = await DB.query( WorkerModel.referenceTable(), where: 'user_id = ?', whereArgs:[user_id] );
    if ( row.length == 0 ){ return null; }
    return WorkerModel.fromMap(row[0]);
  }


}