import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../data/note_model.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'notes.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
         CREATE TABLE notes(
         id INTEGER PRIMARY KEY AUTOINCREMENT,
         title TEXT NOT NULL,
         description TEXT NOT NULL,
         createdAt INTEGER
         )
         ''');
      },
    );
  }

  // insert
  static Future<int> insertNote(Notes notes) async {
    final db = await DBHelper.database;
    return await db.insert(
      'notes',
      Notes.toJson(notes),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // get
  static Future<List<Notes>> getNotes() async {
    final db = await DBHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('notes');
    return maps.map((json) => Notes.fromJson(json)).toList();
  }

  // update
  static Future<int> updateNotes(Notes notes) async {
    final db = await DBHelper.database;
    return await db.update(
      'notes',
      Notes.toJson(notes),
      where: 'id = ?',
      whereArgs: [notes.id],
    );
  }

  //delete
  static Future<int> deleteNote(Notes notes) async {
    final db = await DBHelper.database;
    return await db.delete('notes', where: 'id = ?', whereArgs: [notes.id]);
  }
}
