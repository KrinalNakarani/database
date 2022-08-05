import 'dart:io';
import 'package:database/screen/StudentScreen.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DBhelper {
  Database? database;

  Future<Database> checkDB() async {
    if (database != null) {
      return database!;
    } else {
      return await initDB();
    }
  }

  Future<Future<Database>> initDB() async {
    Directory Dr = await getApplicationDocumentsDirectory();
    String path = join(Dr.path, "Flluter.db");
    return openDatabase(path, version: 1, onCreate: (db, version) {
      String quary =
          "CREATE TABLE Student(id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT,no TEXT,std TEXT,Address TEXT,img TEXT)";
      db.execute(quary);
    });
  }

  Future<int> insert(
      String name, String no, String std, String Address, String img) async {
    database = await checkDB();
    return await database!.insert("Student",
        {"name": name, "no": no, "std": std, "Address": Address, "img": img});
  }

  Future<List<Map<String, dynamic>>> readDB(String? std) async {
    database = await checkDB();
    String qry = "";
    if (std != null) {
      qry = "SELECT * FROM Student WHERE std = $std";
    } else {
      qry = "SELECT * FROM Student";
    }
    var res = database!.rawQuery(qry);
    return res;
  }

  void deletDB(int id) async {
    database = await checkDB();
    database!.delete("Student", where: "id=$id");
  }

  void updateDB(
      int id, String name, String no, String std, String Address) async {
    database = await checkDB();
    database!.update(
        "Student",
        {
          "name": name,
          "no": no,
          "std": std,
          "Address": Address,
        },
        where: "id=?",
        whereArgs: [id]);
  }
}
