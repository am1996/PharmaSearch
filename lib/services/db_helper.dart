import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'dart:developer';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper{
  static Database? _database;
  static const _dbname = 'db.db';
  Future<Database?> get database async{
    if(_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }
  Future<Database> _initDatabase() async {
    final documentsDir = await getApplicationDocumentsDirectory();
    final path = join(documentsDir.path, _dbname);
    bool exists = await databaseExists(path);
    if(!exists){
      log('Copying database from assets..');
      try{
        await Directory(dirname(path)).create(recursive: true);
        ByteData data = await rootBundle.load('assets/$_dbname');
        List<int> bytes = data.buffer.asUint8List(data.offsetInBytes,data.elementSizeInBytes);
        await File(path).writeAsBytes(bytes,flush: true);

      }catch(e) {
        log("Error Copying Database");
        throw Exception("Failed to copy database");
      }
    }else{
      log("database exists");
    }
    return await openDatabase(path,readOnly: false);
  }
  Future<List<Map<String,dynamic>>?> getItems({
    int page=0,
    int pageSize = 50,
    String? searchQuery
  }) async {
    final db = await database;
    String whereClause = '';
    List<dynamic> whereArgs = [];
    if(searchQuery != null && searchQuery.isNotEmpty){
      whereClause = 'WHERE name LIKE ?;';
      final searchTerm = '%$searchQuery%';
      whereArgs = [searchTerm,searchTerm,searchTerm];
      return await db?.query(
        'product_drugs',
        where: whereClause.isNotEmpty ? whereClause : null,
        whereArgs: whereArgs.isNotEmpty ? whereArgs: null
      );
    }
    return null;
  }
}