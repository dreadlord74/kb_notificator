import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  /*
   * приватный конструктор, 
   * ! который может использоваться только внутри этого класса
   */
  DBProvider._();

  static final DBProvider db = DBProvider._();

  // создания объекта базы данных
  static Database _database;

  /*
   * создадим объект базы данных, 
   * если он еще не был создан (ленивая инициализация)
   */
  Future<Database> get database async {
    if (_database != null)
      return _database;

    // Если нет объекта, присвоенного базе данных, 
    // то вызовем функцию initDB для создания базы данных.
    _database = await initDB();
    return _database;
  }

  initDB() async {
    String path = await _getPath();

    return await openDatabase(
      path,
      version: 2,
      onOpen: (db) async{
        // await db.execute(
        //   "DROP TABLE Messages"
        // );

        await db.execute(
          "CREATE TABLE IF NOT EXISTS Messages ("
            "id INTEGER PRIMARY KEY NOT NULL,"
            "messageID INTEGER NOT NULL,"
            "title TEXT NOT NULL,"
            "body TEXT,"
            "status TEXT NOT NULL,"
            "messageSendTime DATETIME NOT NULL,"
            "messageReceiveTime DATETIME NOT NULL"
          ")"
        );
      },
      onCreate: (Database db, int version) async {
        await db.execute(
          "CREATE TABLE IF NOT EXISTS Messages ("
            "id INTEGER PRIMARY KEY NOT NULL,"
            "messageID INTEGER NOT NULL,"
            "title TEXT NOT NULL,"
            "body TEXT,"
            "status TEXT NOT NULL,"
            "messageSendTime DATETIME NOT NULL,"
            "messageReceiveTime DATETIME NOT NULL"
          ")"
        );
      }
    );
  }

  _getPath() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = documentsDirectory.path + "/database.db";

    return path;
  }
}