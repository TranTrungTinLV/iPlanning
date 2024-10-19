import 'package:iplanning/models/Budget.dart';
import 'package:iplanning/models/note.dart';
import 'package:iplanning/utils/transactionType.dart';
import 'package:sqflite/sqflite.dart';

import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

class NoteSQLHelper {
  static Database? _database;
  static get getDatabase async {
    if (_database != null) return _database;
    _database = await initStateDatabase();
    return _database;
  }

  static Future<Database> initStateDatabase() async {
    String path = p.join(await getDatabasesPath(), 'budget_database.db');
    return await openDatabase(path, onCreate: _onCreate, version: 1);
  }

  static Future _onCreate(Database db, int version) async {
    Batch batch = db.batch();
    await db.execute('''
CREATE TABLE notes
    (
    note_id TEXT PRIMARY KEY,
    name TEXT,
    budget_id TEXT,
    content TEXT,
    transactionType TEXT,
    amount REAL
)
''');
    print("on created was called");
  }

  // ! insert database
  static Future insertNote({
    required String name,
    required String budget_id,
    required String content,
    required double amount,
    required TransactionType transactionType,
  }) async {
    String res = 'Some Error';
    Database db = await getDatabase;
    try {
      String noteId = const Uuid().v4().split('-')[0];
      NoteModel notes = NoteModel(
          name: name,
          amount: amount,
          budget_id: budget_id,
          transactionType: transactionType,
          content: content,
          note_id: noteId);
      await db.insert('notes', notes.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      print(await db.query('notes'));
      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  // ! getNoteModel
  static Future<List<Map<String, dynamic>>> loadNotesModel(
      String budgetId) async {
    Database db = await getDatabase;
    List<Map<String, dynamic>> maps =
        await db.query('notes', where: 'budget_id = ?', whereArgs: [budgetId]);
    List<NoteModel> notesList = maps.map((map) {
      return NoteModel.fromJson(map);
    }).toList();
    return maps;
  }
}
