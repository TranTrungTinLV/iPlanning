import 'package:sqflite/sqflite.dart';

import 'package:path/path.dart' as p;

class BudgetSQLHelper {
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
    // Batch batch = db.batch();
    db.execute('''
CREATE TABLE note_id
    (
    note_id TEXT PRIMARY KEY,
    budget_id Text,
    description TEXT,
    expense DOUBLE,
    income DOUBLE
)
''');
    print("on created was called");
  }
}
