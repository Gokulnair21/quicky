import 'dart:io';
import 'package:note_app/model/document_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
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

  initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "Document.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE Document (id INTEGER PRIMARY KEY AUTOINCREMENT,title TEXT,description TEXT,images TEXT,noOfImages INTEGER,backgroundColor INTEGER,textColor INTEGER,descriptionFontStyle INTEGER,descriptionFontWeight INTEGER,descriptionTextAlignment INTEGER,descriptionFontSize REAL,descriptionTextDirection INTEGER,day INTEGER,month INTEGER,year INTEGER,hour INTEGER,minute INTEGER,period TEXT,priority INTEGER,archive INTEGER,type INTEGER)');
    });
  }
//Get all documents into stream
  getAllDocuments() async {
    final db = await database;
    var res = await db.rawQuery('SELECT * FROM Document WHERE archive=0 ORDER BY id DESC');
    List<Document> list =
        res.isNotEmpty ? res.map((c) => Document.fromMap(c)).toList() : [];
    return list;
  }

  getAllImportantDocuments() async {
    final db = await database;
    var res = await db
        .rawQuery('SELECT * FROM Document WHERE priority=1 AND archive=0 ORDER BY id DESC');
    List<Document> list =
    res.isNotEmpty ? res.map((c) => Document.fromMap(c)).toList() : [];
    return list;
  }

  getArchiveDocumentsOfType(int type) async {
    final db = await database;
    var res = await db.rawQuery('SELECT * FROM Document WHERE archive=1 AND type=$type ORDER BY id DESC');
    List<Document> list =
    res.isNotEmpty ? res.map((c) => Document.fromMap(c)).toList() : [];
    return list;
  }

  suggestion(String pattern)async{
    final db = await database;
    var res = await db.rawQuery('SELECT * FROM Document where title like ? group by id',
        ['%$pattern%']);
    List<Document> list = res.isNotEmpty ? res.map((c) => Document.fromMap(c)).toList() : [];
    return list;
  }

  getTypeOfDocuments(int type)async{
    final db = await database;
    var res = await db.rawQuery('SELECT * FROM Document WHERE archive=0  AND type=$type ORDER BY id DESC');
    List<Document> list =
    res.isNotEmpty ? res.map((c) => Document.fromMap(c)).toList() : [];
    return list;
  }

  getDocument(int id) async {
    final db = await database;
    var res = await db.query("Document", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Document.fromMap(res.first) : Null;
  }
//Operations on Document

  insertADocument(Document document) async {
    final db = await database;
    var res = await db.insert('Document', document.toMap());
    return res;
  }

  updateADocument(Document document)async{
    final db=await database;
   var res= await db.update('Document', document.toMap(),where: 'id=?',whereArgs: [document.id]);
   return res;
  }

  deleteADocument(int id)async{
    final db=await database;
    await db.delete('Document',where: 'id=?',whereArgs: [id]);
  }

  archiveADocument(Document document)async{
    final db=await database;
    if(document.archive==0){
      document.archive=1;
    }
    else{
      document.archive=0;
    }
    var res= await db.update('Document', document.toMap(),where: 'id=?',whereArgs: [document.id]);
    return res;
  }

  importantADocument(Document document)async{
    final db=await database;
    if(document.priority==0){
      document.priority=1;
    }
    else{
      document.priority=0;
    }
    var res= await db.update('Document', document.toMap(),where: 'id=?',whereArgs: [document.id]);
    return res;
  }

  compulsoryImportant(int id)async{
    final db=await database;
      var res= await db.rawQuery('UPDATE Document SET priority=1 WHERE id=$id');
      return res;
  }

  compulsoryArchive(int id)async{
    final db=await database;
    var res= await db.rawQuery('UPDATE Document SET archive=1 WHERE id=$id');
    return res;
  }

  compulsoryUnArchive(int id)async{
    final db=await database;
    var res= await db.rawQuery('UPDATE Document SET archive=0 WHERE id=$id');
    return res;
  }


  deleteAll()async{
    final db=await database;
    await db.delete('Document');
  }

  deleteOnlySingleTypeOfDocument(int type)async{
    final db=await database;
    await db.delete('Document',where: 'type=?',whereArgs: [type]);
  }

  createACopyOfDocument(int id)async{
    final db=await database;
    var res1 = await db.rawQuery('SELECT * FROM Document WHERE id=$id');
    List<Document> list = res1.isNotEmpty ? res1.map((c) => Document.fromMap(c)).toList() : [];
    Document document=list[0];
    document.id=null;
    DateTime current=DateTime.now();
    document.month=current.month;
    document.year=current.year;
    document.day=current.day;
    document.hour=(current.hour>12)?(current.hour-12):current.hour;
    document.minute=current.minute;
    document.period=(current.hour>=12 )?'PM':'AM';
    var res2 = await db.insert('Document', document.toMap());
    return res2;
  }

  //Length of all individual type of documents
  Future<int> getLengthOfDocuments(int type)async{
    final db = await database;
    var res = await db.rawQuery('SELECT * FROM Document WHERE archive=0 AND type=$type');
    List<Document> list =
    res.isNotEmpty ? res.map((c) => Document.fromMap(c)).toList() : [];
    return list.length;
  }


}
