import 'package:grocero/model/card_model.dart';
import 'package:grocero/model/user_model.dart';
import '../component/db.dart';

abstract class CardDAO{
  Future<CardModel> getByUserID(int user_id);
}

class LocalCardDAO implements CardDAO{
  Future<CardModel> getByUserID(int user_id) async {
    var row = await DB.query( CardModel.referenceTable(), where: 'user_id = ?', whereArgs:[user_id] );
    if ( row.length == 0 ){ return null; }
    return CardModel.fromMap(row[0]);
  }
}