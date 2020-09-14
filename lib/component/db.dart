import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:grocero/model/model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

abstract class DB {
  static Database _db;

  static Future<void> init() async {
    var databasesPath = await getDatabasesPath();
    var path = databasesPath + '/local.sqlite';
    var exists = await databaseExists(path);
    if (!exists) {
      //print('copying assets database 100');
      ByteData data = await rootBundle.load('asset/local.sqlite');
      //print('copying assets database 200');
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      //print('copying assets database 300');
      await File(path).writeAsBytes(bytes);
      //print('copying assets database 400');
    }

    try {
      _db = await openDatabase(path);
    }
    catch(ex) {
      print(ex);
    }
  }
  static Future<List<Map<String, dynamic>>> rawQuery(String sql, [ List<dynamic> args ]) async =>
      await _db.rawQuery(sql, args);

  static Future<int> rawDelete(String sql, [ List<dynamic> args ]) async =>
      await _db.rawDelete(sql, args);

  static Future<List<Map<String, dynamic>>> query(String table, {List<String> columns,String where, List<dynamic> whereArgs, String orderBy }) async =>
      await _db.query(table, columns: columns, where: where, whereArgs: whereArgs, orderBy: orderBy, );

  static Future<int> insert(Model model) async =>
      await _db.insert(model.tableName() , model.toMap());

  static Future<int> update(Model model) async =>
      await _db.update(model.tableName(), model.toMap(), where: 'id = ?', whereArgs: [model.id]);

  static Future<int> delete(Model model) async =>
      await _db.delete(model.tableName(), where: 'id = ?', whereArgs: [model.id]);



  static Future<Map<String, dynamic>> get(String table, int id) async {
      var list = await _db.query(table, where: "id = ?", whereArgs: [id] );
      if ( list.length > 0 ){
        return list[0];
      }
      return null;
  }

  static Future<int> save(Model model) async {
    if (model.id != null){
      await DB.update(model);
      return model.id;
    }else{
      return await DB.insert(model);
    }
  }
}