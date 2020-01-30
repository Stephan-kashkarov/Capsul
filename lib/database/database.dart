import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Database db;

class DatabaseFactory {

  static void log(
    String functionName,
    String sql, 
    [
      List<Map<String, dynamic>> selectQueryResult,
      int insertAndUpdateQueryResult,
      List<dynamic> params
    ]
  ) {
    dynamic result;
    if (selectQueryResult != null) {
      result = selectQueryResult;
    } else if (insertAndUpdateQueryResult != null) {
      result = insertAndUpdateQueryResult;
    }
    print("""
    ---+++### Database Log ###+++---
    Function: $functionName,
    Params: ${(params != null) ? params : 'N/A'}
    Result: ${(result != null) ? result : 'N/A'}
    Query: $sql,
    """);
  }

  Future<void> createImageTable(Database db) async {
    await db.execute('''
    CREATE TABLE photos
    (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      image BLOB,
      filter TEXT,
      targetTime TEXT,
      isCompleted BIT NOT NULL
    )''');
  }

  Future<String> getDatabasePath(String dbName) async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, dbName);
    if (!(await Directory(dirname(path)).exists())) {
      await Directory(dirname(path)).create(recursive: true);
    }
    return path;
  }

  Future<void> initTables(Database db, int version) async {
    await createImageTable(db);
  }

  Future<void> initDatabase() async {
    final path = await getDatabasePath("capsul_db");
    db = await openDatabase(path, version: 1, onCreate: initTables);
    print(db);
  }
}