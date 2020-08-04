import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note_app/bloc/document_all_values_bloc.dart';
import 'package:note_app/model/document_model.dart';
import 'package:note_app/provider/theme_provider.dart';
import 'package:note_app/screen/splashscreen/splashscreen_no_data.dart';
import 'package:note_app/widget/all_text_note_grid_view.dart';
import 'package:note_app/widget/all_text_note_list_view.dart';
import 'package:provider/provider.dart';

import 'package:note_app/screen/text/create_new_document.dart';

class TextNote extends StatefulWidget {
  @override
  _TextNoteState createState() => _TextNoteState();
}

class _TextNoteState extends State<TextNote> {
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
    documentBloc.initTextValues();
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
    documentBloc.getTextDocument();

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
                        initialData: documentBloc.initialTextNote,
                        stream: documentBloc.textDocuments,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Text('No data');
                          }
                          if (snapshot.hasData) {
                            selectAllNoteId.clear();
                            if(snapshot.data.length==0){
                              return SplashScreenNoData(label: 'Write something new',);
                            }
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
                                          Icons.archive,
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
                                            Icons.archive,
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
            tooltip: 'Archive',
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
    return AppBar(
      elevation: 0.0,
      title: Text(
        'Text Notes',
        style: GoogleFonts.lato(
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: <Widget>[
        IconButton(icon: Icon(Icons.add), onPressed: (){
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CreateNewDocument(
                    appBarTitle: 'New',
                    document: Document(
                        title: '',
                        images: null,
                        noOfImages: 0,
                        description: '',
                        descriptionFontSize: 18,
                        descriptionFontWeight: 5,
                        descriptionFontStyle: 0,
                        type: 1,
                        descriptionTextAlignment: 0,
                        descriptionTextDirection: 0,
                        backgroundColor:
                        (Theme.of(context)
                            .primaryColor ==
                            Colors.black)
                            ? 8
                            : 0,
                        textColor: (Theme.of(context)
                            .primaryColor ==
                            Colors.black)
                            ? 0
                            : 8,
                        priority: 0,
                        archive: 0),
                  )));
        })
      ],
    );
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
      documentBloc.compulsoryArchive(selected[i]);
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
      action = 'Archive';
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
