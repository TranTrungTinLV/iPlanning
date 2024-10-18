import 'package:sqflite/sqflite.dart';

import 'package:path/path.dart' as p;

class BudgetSqlife {
  static Future<Database> initState() async {
    String path = p.join(await getDatabasesPath(), 'budget_database.db');
    return await openDatabase(path, onCreate: _onCreate, version: 1);
  }

  static Future _onCreate(Database db, int version) async {
    await db.execute('''
CREATE TABLE note_id
    (id TEXT PRIMARY KEY,
    budget_id Text,
    description TEXT,
    expense REAL,
    income REAL,
)
''');
  }
}
