import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note_app/bloc/document_all_values_bloc.dart';
import 'package:note_app/model/document_model.dart';
import 'package:note_app/provider/theme_provider.dart';
import 'package:note_app/widget/custom_widget.dart';
import 'package:provider/provider.dart';
import 'package:note_app/screen/splashscreen/splashscreen_no_data.dart';

class ArchiveNotes extends StatefulWidget {
  @override
  _ArchiveNotesState createState() => _ArchiveNotesState();
}

class _ArchiveNotesState extends State<ArchiveNotes>
    with SingleTickerProviderStateMixin {
  final Color white = Colors.white;
  final Color black = Colors.black;
  final Color whiteVariant = Color(0xfff8f8f8);

  TabController _tabController;

  GlobalKey<ScaffoldState> _archiveScaffold = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: _archiveScaffold,
      //drawer: CustomDrawer(keyVal: _archiveScaffold.toString(),),
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          'Archieve Notes',
          style: GoogleFonts.lato(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        bottom: TabBar(
          labelColor: Colors.red,
          tabs: [
            Tab(
                icon: Icon(
              Icons.insert_drive_file,
            )),
            Tab(
              icon: Icon(Icons.keyboard_voice),
            ),
            Tab(
              icon: Icon(Icons.image),
            ),
          ],
          controller: _tabController,
          indicatorColor: Colors.red,
          indicatorSize: TabBarIndicatorSize.tab,
        ),
        bottomOpacity: 1,
      ),
      body: TabBarView(
        children: [
          ArchiveTextNotes(),
          ArchiveVoiceNotes(),
          ArchivePaintNotes()
        ],
        controller: _tabController,
      ),
    );
  }
}

class ArchiveTextNotes extends StatefulWidget {
  @override
  _ArchiveTextNotesState createState() => _ArchiveTextNotesState();
}

class _ArchiveTextNotesState extends State<ArchiveTextNotes> {
  final Color black = Colors.black;
  final Color white = Colors.white;

  bool selectAllTextNote;
  bool selectionOperation;

  List<int> selectedNoteId = [];
  List<int> selectAllNoteId = [];

  final _textNotesScaffold = GlobalKey<ScaffoldState>();

  initValues() async {
    selectionOperation = false;
    selectAllTextNote = false;
    selectAllNoteId.clear();
    selectedNoteId.clear();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initValues();
    documentBloc.initTextArchive();
  }

