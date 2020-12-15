import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DbUtils 
{
  static final DbUtils _instance = DbUtils.getInstance();
  DbUtils.getInstance();

  factory DbUtils() => _instance;

  static sql.Database _dataBase;

  Future<sql.Database> get dataBase async
  {
    if (_dataBase != null)
    {
      return _dataBase;
    }

    _dataBase = await _initDb();
    return _dataBase;
  }

  void _createDb(sql.Database db, int versionDb) async
  {
    String s = await rootBundle.loadString("assets/sql/create.sql");
    List<String> queries = s.split(";");

    for (var query in queries)
    {
      if (query.trim().isNotEmpty)
      {
        await db.execute(query);    
      }
    }
  }

  Future<sql.Database> _initDb() async 
  {
    var dbPaths = await sql.getDatabasesPath();
    var appDownPath = path.join(dbPaths, 'AppDown.db');

    var db = await sql.openDatabase(appDownPath, 
                                    version: 1,
                                    onCreate: _createDb);
    return db;                                    
  }

  Future close() async 
  {
    var dbClient = await dataBase;
    return dbClient.close();
  }
}