import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DBHelper {
  static final _dbName = 'myToDoList.db';
  static final _dbVersion = 1;
  static final _tableName = "myTable";
  static final columnId = '_id';
  static final columnTitle = 'Title';
  static final columnDesc = 'Description';
  static final timestamp = 'Timestamp';
  //creating a class
  DBHelper._privateConstructor();
  static final DBHelper instance = DBHelper._privateConstructor();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    } else {
      print('shit shit 1');
      _database = await _initiateDatabase();
      return _database;
    }
  }

  _initiateDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _dbName);
    return await openDatabase(path, version: _dbVersion,
        onCreate: (Database db, int version) {
      db.execute(
          'CREATE TABLE $_tableName( $columnId INTEGER PRIMARY KEY, $columnTitle TEXT NOT NULL, $columnDesc TEXT NOT NULL, $timestamp INT)');
    });
  }

  Future _onCreate(Database db, int version) {
    db.execute(
        'CREATE TABLE $_tableName( $columnId INTEGER PRIMARY KEY, $columnTitle TEXT NOT NULL, $columnDesc TEXT NOT NULL, $timestamp INT)');
  }

  //returns the primary key of the generated row
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(_tableName, row);
  }

//returns the table, more like printing the table
  Future<List<Map<String, dynamic>>> queryAll() async {
    Database db = await instance.database;
    return await db.query(_tableName);
  }

  //editing the existing values in the ToDo list
  //returns no of rows updated
  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db
        .update(_tableName, row, where: '$columnId=?', whereArgs: [id]);
  }

  //to delete a row in to-do list

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(_tableName, where: '$columnId=?', whereArgs: [id]);
  }
}