  Future<bool> _popBack() async {
    if (selectionOperation) {
      setState(() {
        selectionOperation = false;
      });
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    documentBloc.getTextArchiveDocument();

    final bloc = Provider.of<SettingsProvider>(context).bloc;

    return WillPopScope(
      onWillPop: _popBack,
      child: Scaffold(
        key: _textNotesScaffold,
        appBar: getAppBar(),
        body: StreamBuilder(
            stream: bloc.viewType,
            builder: (context, snapshotBool) {
              if (snapshotBool.data == null) {
                return SizedBox();
              }
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      StreamBuilder<List<Document>>(
                        initialData: documentBloc.initialTextArchiveDocuments,
                        stream: documentBloc.textArchiveDocuments,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Text('No data');
                          }
                          if (snapshot.hasData) {
                            if(snapshot.data.length==0){
                              return SplashScreenNoData(label: 'No data',);
                            }
                            selectAllNoteId.clear();
                            if (snapshotBool.data) {
                              return ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                physics: ScrollPhysics(),
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) {
                                  Document docs = snapshot.data[index];
                                  if (snapshot.data.length !=
                                      selectAllNoteId.length) {
                                    selectAllNoteId.add(docs.id);
                                  }
                                  return Dismissible(
                                    key: ValueKey(docs.id),
                                    onDismissed: (direction) => handleDismiss(
                                        direction, docs, documentBloc),
                                    background: Container(
                                        padding: EdgeInsets.only(left: 20),
                                        alignment:
                                            AlignmentDirectional.centerStart,
                                        child: Icon(
                                          Icons.delete,
                                        )),
                                    secondaryBackground: Container(
                                        padding: EdgeInsets.only(right: 20),
                                        alignment:
                                            AlignmentDirectional.centerEnd,
                                        child: Icon(
                                          Icons.unarchive,
                                        )),
                                    child: AllTextNoteListTile(
                                      selectAllTextNote: selectAllTextNote,
                                      isEditingEnabled: selectionOperation,
                                      document: docs,
                                      index: index,
                                      isSelected: (bool value) {
                                        setState(() {
                                          if (value) {
                                            selectedNoteId.add(docs.id);
                                            selectionOperation = true;
                                          } else {
                                            selectedNoteId.remove(docs.id);
                                            if (selectAllTextNote) {
                                              selectAllTextNote = false;
                                            }
                                            if (selectedNoteId.length == 0) {
                                              selectionOperation = false;
                                              selectAllNoteId.clear();
                                            }
                                          }
                                        });
                                      },
                                      key: Key('list${docs.id.toString()}'),
                                    ),
                                  );
                                },
                              );
                            } else {
                              return StaggeredGridView.countBuilder(
                                shrinkWrap: true,
                                staggeredTileBuilder: (int index) =>
                                    StaggeredTile.fit(2),
                                mainAxisSpacing: 4.0,
                                crossAxisSpacing: 4.0,
                                physics: ScrollPhysics(),
                                crossAxisCount: 4,
                                itemCount: snapshot.data.length,
                                itemBuilder: (BuildContext context, int index) {
                                  Document docs = snapshot.data[index];
                                  if (snapshot.data.length !=
                                      selectAllNoteId.length) {
                                    selectAllNoteId.add(docs.id);
                                  }
                                  if (docs.type == 1) {
                                    return Dismissible(
                                      key: ValueKey(docs.id),
                                      onDismissed: (direction) => handleDismiss(
                                          direction, docs, documentBloc),
                                      background: Container(
                                          padding: EdgeInsets.only(left: 20),
                                          alignment:
                                              AlignmentDirectional.centerStart,
                                          child: Icon(
                                            Icons.delete,
                                          )),
                                      secondaryBackground: Container(
                                          padding: EdgeInsets.only(right: 20),
                                          alignment:
                                              AlignmentDirectional.centerEnd,
                                          child: Icon(
                                            Icons.unarchive,
                                          )),
                                      child: AllTextNoteGridTile(
                                        selectAllTextNote: selectAllTextNote,
                                        isEditingEnabled: selectionOperation,
                                        document: docs,
                                        index: index,
                                        isSelected: (bool value) {
                                          setState(() {
                                            if (value) {
                                              selectedNoteId.add(docs.id);
                                              selectionOperation = true;
                                            } else {
                                              selectedNoteId.remove(docs.id);
                                              if (selectAllTextNote) {
                                                selectAllTextNote = false;
                                              }
                                              if (selectedNoteId.length == 0) {
                                                selectionOperation = false;
                                                selectAllNoteId.clear();
                                              }
                                            }
                                          });
                                        },
                                        key: Key('grid${docs.id.toString()}'),
                                      ),
                                    );
                                  }
                                  return SizedBox();
                                },
                              );
                            }
                          }

                          return Text('Loading..');
                        },
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }

  void cancel() {
    setState(() {
      selectAllTextNote = false;
      selectionOperation = false;
      selectedNoteId.clear();
    });
  }

  Widget getAppBar() {
    if (selectionOperation) {
      return AppBar(
        leading: IconButton(icon: Icon(Icons.close), onPressed: () => cancel()),
        elevation: 0.0,
        title: Text(
          '${selectedNoteId.length}',
          style: GoogleFonts.lato(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: <Widget>[
          IconButton(
            tooltip: 'Delete',
            onPressed: () => delete(selectedNoteId),
            icon: Icon(Icons.delete),
          ),
          IconButton(
            tooltip: 'Unarchive',
            onPressed: () => addToArchive(selectedNoteId),
            icon: Icon(Icons.unarchive),
          ),
          IconButton(
            tooltip: 'Add to important',
            onPressed: () => addToImportant(selectedNoteId),
            icon: Icon(Icons.bookmark_border),
          ),
          popUpSelectMenuInAppbar()
        ],
      );
    }
    return null;
  }

  Widget popUpSelectMenuInAppbar() {
    return PopupMenuButton(
        tooltip: 'More',
        onSelected: (index) => popUpMenuFunction(index),
        itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Text(
                  'Select all',
                  style: GoogleFonts.lato(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              PopupMenuItem(
                value: 2,
                child: Text(
                  'Create a copy',
                  style: GoogleFonts.lato(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              PopupMenuItem(
                value: 3,
                child: Text(
                  'Cancel',
                  style: GoogleFonts.lato(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ]);
  }

  popUpMenuFunction(index) {
    switch (index) {
      case 1:
        selectAll();
        break;
      case 2:
        createACopy(selectedNoteId);
        break;
      case 3:
        cancel();
        break;
    }
  }

  void addToImportant(List<int> selected) {
    for (int i = 0; i < selected.length; i++) {
      documentBloc.compulsoryImportant(selected[i]);
    }
    setState(() {
      selectedNoteId.clear();
      selectionOperation = false;
      selectAllTextNote = false;
    });
  }

  void createACopy(List<int> selected) {
    for (int i = 0; i < selected.length; i++) {
      documentBloc.createACopyOfDocument(selected[i]);
    }
    setState(() {
      selectedNoteId.clear();
      selectionOperation = false;
      selectAllTextNote = false;
    });
  }

  void addToArchive(List<int> selected) {
    for (int i = 0; i < selected.length; i++) {
      documentBloc.compulsoryUnArchive(selected[i]);
    }
    setState(() {
      selectedNoteId.clear();
      selectionOperation = false;
      selectAllTextNote = false;
    });
  }

  void delete(List<int> ids) {
    for (int i = 0; i < ids.length; i++) {
      documentBloc.delete(ids[i]);
    }
    setState(() {
      selectedNoteId.clear();
      selectionOperation = false;
      selectAllTextNote = false;
    });
  }

  void selectAll() {
    setState(() {
      selectedNoteId.clear();
      selectAllTextNote = true;
      selectedNoteId.addAll(selectAllNoteId);
    });
  }

  void handleDismiss(DismissDirection direction, Document document,
      AllDocumentBloc documentBloc) {
    String action;
    final documentCopied = document;
    if (selectionOperation) {
      setState(() {
        selectAllTextNote = false;
        selectedNoteId.clear();
        selectionOperation = !selectionOperation;
      });
    }
    if (direction == DismissDirection.startToEnd ||
        direction == DismissDirection.up) {
      action = 'Delete';
      documentBloc.delete(document.id);
    } else {
      action = 'Unarchive';
      documentBloc.archive(document);
    }
    _textNotesScaffold.currentState.showSnackBar(
      SnackBar(
        content: Text("Note $action\d"),
        duration: Duration(seconds: 1),
        action: SnackBarAction(
            label: "Undo",
            textColor: Colors.red,
            onPressed: () {
              if (action == 'Delete') {
                documentBloc.add(documentCopied);
              } else {
                documentBloc.archive(documentCopied);
              }
            }),
      ),
    );
  }
}

class ArchivePaintNotes extends StatefulWidget {
  @override
  _ArchivePaintNotesState createState() => _ArchivePaintNotesState();
}

class _ArchivePaintNotesState extends State<ArchivePaintNotes> {
  final Color black = Colors.black;
  final Color white = Colors.white;

  bool selectAllPaintNote;
  bool selectionOperation;

  List<int> selectedNoteId = [];
  List<int> selectAllNoteId = [];

  final _paintNotesScaffold = GlobalKey<ScaffoldState>();

  initValues() async {
    selectionOperation = false;
    selectAllPaintNote = false;
    selectAllNoteId.clear();
    selectedNoteId.clear();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initValues();
    documentBloc.initPaintArchive();
  }

  Future<bool> _popBack() async {
    if (selectionOperation) {
      setState(() {
        selectionOperation = false;
      });
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    documentBloc.getPaintArchiveDocument();

    final bloc = Provider.of<SettingsProvider>(context).bloc;
    //final docsBloc = Provider.of<DocumentProvider>(context).documentBloc;

    return WillPopScope(
      onWillPop: _popBack,
      child: Scaffold(
        key: _paintNotesScaffold,
        appBar: getAppBar(),
        body: StreamBuilder(
            stream: bloc.viewType,
            builder: (context, snapshotBool) {
              if (snapshotBool.data == null) {
                return SizedBox();
              }
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      StreamBuilder<List<Document>>(
                        initialData: documentBloc.initialPaintArchiveDocuments,
                        stream: documentBloc.paintArchiveDocuments,
                        builder: (context, snapshot) {
                          //if(snapshot.connectionState==ConnectionState.active) {
                          if (!snapshot.hasData) {
                            return Text('No data');
                          }
                          if (snapshot.hasData) {
                            if(snapshot.data.length==0){
                              return SplashScreenNoData(label: 'No data',);
                            }
                            selectAllNoteId.clear();
                            if (snapshotBool.data) {
                              return ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                physics: ScrollPhysics(),
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) {
                                  Document docs = snapshot.data[index];
                                  if (snapshot.data.length !=
                                      selectAllNoteId.length) {
                                    selectAllNoteId.add(docs.id);
                                  }
                                  return Dismissible(
                                    key: ValueKey(docs.id),
                                    onDismissed: (direction) => handleDismiss(
                                        direction, docs, documentBloc),
                                    background: Container(
                                        padding: EdgeInsets.only(left: 20),
                                        alignment:
                                            AlignmentDirectional.centerStart,
                                        child: Icon(
                                          Icons.delete,
                                        )),
                                    secondaryBackground: Container(
                                        padding: EdgeInsets.only(right: 20),
                                        alignment:
                                            AlignmentDirectional.centerEnd,
                                        child: Icon(
                                          Icons.unarchive,
                                        )),
                                    child: AllPaintNoteListTile(
                                      selectAllTextNote: selectAllPaintNote,
                                      isEditingEnabled: selectionOperation,
                                      document: docs,
                                      index: index,
                                      isSelected: (bool value) {
                                        setState(() {
                                          if (value) {
                                            selectedNoteId.add(docs.id);
                                            selectionOperation = true;
                                          } else {
                                            selectedNoteId.remove(docs.id);
                                            if (selectAllPaintNote) {
                                              selectAllPaintNote = false;
                                            }
                                            if (selectedNoteId.length == 0) {
                                              selectionOperation = false;
                                              selectAllNoteId.clear();
                                            }
                                          }
                                        });
                                      },
                                      key: Key('list${docs.id.toString()}'),
                                    ),
                                  );
                                },
                              );
                            } else {
                              return StaggeredGridView.countBuilder(
                                shrinkWrap: true,
                                staggeredTileBuilder: (int index) =>
                                    StaggeredTile.fit(2),
                                mainAxisSpacing: 4.0,
                                crossAxisSpacing: 4.0,
                                physics: ScrollPhysics(),
                                crossAxisCount: 4,
                                itemCount: snapshot.data.length,
                                itemBuilder: (BuildContext context, int index) {
                                  Document docs = snapshot.data[index];
                                  if (snapshot.data.length !=
                                      selectAllNoteId.length) {
                                    selectAllNoteId.add(docs.id);
                                  }
                                  return Dismissible(
                                    key: ValueKey(docs.id),
                                    onDismissed: (direction) => handleDismiss(
                                        direction, docs, documentBloc),
                                    background: Container(
                                        padding: EdgeInsets.only(left: 20),
                                        alignment:
                                            AlignmentDirectional.centerStart,
                                        child: Icon(
                                          Icons.delete,
                                        )),
                                    secondaryBackground: Container(
                                        padding: EdgeInsets.only(right: 20),
                                        alignment:
                                            AlignmentDirectional.centerEnd,
                                        child: Icon(
                                          Icons.unarchive,
                                        )),
                                    child: AllPaintNoteGridTile(
                                      selectAllTextNote: selectAllPaintNote,
                                      isEditingEnabled: selectionOperation,
                                      document: docs,
                                      index: index,
                                      isSelected: (bool value) {
                                        setState(() {
                                          if (value) {
                                            selectedNoteId.add(docs.id);
                                            selectionOperation = true;
                                          } else {
                                            selectedNoteId.remove(docs.id);
                                            if (selectAllPaintNote) {
                                              selectAllPaintNote = false;
                                            }
                                            if (selectedNoteId.length == 0) {
                                              selectionOperation = false;
                                              selectAllNoteId.clear();
                                            }
                                          }
                                        });
                                      },
                                      key: Key('grid${docs.id.toString()}'),
                                    ),
                                  );
                                },
                              );
                            }
                          }
                          //}
                          return CentreCircularProgressIndicator();
                        },
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }

  void cancel() {
    setState(() {
      selectAllPaintNote = false;
      selectionOperation = false;
      selectedNoteId.clear();
    });
  }

  Widget getAppBar() {
    if (selectionOperation) {
      return AppBar(
        leading: IconButton(icon: Icon(Icons.close), onPressed: () => cancel()),
        elevation: 0.0,
        title: Text(
          '${selectedNoteId.length}',
          style: GoogleFonts.lato(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: <Widget>[
          IconButton(
            tooltip: 'Delete',
            onPressed: () => delete(selectedNoteId),
            icon: Icon(Icons.delete),
          ),
          IconButton(
            tooltip: 'Unarchive',
            onPressed: () => addToArchive(selectedNoteId),
            icon: Icon(Icons.archive),
          ),
          IconButton(
            tooltip: 'Add to important',
            onPressed: () => addToImportant(selectedNoteId),
            icon: Icon(Icons.bookmark_border),
          ),
          popUpSelectMenuInAppbar()
        ],
      );
    }
    return null;
  }

  Widget popUpSelectMenuInAppbar() {
    return PopupMenuButton(
        tooltip: 'More',
        onSelected: (index) => popUpMenuFunction(index),
        itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Text(
                  'Select all',
                  style: GoogleFonts.lato(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              PopupMenuItem(
                value: 2,
                child: Text(
                  'Create a copy',
                  style: GoogleFonts.lato(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              PopupMenuItem(
                value: 3,
                child: Text(
                  'Cancel',
                  style: GoogleFonts.lato(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ]);
  }

  popUpMenuFunction(index) {
    switch (index) {
      case 1:
        selectAll();
        break;
      case 2:
        createACopy(selectedNoteId);
        break;
      case 3:
        cancel();
        break;
    }
  }

  void addToImportant(List<int> selected) {
    for (int i = 0; i < selected.length; i++) {
      documentBloc.compulsoryImportant(selected[i]);
    }
    setState(() {
      selectedNoteId.clear();
      selectionOperation = false;
      selectAllPaintNote = false;
    });
  }

  void createACopy(List<int> selected) {
    for (int i = 0; i < selected.length; i++) {
      documentBloc.createACopyOfDocument(selected[i]);
    }
    setState(() {
      selectedNoteId.clear();
      selectionOperation = false;
      selectAllPaintNote = false;
    });
  }

  void addToArchive(List<int> selected) {
    for (int i = 0; i < selected.length; i++) {
      documentBloc.compulsoryUnArchive(selected[i]);
    }
    setState(() {
      selectedNoteId.clear();
      selectionOperation = false;
      selectAllPaintNote = false;
    });
  }

  void delete(List<int> ids) {
    for (int i = 0; i < ids.length; i++) {
      documentBloc.delete(ids[i]);
    }
    setState(() {
      selectedNoteId.clear();
      selectionOperation = false;
      selectAllPaintNote = false;
    });
  }

  void selectAll() {
    setState(() {
      selectedNoteId.clear();
      selectAllPaintNote = true;
      selectedNoteId.addAll(selectAllNoteId);
    });
  }

  void handleDismiss(DismissDirection direction, Document document,
      AllDocumentBloc documentBloc) {
    String action;
    final documentCopied = document;
    if (selectionOperation) {
      setState(() {
        selectAllPaintNote = false;
        selectedNoteId.clear();
        selectionOperation = !selectionOperation;
      });
    }
    if (direction == DismissDirection.startToEnd ||
        direction == DismissDirection.up) {
      action = 'Delete';
      documentBloc.delete(document.id);
    } else {
      action = 'Unarchive';
      documentBloc.archive(document);
    }
    _paintNotesScaffold.currentState.showSnackBar(
      SnackBar(
        content: Text("Note $action\d"),
        duration: Duration(seconds: 1),
        action: SnackBarAction(
            label: "Undo",
            textColor: Colors.red,
            onPressed: () {
              if (action == 'Delete') {
                documentBloc.add(documentCopied);
              } else {
                documentBloc.archive(documentCopied);
              }
            }),
      ),
    );
  }
}

class ArchiveVoiceNotes extends StatefulWidget {
  @override
  _ArchiveVoiceNotesState createState() => _ArchiveVoiceNotesState();
}

class _ArchiveVoiceNotesState extends State<ArchiveVoiceNotes> {
  final Color black = Colors.black;
  final Color white = Colors.white;

  bool selectAllVoiceNote;
  bool selectionOperation;

  List<int> selectedNoteId = [];
  List<int> selectAllNoteId = [];

  final _voiceNotesScaffold = GlobalKey<ScaffoldState>();

  initValues() async {
    selectionOperation = false;
    selectAllVoiceNote = false;
    selectAllNoteId.clear();
    selectedNoteId.clear();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initValues();
    documentBloc.initVoiceArchive();
  }

  Future<bool> _popBack() async {
    if (selectionOperation) {
      setState(() {
        selectionOperation = false;
      });
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    documentBloc.getVoiceArchiveDocument();

    final bloc = Provider.of<SettingsProvider>(context).bloc;

    return WillPopScope(
      onWillPop: _popBack,
      child: Scaffold(
        key: _voiceNotesScaffold,
        appBar: getAppBar(),
        body: StreamBuilder(
            stream: bloc.viewType,
            builder: (context, snapshotBool) {
              if (snapshotBool.data == null) {
                return SizedBox();
              }
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      StreamBuilder<List<Document>>(
                        initialData: documentBloc.initialVoiceArchiveDocuments,
                        stream: documentBloc.voiceArchiveDocuments,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Text('No data');
                          }
                          if (snapshot.hasData) {
                            if(snapshot.data.length==0){
                              return SplashScreenNoData(label: 'No data',);
                            }
                            selectAllNoteId.clear();
                            if (snapshotBool.data) {
                              return ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                physics: ScrollPhysics(),
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) {
                                  Document docs = snapshot.data[index];
                                  if (snapshot.data.length !=
                                      selectAllNoteId.length) {
                                    selectAllNoteId.add(docs.id);
                                  }
                                  return Dismissible(
                                    key: ValueKey(docs.id),
                                    onDismissed: (direction) => handleDismiss(
                                        direction, docs, documentBloc),
                                    background: Container(
                                        padding: EdgeInsets.only(left: 20),
                                        alignment:
                                            AlignmentDirectional.centerStart,
                                        child: Icon(
                                          Icons.delete,
                                        )),
                                    secondaryBackground: Container(
                                        padding: EdgeInsets.only(right: 20),
                                        alignment:
                                            AlignmentDirectional.centerEnd,
                                        child: Icon(
                                          Icons.unarchive,
                                        )),
                                    child: AllVoiceNoteListTile(
                                      selectAllTextNote: selectAllVoiceNote,
                                      isEditingEnabled: selectionOperation,
                                      document: docs,
                                      index: index,
                                      isSelected: (bool value) {
                                        setState(() {
                                          if (value) {
                                            selectedNoteId.add(docs.id);
                                            selectionOperation = true;
                                          } else {
                                            selectedNoteId.remove(docs.id);
                                            if (selectAllVoiceNote) {
                                              selectAllVoiceNote = false;
                                            }
                                            if (selectedNoteId.length == 0) {
                                              selectionOperation = false;
                                              selectAllNoteId.clear();
                                            }
                                          }
                                        });
                                      },
                                      key: Key('list${docs.id.toString()}'),
                                    ),
                                  );
                                },
                              );
                            } else {
                              return StaggeredGridView.countBuilder(
                                shrinkWrap: true,
                                staggeredTileBuilder: (int index) =>
                                    StaggeredTile.fit(2),
                                mainAxisSpacing: 4.0,
                                crossAxisSpacing: 4.0,
                                physics: ScrollPhysics(),
                                crossAxisCount: 4,
                                itemCount: snapshot.data.length,
                                itemBuilder: (BuildContext context, int index) {
                                  Document docs = snapshot.data[index];
                                  if (snapshot.data.length !=
                                      selectAllNoteId.length) {
                                    selectAllNoteId.add(docs.id);
                                  }
                                  if (docs.type == 2) {
                                    return Dismissible(
                                      key: ValueKey(docs.id),
                                      onDismissed: (direction) => handleDismiss(
                                          direction, docs, documentBloc),
                                      background: Container(
                                          padding: EdgeInsets.only(left: 20),
                                          alignment:
                                              AlignmentDirectional.centerStart,
                                          child: Icon(
                                            Icons.delete,
                                          )),
                                      secondaryBackground: Container(
                                          padding: EdgeInsets.only(right: 20),
                                          alignment:
                                              AlignmentDirectional.centerEnd,
                                          child: Icon(
                                            Icons.unarchive,
                                          )),
                                      child: AllVoiceNoteGridTile(
                                        selectAllTextNote: selectAllVoiceNote,
                                        isEditingEnabled: selectionOperation,
                                        document: docs,
                                        index: index,
                                        isSelected: (bool value) {
                                          setState(() {
                                            if (value) {
                                              selectedNoteId.add(docs.id);
                                              selectionOperation = true;
                                            } else {
                                              selectedNoteId.remove(docs.id);
                                              if (selectAllVoiceNote) {
                                                selectAllVoiceNote = false;
                                              }
                                              if (selectedNoteId.length == 0) {
                                                selectionOperation = false;
                                                selectAllNoteId.clear();
                                              }
                                            }
                                          });
                                        },
                                        key: Key('grid${docs.id.toString()}'),
                                      ),
                                    );
                                  }
                                  return SizedBox();
                                },
                              );
                            }
                          }

                          return Text('Loading..');
                        },
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }

  Widget getAppBar() {
    if (selectionOperation) {
      return AppBar(
        leading: IconButton(icon: Icon(Icons.close), onPressed: () => cancel()),
        elevation: 0.0,
        title: Text(
          '${selectedNoteId.length}',
          style: GoogleFonts.lato(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: <Widget>[
          IconButton(
            tooltip: 'Delete',
            onPressed: () => delete(selectedNoteId),
            icon: Icon(Icons.delete),
          ),
          IconButton(
            tooltip: 'Unarchive',
            onPressed: () => addToArchive(selectedNoteId),
            icon: Icon(Icons.unarchive),
          ),
          IconButton(
            tooltip: 'Add to important',
            onPressed: () => addToImportant(selectedNoteId),
            icon: Icon(Icons.bookmark_border),
          ),
          popUpSelectMenuInAppbar()
        ],
      );
    }
    return null;
  }

  Widget popUpSelectMenuInAppbar() {
    return PopupMenuButton(
        tooltip: 'More',
        onSelected: (index) => popUpMenuFunction(index),
        itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Text(
                  'Select all',
                  style: GoogleFonts.lato(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              PopupMenuItem(
                value: 2,
                child: Text(
                  'Create a copy',
                  style: GoogleFonts.lato(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              PopupMenuItem(
                value: 3,
                child: Text(
                  'Cancel',
                  style: GoogleFonts.lato(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ]);
  }

  void cancel() {
    setState(() {
      selectAllVoiceNote = false;
      selectionOperation = false;
      selectedNoteId.clear();
    });
  }

  popUpMenuFunction(index) {
    switch (index) {
      case 1:
        selectAll();
        break;
      case 2:
        createACopy(selectedNoteId);
        break;
      case 3:
        cancel();
        break;
    }
  }

  void addToImportant(List<int> selected) {
    for (int i = 0; i < selected.length; i++) {
      documentBloc.compulsoryImportant(selected[i]);
    }
    setState(() {
      selectedNoteId.clear();
      selectionOperation = false;
      selectAllVoiceNote = false;
    });
  }

  void createACopy(List<int> selected) {
    for (int i = 0; i < selected.length; i++) {
      documentBloc.createACopyOfDocument(selected[i]);
    }
    setState(() {
      selectedNoteId.clear();
      selectionOperation = false;
      selectAllVoiceNote = false;
    });
  }

  void addToArchive(List<int> selected) {
    for (int i = 0; i < selected.length; i++) {
      documentBloc.compulsoryUnArchive(selected[i]);
    }
    setState(() {
      selectedNoteId.clear();
      selectionOperation = false;
      selectAllVoiceNote = false;
    });
  }

  void delete(List<int> ids) {
    for (int i = 0; i < ids.length; i++) {
      documentBloc.delete(ids[i]);
    }
    setState(() {
      selectedNoteId.clear();
      selectionOperation = false;
      selectAllVoiceNote = false;
    });
  }

  void selectAll() {
    setState(() {
      selectedNoteId.clear();
      selectAllVoiceNote = true;
      selectedNoteId.addAll(selectAllNoteId);
    });
  }

  void handleDismiss(DismissDirection direction, Document document,
      AllDocumentBloc documentBloc) {
    String action;
    final documentCopied = document;
    if (selectionOperation) {
      setState(() {
        selectAllVoiceNote = false;
        selectedNoteId.clear();
        selectionOperation = !selectionOperation;
      });
    }
    if (direction == DismissDirection.startToEnd ||
        direction == DismissDirection.up) {
      action = 'Delete';
      documentBloc.delete(document.id);
    } else {
      action = 'Unarchive';
      documentBloc.archive(document);
    }
    _voiceNotesScaffold.currentState.showSnackBar(
      SnackBar(
        content: Text("Note $action\d"),
        duration: Duration(seconds: 1),
        action: SnackBarAction(
            label: "Undo",
            textColor: Colors.red,
            onPressed: () {
              if (action == 'Delete') {
                documentBloc.add(documentCopied);
              } else {
                documentBloc.archive(documentCopied);
              }
            }),
      ),
    );
  }
}
