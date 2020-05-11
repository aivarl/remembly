import 'dart:developer';

import 'package:CWCFlutter/model/alert.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseProvider {
  static const String TABLE_ALERT = "alert";
  static const String COLUMN_ID = "id";
  static const String COLUMN_NAME = "name";
  static const String COLUMN_DESCRIPTION = "description";
  static const String COLUMN_ENABLED = "enabled";
  static const String COLUMN_START_TIME = "startTime";
  static const String COLUMN_END_TIME = "endTime";

  DatabaseProvider._();
  static final DatabaseProvider db = DatabaseProvider._();

  Database _database;

  Future<Database> get database async {
    print("database getter called");

    if (_database != null) {
      return _database;
    }

    _database = await createDatabase();

    return _database;
  }

  Future<Database> createDatabase() async {
    String dbPath = await getDatabasesPath();

    return await openDatabase(
      join(dbPath, 'alertDB.db'),
      version: 1,
      onCreate: (Database database, int version) async {
        print("Creating alert table");

        await database.execute(
          "CREATE TABLE $TABLE_ALERT ("
          "$COLUMN_ID INTEGER PRIMARY KEY,"
          "$COLUMN_NAME TEXT,"
          "$COLUMN_DESCRIPTION TEXT,"
          "$COLUMN_ENABLED INTEGER,"
          "$COLUMN_START_TIME DATETIME,"
          "$COLUMN_END_TIME DATETIME"
          ")",
        );
      },
    );
  }

  Future<List<Alert>> getAlerts() async {
    final db = await database;

    var alerts = await db
        .query(TABLE_ALERT, columns: [COLUMN_ID, COLUMN_NAME, COLUMN_DESCRIPTION, COLUMN_ENABLED, COLUMN_START_TIME, COLUMN_END_TIME]);

    List<Alert> alertList = List<Alert>();

    alerts.forEach((currentAlert) {
      Alert alert = Alert.fromMap(currentAlert);

      alertList.add(alert);
    });

    return alertList;
  }

  Future<Alert> insert(Alert alert) async {
    final db = await database;
    alert.id = await db.insert(TABLE_ALERT, alert.toMap());
    return alert;
  }

  Future<int> delete(int id) async {
    final db = await database;

    return await db.delete(
      TABLE_ALERT,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<int> update(Alert alert) async {
    final db = await database;

    return await db.update(
      TABLE_ALERT,
      alert.toMap(),
      where: "id = ?",
      whereArgs: [alert.id],
    );
  }
}
