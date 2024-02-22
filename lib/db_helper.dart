import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHelper {
  static Future<Database> db() async {
    return openDatabase(join(await getDatabasesPath(), "note.db"), version: 1,
        onCreate: (Database db, int version) async {
      db.execute('''CREATE TABLE IF NOT EXISTS note (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        title TEXT,
        description TEXT
      )''');
    });
  }

  ///ADD
  static Future<int> addNote(
      {required String title, required String des}) async {
    final db = await DbHelper.db();
    return db.insert("note", {"title": title, "description": des});
  }

  ///Update
  static Future<int> editNote(
      {required int id, String? title, String? des}) async {
    final db = await DbHelper.db();
    return db.update("note", {"title": title, "description": des},
        where: "id=?", whereArgs: [id]);
  }

  ///delete
  static Future<int> deleteNote(int id) async {
    final db = await DbHelper.db();
    return db.delete("note", where: "id=?", whereArgs: [id]);
  }

  static Future<List<Map<String, dynamic>>> getNotes() async {
    final db = await DbHelper.db();
    return db.query("note");
  }
}
