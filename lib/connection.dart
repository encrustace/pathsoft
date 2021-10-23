import 'package:sqflite/sqflite.dart';

var databasePath;
Database database;

Future<void> setConnection() async {
  databasePath = await getDatabasesPath();
  var path = databasePath + '/database.db';
  database = await openDatabase(path);
}
