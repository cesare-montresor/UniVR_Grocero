abstract class Model{
  int id;

  String tableName(){ return null; }


  Map<String, dynamic> toMap(){
    var data = Map<String, dynamic>();
    data['id'] = this.id;
    return data;
  }

  Model({int id}){
    this.id = id;
  }

  Model.fromMap(Map<String, dynamic> map){
    this.id=map['id'];
  }
}

