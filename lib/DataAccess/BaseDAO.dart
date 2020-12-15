import 'package:AppDown/DataAccess/DbUtils.dart';
import 'package:sqflite/sqflite.dart';

abstract class BaseDAO<T>
{
  Future<Database> get dbContext => DbUtils.getInstance().dataBase;

  String get tableName;

  Map<String, dynamic> toMapData(T model);

  T toModel(Map<String, dynamic> map);

  Future<int> addOrUpdate(T model) async 
  {
    try
    {
      var dbClient = await dbContext;
      var id = await dbClient.insert(tableName, 
                                     toMapData(model),
                                     conflictAlgorithm: ConflictAlgorithm.replace);
      return id;                                   
    }
    on Exception catch (error)
    {
      print(error.toString());
      throw error;
    }
  }

  Future<int> delete(int id) async
  {
    try
    {
      var dbClient = await dbContext;
      return await dbClient.rawDelete('delete from $tableName where id = ?', [id]);
    }
    on Exception catch (error)
    {
      throw error;
    }
  }

  Future<T> findById(int id) async 
  {
    try
    {
      var dbClient = await dbContext;
      var obj = (await dbClient.rawQuery('select * from $tableName where id = ?', [id])).first;

      var model = toModel(obj);
      return model;
    }
    on Exception catch (error)
    {
      throw error;
    }
  }

  Future<List<T>> getAll() async
  {
    try
    {
      var dbClient = await dbContext;
      var list = await dbClient.rawQuery('select * from $tableName');

      final listModels = list.map<T>((data) => toModel(data)).toList();
      return listModels;
    }
    on Exception catch (error)
    {
      throw error;
    }
  }
} 