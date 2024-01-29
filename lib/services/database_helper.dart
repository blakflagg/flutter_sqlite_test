import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/note_model.dart';
import '../models/user_model.dart';

class DatabaseHelper {
  static const int _version = 1;
  static const String _dbName = 'Notes.db';

  static Future<Database> _getDB() async {
    return openDatabase(join(await getDatabasesPath(), _dbName),
        onCreate: (db, version) async {
      await db.execute(
          """CREATE TABLE Note(id INTEGER PRIMARY KEY,title TEXT NOT NULL, description TEXT NOT NULL, user_id INTEGER NOT NULL);""");
      await db.execute(
          """CREATE TABLE User(id INTEGER PRIMARY KEY, user_name VARCHAR(255) NOT NULL ) """);
    }, version: _version);
  }

  static Future<int> addUser(User user) async {
    final db = await _getDB();
    return await db.insert("User", user.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> deleteUser(User user) async {
    final db = await _getDB();
    return await db.delete(
      "Note",
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  static Future<User>? getUserById(int id) async {
    final db = await _getDB();
    List<Map<String, dynamic>> list =
        await db.rawQuery('SELECT * FROM User WHERE id =?', [id]);
    return User.fromJson(list.first);
  }

  static Future<List<User>?> getAllUsers() async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query("User");

    if (maps.isEmpty) {
      return null;
    }

    return List.generate(
      maps.length,
      (index) => User.fromJson(maps[index]),
    );
  }

  static Future<int> getUsersCountv1() async {
    //This is one way to get a record count
    List<User>? list = await getAllUsers();
    if (list == null || list.isEmpty) {
      return 0;
    }
    return list.length;
  }

  static Future<int> getUserCount() async {
    //this is using SQLite to get a record count
    final db = await _getDB();

    final List<Map<String, dynamic>?> result =
        await db.rawQuery("SELECT COUNT(id) as count FROM User;");
    if (result.isEmpty) {
      return 0;
    }
    return result.first!['count'];
  }

  static Future<Map<String, dynamic>?> getNotesJoin(int userId) async {
    //This is a sandbox for testing joins

    final db = await _getDB();

    final List<Map<String, dynamic>?> result = await db.rawQuery(
        """SELECT Note.id, Note.title,Note.description, User.user_name 
        FROM Note JOIN User ON Note.user_id = User.id;""");

    if (result.isEmpty) {
      return null;
    }
    result.forEach((item) {
      print("user: ${item!['user_name']} Title: ${item!['title']}");
    });

    var e = result.first;
    print(e!.keys);

    return null;
  }

  static Future<int> addNote(Note note) async {
    final db = await _getDB();
    return await db.insert("Note", note.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> updateNote(Note note) async {
    final db = await _getDB();
    return await db.update("Note", note.toJson(),
        where: 'id = ?',
        whereArgs: [note.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> deleteNote(Note note) async {
    final db = await _getDB();
    return await db.delete(
      "Note",
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  static Future<List<Note>?> getAllNotes() async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query("Note");

    if (maps.isEmpty) {
      return null;
    }

    return List.generate(
      maps.length,
      (index) => Note.fromJson(maps[index]),
    );
  }
}
