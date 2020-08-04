import 'dart:async';
import 'package:note_app/helperclass/document_database_helper_class.dart';
import 'package:note_app/model/document_model.dart';

class AllDocumentBloc {
  //Initialization Lists
  final List<Document> initialTextNote = [];

  final List<Document> initialPaintNote = [];

  final List<Document> initialVoiceNote = [];

  final List<Document> initialDocuments = [];

  final List<Document> initialTextArchiveDocuments = [];

  final List<Document> initialPaintArchiveDocuments = [];

  final List<Document> initialVoiceArchiveDocuments = [];

  final List<Document> initialImportantDocuments = [];

  initDocuments()async{
    initialDocuments.clear();
    initialDocuments.addAll(await DatabaseHelper.db.getAllDocuments());
  }

  initImportantDocuments()async{
    initialImportantDocuments.clear();
    initialImportantDocuments.addAll(await DatabaseHelper.db.getAllImportantDocuments());
  }

  initTextValues() async {
    initialTextNote.clear();
    initialTextNote.addAll(await DatabaseHelper.db.getTypeOfDocuments(1));
  }

  initVoiceValues() async {
    initialVoiceNote.clear();
    initialVoiceNote.addAll(await DatabaseHelper.db.getTypeOfDocuments(2));
  }

  initPaintValues() async {
    initialPaintNote.clear();
    initialPaintNote.addAll(await DatabaseHelper.db.getTypeOfDocuments(3));
  }

  initTextArchive()async{
    initialTextArchiveDocuments.clear();
    initialTextArchiveDocuments.addAll(await DatabaseHelper.db.getArchiveDocumentsOfType(1));
  }

  initVoiceArchive()async{
    initialVoiceArchiveDocuments.clear();
    initialVoiceArchiveDocuments.addAll(await DatabaseHelper.db.getArchiveDocumentsOfType(2));
  }

  initPaintArchive()async{
    initialPaintArchiveDocuments.clear();
    initialPaintArchiveDocuments.addAll(await DatabaseHelper.db.getArchiveDocumentsOfType(3));
  }


  AllDocumentBloc() {
    getDocument();
    getImportantDocument();
    getArchiveDocument();
    getPaintDocument();
    getTextDocument();
  }

  final _documentController = StreamController<List<Document>>.broadcast();

  get document => _documentController.stream;

  final _documentImportantController =
      StreamController<List<Document>>.broadcast();

  get importantDocuments => _documentImportantController.stream;

  final _documentSuggestedController =
      StreamController<List<Document>>.broadcast();

  get suggestedDocuments => _documentSuggestedController.stream;

//Types of documents
  final _documentTextController = StreamController<List<Document>>.broadcast();
  get textDocuments => _documentTextController.stream;

  final _documentPaintController = StreamController<List<Document>>.broadcast();
  get paintDocuments => _documentPaintController.stream;

  final _documentVoiceController = StreamController<List<Document>>.broadcast();
  get voiceDocuments => _documentVoiceController.stream;

  //Types of archive data
  final _documentTextArchiveController = StreamController<List<Document>>.broadcast();
  get textArchiveDocuments => _documentTextArchiveController.stream;

  final _documentPaintArchiveController = StreamController<List<Document>>.broadcast();
  get paintArchiveDocuments => _documentPaintArchiveController.stream;

  final _documentVoiceArchiveController = StreamController<List<Document>>.broadcast();
  get voiceArchiveDocuments => _documentVoiceArchiveController.stream;


  //getting values
  getDocument() async {
    _documentController.sink.add(await DatabaseHelper.db.getAllDocuments());
  }

  getImportantDocument() async {
    _documentImportantController.sink
        .add(await DatabaseHelper.db.getAllImportantDocuments());
  }

  getArchiveDocument(){
    getTextArchiveDocument();
    getVoiceArchiveDocument();
    getPaintArchiveDocument();
  }

  getTextArchiveDocument() async {
    _documentTextArchiveController.sink
        .add(await DatabaseHelper.db.getArchiveDocumentsOfType(1));
  }
  getVoiceArchiveDocument() async {
    _documentVoiceArchiveController.sink
        .add(await DatabaseHelper.db.getArchiveDocumentsOfType(2));
  }
  getPaintArchiveDocument() async {
    _documentPaintArchiveController.sink
        .add(await DatabaseHelper.db.getArchiveDocumentsOfType(3));
  }

  getTextDocument() async {
    _documentTextController.sink
        .add(await DatabaseHelper.db.getTypeOfDocuments(1));
  }

  getPaintDocument() async {
    _documentPaintController.sink
        .add(await DatabaseHelper.db.getTypeOfDocuments(3));
  }

  getVoiceDocument() async {
    _documentVoiceController.sink
        .add(await DatabaseHelper.db.getTypeOfDocuments(2));
  }

  getSuggestedDocument(String pattern) async {
    _documentSuggestedController.sink
        .add(await DatabaseHelper.db.suggestion(pattern));
  }

  add(Document document) async {
    await DatabaseHelper.db.insertADocument(document);
    getDocument();
    getImportantDocument();
    getArchiveDocument();
    getPaintDocument();
    getTextDocument();
  }

  delete(int id) async {
    await DatabaseHelper.db.deleteADocument(id);
    getDocument();
    getImportantDocument();
    getArchiveDocument();
    getPaintDocument();
    getTextDocument();
    getVoiceDocument();
  }

  update(Document document) async {
    await DatabaseHelper.db.updateADocument(document);
    getDocument();
    getImportantDocument();
    getArchiveDocument();
    getPaintDocument();
    getTextDocument();
    getVoiceDocument();

  }

  archive(Document document) async {
    await DatabaseHelper.db.archiveADocument(document);
    getDocument();
    getArchiveDocument();
    getImportantDocument();
    getPaintDocument();
    getTextDocument();
    getVoiceDocument();

  }

  important(Document document) async {
    await DatabaseHelper.db.importantADocument(document);
    getImportantDocument();
  }

  deleteAll() async {
    await DatabaseHelper.db.deleteAll();
    getDocument();
    getImportantDocument();
  }

  deleteASingleType(int type) async {
    await DatabaseHelper.db.deleteOnlySingleTypeOfDocument(type);
    getDocument();
    getArchiveDocument();
    getImportantDocument();
  }

  compulsoryImportant(int id) async {
    await DatabaseHelper.db.compulsoryImportant(id);
    getDocument();
    getImportantDocument();
  }

  compulsoryArchive(int id) async {
    await DatabaseHelper.db.compulsoryArchive(id);
    getDocument();
    getImportantDocument();
    getPaintDocument();
    getTextDocument();
    getVoiceDocument();

  }

  compulsoryUnArchive(int id)async{
    await DatabaseHelper.db.compulsoryUnArchive(id);
    getArchiveDocument();
  }

  createACopyOfDocument(int id) async {
    await DatabaseHelper.db.createACopyOfDocument(id);
    getDocument();
    getImportantDocument();
    getPaintDocument();
    getTextDocument();
  }


  dispose() {
    _documentController.close();
    _documentImportantController.close();
    _documentSuggestedController.close();
    _documentTextController.close();
    _documentPaintController.close();
    _documentVoiceController.close();
    _documentPaintArchiveController.close();
    _documentTextArchiveController.close();
    _documentVoiceArchiveController.close();
  }
}

final documentBloc = AllDocumentBloc();
