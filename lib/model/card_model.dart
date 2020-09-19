import 'package:grocero/model/model.dart';
import 'package:grocero/model/user_model.dart';

class CardModel extends Model {
  int user_id;
  int creation_date;
  int points;

  static String referenceTable() => "card";
  String tableName() => referenceTable();

  @override
  CardModel({int id, int user_id, int creation_date, int points}) : super(id: id) {
    this.user_id = user_id;
    this.creation_date=creation_date ?? 0;
    this.points=points ?? 0;
  }

  @override
  CardModel.fromMap(Map<String, dynamic> map) : super.fromMap(map){
    this.user_id = map['user_id'];
    this.creation_date=map['creation_date'] ?? "";
    this.points=map['points'] ?? 0;
  }

  @override
  Map<String, dynamic> toMap() {
    var data = super.toMap();
    data["user_id"] = this.user_id;
    data["creation_date"] = this.creation_date;
    data["points"] = this.points;
    return data;
  }


}
