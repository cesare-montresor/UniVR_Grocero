import 'package:grocero/model/model.dart';

class WorkerRole{
  static String Peon = 'peon';
  static String Supervisor = 'supervisor';
}

class WorkerModel extends Model {
  int user_id;
  String role;
  String badge_number;

  static String referenceTable() => "worker";
  String tableName() => referenceTable();

  @override
  WorkerModel({int id, String role, String name, String surname, String email, String password, String address, String zipcode, String city, String phone, String fav_payment}) : super(id: id) {
    this.user_id=user_id;
    this.role = role ?? WorkerRole.Peon;
    this.badge_number=badge_number ?? "";
  }

  @override
  WorkerModel.fromMap(Map<String, dynamic> map) : super.fromMap(map){
    this.user_id=map['user_id'];
    this.role = map['role'] ?? WorkerRole.Peon;
    this.badge_number=map['badge_number'] ?? "";
  }

  @override
  Map<String, dynamic> toMap() {
    var data = super.toMap();
    data["user_id"] = this.user_id;
    data["role"] = this.role;
    data["badge_number"] = this.badge_number;
    return data;
  }


}
