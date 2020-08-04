import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:note_app/model/reminder_model.dart';

class DatabaseHelper {
  String tableName = 'Reminders';

  DatabaseHelper._();

  static final DatabaseHelper db = DatabaseHelper._();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await initDatabase();
    return _database;
  }

//  int id;
//  String title;
//  String type;
//  int hour;
//  int minute;
//  int day;
//  int month;
//  int year;
//  String weekDays;
//  int noOfWeeks;
//  int status;

  initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "Reminder.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE $tableName (id INTEGER PRIMARY KEY AUTOINCREMENT,title TEXT,description TEXT,type TEXT,hour INTEGER,minute INTEGER,period TEXT,day INTEGER,month INTEGER,year INTEGER,weekDays TEXT,noOfWeeks INTEGER,status INTEGER)');
    });
  }

//Getting reminders

  getAllScheduledReminders() async {
    final db = await database;
    var res = await db
        .rawQuery('SELECT * FROM $tableName WHERE status=1 ORDER BY id DESC');
    List<Reminder> list =
        res.isNotEmpty ? res.map((c) => Reminder.fromMap(c)).toList() : [];
    return list;
  }

  getAllCancelledReminders()async{
    final db = await database;
    var res = await db
        .rawQuery('SELECT * FROM $tableName WHERE status=2 ORDER BY id DESC');
    List<Reminder> list =
    res.isNotEmpty ? res.map((c) => Reminder.fromMap(c)).toList() : [];
    return list;
  }

  getAllFiredReminders() async {
    final db = await database;
    var res = await db
        .rawQuery('SELECT * FROM $tableName WHERE status=0 ORDER BY id DESC');
    List<Reminder> list =
        res.isNotEmpty ? res.map((c) => Reminder.fromMap(c)).toList() : [];
    return list;
  }

  addANewReminder(Reminder reminder) async {
    final db = await database;
    var res = await db.insert('$tableName', reminder.toMap());
    return res;
  }

  updateAReminder(Reminder reminder) async {
    final db = await database;
    var res = await db.update('$tableName', reminder.toMap(),where: 'id=?',whereArgs: [reminder.id]);
    return res;
  }

  deleteAReminder(int id) async {
    final db = await database;
    var res = await db.delete(tableName, where: 'id=?', whereArgs: [id]);
    return res;
  }

  changeToFired(Reminder reminder)async{
    final db = await database;
    reminder.status=0;
    var res = await db.update('$tableName', reminder.toMap(),where: 'id=?',whereArgs: [reminder.id]);
    return res;
  }

  changeToCancelled(Reminder reminder)async{
    final db = await database;
    reminder.status=2;
    var res = await db.update('$tableName', reminder.toMap(),where: 'id=?',whereArgs: [reminder.id]);
    return res;
  }

  Future<int> getAllReminders() async {
    final db = await database;
    var res = await db
        .rawQuery('SELECT * FROM $tableName');
    List<Reminder> list =
    res.isNotEmpty ? res.map((c) => Reminder.fromMap(c)).toList() : [];
    return list.length;
  }

  Future<int> getNoOfReminders(int status)async{
    final db = await database;
    var res = await db
        .rawQuery('SELECT * FROM $tableName WHERE status=$status');
    List<Reminder> list =
    res.isNotEmpty ? res.map((c) => Reminder.fromMap(c)).toList() : [];
    return list.length;
  }

  cancelAllReminders()async{
    final db = await database;
    var res = await db
        .rawQuery('SELECT * FROM $tableName WHERE status=1 ORDER BY id DESC');
    List<Reminder> list =
    res.isNotEmpty ? res.map((c) => Reminder.fromMap(c)).toList() : [];
    for(int  i=0;i<list.length;i++){
      list[i].status=2;
      updateAReminder(list[i]);
    }
  }

  deleteAllReminders()async{
    final db=await database;
    await db.delete(tableName);
  }

}
