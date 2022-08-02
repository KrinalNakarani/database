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
          "CREATE TABLE Student(id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT,no TEXT,std TEXT,Address TEXT)";
      db.execute(quary);
    });
  }

  Future<int> insert(String name, String no, String std, String Address) async {
    database = await checkDB();
    return await database!.insert(
        "Student", {"name": name, "no": no, "std": std, "Address": Address});
  }

  Future<Future<List<Map<String, Object?>>>> readDB() async {
    database = await checkDB();
    String qry = "SELECT * FROM Student";
    var res = database!.rawQuery(qry);
    return res;
  }
}
