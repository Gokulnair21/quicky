import 'dart:io';
import 'package:audio_recorder/audio_recorder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:note_app/bloc/reminder_bloc.dart';
import 'package:note_app/plugin/permission.dart';
import 'package:note_app/provider/theme_provider.dart';
import 'package:note_app/screen/paint/paint_notes.dart';
import 'package:note_app/screen/reminder/help_reminder.dart';
import 'package:note_app/screen/search_notes.dart';
import 'package:note_app/screen/settings_interface.dart';
import 'package:note_app/screen/splashscreen/splashscreen_no_data.dart';
import 'package:note_app/screen/text/text_notes.dart';
import 'package:note_app/screen/voice/voice_notes.dart';
import 'package:note_app/widget/custom_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note_app/bloc/document_all_values_bloc.dart';
import 'package:note_app/model/document_model.dart';
import 'package:note_app/screen/paint/paint_document_viewer.dart';
import 'package:provider/provider.dart';
import 'package:note_app/screen/reminder/all_reminder.dart';
import 'archieve_notes.dart';
import 'package:note_app/screen/text/create_new_document.dart';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';
import 'package:avatar_glow/avatar_glow.dart';

class ListOfNotes extends StatefulWidget {
  @override
  _ListOfNotesState createState() => _ListOfNotesState();
}

class _ListOfNotesState extends State<ListOfNotes> {
  final Color black = Colors.black;
  final Color white = Colors.white;

  bool selectAllTextNote;
  bool selectionOperation;

  List<Color> containerColor = [
    Colors.red,
    Colors.indigo,
    Colors.orange,
    Colors.blue,
    Colors.green,
    Colors.pink,
    Colors.cyan,
    Colors.purple,
    Colors.amber,
    Colors.lime,
    Colors.teal,
  ];
  List<int> selectedNoteId = [];
  List<int> selectAllNoteId = [];

  final _listOfAllNotesScaffold = GlobalKey<ScaffoldState>();

  Recording _recording = Recording();
  final titleController = TextEditingController();

  final _recordingFormKey = GlobalKey<FormState>();

  bool isRecording;

  IconData _recordingIcon;

  initValues() async {
    selectionOperation = false;
    selectAllTextNote = false;
    selectAllNoteId.clear();
    selectedNoteId.clear();
    _recordingIcon = Icons.keyboard_voice;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initValues();

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    documentBloc.dispose();
    reminderBloc.dispose();
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
    documentBloc.getImportantDocument();
    documentBloc.getDocument();
    final bloc = Provider.of<SettingsProvider>(context).bloc;

    // TODO: implement build
    return WillPopScope(
      onWillPop: _popBack,
      child: Scaffold(
          key: _listOfAllNotesScaffold,
          drawer: (!selectionOperation) ? customDrawer(context) : null,
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
                        StreamBuilder<List<Document>>(
                           // initialData: documentBloc.initialImportantDocuments,
                            stream: documentBloc.importantDocuments,
                            builder: (context, snapshot) {
                              if (snapshot == null) {
                                return SizedBox();
                              } else if (!snapshot.hasData ||
                                  snapshot.data.length == 0) {
                                return SizedBox();
                              } else if (snapshot.hasData) {
                                return Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        height: 30,
                                        child: Text(
                                          'Important notes',
                                          style: GoogleFonts.lato(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        height: 180,
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          physics: ScrollPhysics(),
                                          itemCount: snapshot.data.length,
                                          itemBuilder: (context, index) {
                                            Document docs =
                                                snapshot.data[index];
                                            if (docs.type == 1) {
                                              return Dismissible(
                                                  dismissThresholds: {
                                                    DismissDirection.up: 0.8,
                                                    DismissDirection.down: 0.8
                                                  },
                                                  direction:
                                                      DismissDirection.vertical,
                                                  key: ValueKey(docs.id),
                                                  onDismissed: (direction) =>
                                                      handleDismissImportant(
                                                          direction,
                                                          docs,
                                                          documentBloc),
                                                  background: Container(
                                                      padding: EdgeInsets.only(
                                                          top: 10),
                                                      alignment:
                                                          AlignmentDirectional
                                                              .topCenter,
                                                      child: Icon(
                                                        Icons.archive,
                                                      )),
                                                  secondaryBackground:
                                                      Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  bottom: 10),
                                                          alignment:
                                                              AlignmentDirectional
                                                                  .bottomCenter,
                                                          child: Icon(
                                                            Icons.bookmark,
                                                          )),
                                                  child: ImportantTextNote(
                                                    width: 150,
                                                    col: containerColor[
                                                        colorIndexVal(index)],
                                                    fontColor: white,
                                                    document: docs,
                                                  ));
                                            } else if (docs.type == 2) {
                                              return Dismissible(
                                                  dismissThresholds: {
                                                    DismissDirection.up: 0.8,
                                                    DismissDirection.down: 0.8
                                                  },
                                                  direction:
                                                      DismissDirection.vertical,
                                                  key: ValueKey(docs.id),
                                                  onDismissed: (direction) =>
                                                      handleDismissImportant(
                                                          direction,
                                                          docs,
                                                          documentBloc),
                                                  background: Container(
                                                      padding: EdgeInsets.only(
                                                          top: 10),
                                                      alignment:
                                                          AlignmentDirectional
                                                              .topCenter,
                                                      child: Icon(
                                                        Icons.archive,
                                                      )),
                                                  secondaryBackground:
                                                      Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  bottom: 10),
                                                          alignment:
                                                              AlignmentDirectional
                                                                  .bottomCenter,
                                                          child: Icon(
                                                            Icons.bookmark,
                                                          )),
                                                  child: ImportantVoiceNote(
                                                    width: 150,
                                                    col: containerColor[
                                                        colorIndexVal(index)],
                                                    fontColor: white,
                                                    document: docs,
                                                  ));
                                            }
                                            return Dismissible(
                                                dismissThresholds: {
                                                  DismissDirection.up: 0.8,
                                                  DismissDirection.down: 0.8
                                                },
                                                direction:
                                                    DismissDirection.vertical,
                                                key: ValueKey(docs.id),
                                                onDismissed: (direction) =>
                                                    handleDismissImportant(
                                                        direction,
                                                        docs,
                                                        documentBloc),
                                                background: Container(
                                                    padding: EdgeInsets.only(
                                                        top: 10),
                                                    alignment:
                                                        AlignmentDirectional
                                                            .topCenter,
                                                    child: Icon(
                                                      Icons.archive,
                                                    )),
                                                secondaryBackground: Container(
                                                    padding: EdgeInsets.only(
                                                        bottom: 10),
                                                    alignment:
                                                        AlignmentDirectional
                                                            .bottomCenter,
                                                    child: Icon(
                                                      Icons.bookmark,
                                                    )),
                                                child: ImportantPaintNote(
                                                  width: 150,
                                                  col: containerColor[
                                                      colorIndexVal(index)],
                                                  fontColor: white,
                                                  document: docs,
                                                ));
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        height: 30,
                                        child: Text(
                                          'All notes',
                                          style: GoogleFonts.lato(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              return CentreCircularProgressIndicator();
                            }),
                        SizedBox(
                          height: 20,
                        ),
                        StreamBuilder<List<Document>>(
                         // initialData: documentBloc.initialDocuments,
                          stream: documentBloc.document,
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Container(
                                alignment: Alignment.bottomCenter,
                                height: MediaQuery.of(context).size.height/2.5,
                                child:CentreCircularProgressIndicator() ,
                              );
                            }
                            if (snapshot.hasData) {
                              selectAllNoteId.clear();
                              if (snapshot.data.length == 0) {
                                return SplashScreenNoData(
                                  label:
                                      'Write , Draw or Record\nIt\'s your choice!',
                                );
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
                                    if (docs.type == 1) {
                                      return Dismissible(
                                        key: ValueKey(docs.id),
                                        onDismissed: (direction) =>
                                            handleDismiss(
                                                direction, docs, documentBloc),
                                        background: Container(
                                            padding: EdgeInsets.only(left: 20),
                                            alignment: AlignmentDirectional
                                                .centerStart,
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
                                                if (selectedNoteId.length ==
                                                    0) {
                                                  selectionOperation = false;
                                                  selectAllNoteId.clear();
                                                }
                                              }
                                            });
                                          },
                                          key: Key('list${docs.id.toString()}'),
                                        ),
                                      );
                                    } else if (docs.type == 2) {
                                      return Dismissible(
                                        key: ValueKey(docs.id),
                                        onDismissed: (direction) =>
                                            handleDismiss(
                                                direction, docs, documentBloc),
                                        background: Container(
                                            padding: EdgeInsets.only(left: 20),
                                            alignment: AlignmentDirectional
                                                .centerStart,
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
                                        child: AllVoiceNoteListTile(
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
                                                if (selectedNoteId.length ==
                                                    0) {
                                                  selectionOperation = false;
                                                  selectAllNoteId.clear();
                                                }
                                              }
                                            });
                                          },
                                          key: Key('list${docs.id.toString()}'),
                                        ),
                                      );
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
                                      child: AllPaintNoteListTile(
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
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    Document docs = snapshot.data[index];
                                    if (snapshot.data.length !=
                                        selectAllNoteId.length) {
                                      selectAllNoteId.add(docs.id);
                                    }
                                    if (docs.type == 1) {
                                      return Dismissible(
                                        key: ValueKey(docs.id),
                                        onDismissed: (direction) =>
                                            handleDismiss(
                                                direction, docs, documentBloc),
                                        background: Container(
                                            padding: EdgeInsets.only(left: 20),
                                            alignment: AlignmentDirectional
                                                .centerStart,
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
                                                if (selectedNoteId.length ==
                                                    0) {
                                                  selectionOperation = false;
                                                  selectAllNoteId.clear();
                                                }
                                              }
                                            });
                                          },
                                          key: Key('grid${docs.id.toString()}'),
                                        ),
                                      );
                                    } else if (docs.type == 2) {
                                      return Dismissible(
                                        key: ValueKey(docs.id),
                                        onDismissed: (direction) =>
                                            handleDismiss(
                                                direction, docs, documentBloc),
                                        background: Container(
                                            padding: EdgeInsets.only(left: 20),
                                            alignment: AlignmentDirectional
                                                .centerStart,
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
                                        child: AllVoiceNoteGridTile(
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
                                                if (selectedNoteId.length ==
                                                    0) {
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
                                      child: AllPaintNoteGridTile(
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
                                  },
                                );
                              }
                            }

                            return CentreCircularProgressIndicator();
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }),
          floatingActionButton: FloatingActionButton(
              tooltip: 'Add note',
              backgroundColor: Colors.red,
              child: Icon(
                Icons.create,
                color: white,
              ),
              onPressed: () => addNewValue(context)),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          bottomNavigationBar: bottomAppBar()),
    );
  }

  Widget bottomAppBar() {
    return BottomAppBar(
      elevation: 5,
      shape: CircularNotchedRectangle(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(
            width: 10,
          ),
          SizedBox(
              child: IconButton(
                  icon: Icon(
                    Icons.book,
                  ),
                  tooltip: 'Text notes',
                  onPressed: () => onTapBottomAppbar(0))),
          SizedBox(
              child: IconButton(
                  icon: Icon(
                    Icons.keyboard_voice,
                  ),
                  tooltip: 'Paint notes',
                  onPressed: () => onTapBottomAppbar(1))),
          SizedBox(
              child: IconButton(
                  icon: Icon(
                    Icons.image,
                  ),
                  tooltip: 'Voice notes',
                  onPressed: () => onTapBottomAppbar(2))),
          Expanded(
            child: SizedBox(),
          )
        ],
      ),
    );
  }

  void addNewValue(BuildContext context) {
    double size = 50;
    showModalBottomSheet<void>(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(size), topRight: Radius.circular(size))),
      context: context,
      builder: (context) => SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(left: 35, right: 35),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(size),
                    topRight: Radius.circular(size))),
            height: 350,
            width: double.infinity,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: size,
                  child: Center(
                    child: Text(
                      'Note type',
                      style: GoogleFonts.lato(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Container(
                    child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
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
                                            backgroundColor: (Theme.of(context)
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
                        },
                        child: AddNewValueCard(
                            height: 130,
                            width: double.infinity,
                            label: 'Text Note',
                            iconSize: 35,
                            icon: Icons.insert_drive_file))),
                SizedBox(
                  height: 8,
                ),
                Container(
                  //flex: 1,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                              startRecording(context);
                            },
                            child: AddNewValueCard(
                                height: 130,
                                width: double.infinity,
                                iconSize: 38,
                                label: 'Voice Note',
                                icon: Icons.keyboard_voice)),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PainterDocument(
                                            appBarTitle: 'New',
                                          )));
                            },
                            child: AddNewValueCard(
                                height: 130,
                                width: double.infinity,
                                iconSize: 35,
                                label: 'Draw Note',
                                icon: Icons.format_paint)),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget customDrawer(BuildContext context) {
    Color divider = Theme.of(context).dividerColor.withAlpha(30);
    // TODO: implement build
    return SafeArea(
      child: Drawer(
          child: ListView(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Container(
              margin: EdgeInsets.only(left: 5, right: 5),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.red, borderRadius: BorderRadius.circular(50)),
              height: 50,
              child: Text(
                'Quicky',
                style: GoogleFonts.lato(
                    fontSize: 25, color: white, fontWeight: FontWeight.w800),
              )),
          SizedBox(
            height: 20,
          ),
          Container(
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: divider))),
            child: ListTileOfDrawer(
              icon: Icons.notifications,
              label: 'Reminders',
              onTap: () {
                _listOfAllNotesScaffold.currentState.openEndDrawer();
                Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => AllReminders()));
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: divider))),
            child: ListTileOfDrawer(
              icon: Icons.archive,
              label: 'Archive',
              onTap: () {
                _listOfAllNotesScaffold.currentState.openEndDrawer();
                Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => ArchiveNotes()));
              },
            ),
          ),
          ListTileOfDrawer(
            icon: Icons.settings_applications,
            label: 'Settings',
            onTap: () {
              _listOfAllNotesScaffold.currentState.openEndDrawer();
              Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => SettingsUi()));
            },
          ),
          Container(
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: divider))),
            child: ListTileOfDrawer(
              icon: Icons.help_outline,
              label: 'Help',
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HelpReminderTips()));
              },
            ),
          ),
        ],
      )),
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
            icon: Icon(Icons.delete_outline),
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
        'My Notes',
        style: GoogleFonts.lato(
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: <Widget>[
        IconButton(
          tooltip: 'Search',
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SearchNotes()));
          },
          icon: Icon(Icons.search),
        ),
        // popUpMenuInAppbar()
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

  //Voice note creation

  void alertDialogBox() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return AlertDialog(
            title: Text(
              "Without permission you can't record your voice,Do you wanna give permission now?",
              style: GoogleFonts.lato(fontWeight: FontWeight.w500, fontSize: 15),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text('No',
                    style: GoogleFonts.lato(
                        fontWeight: FontWeight.w500,
                        color: Colors.red,
                        fontSize: 15)),
              ),
              FlatButton(
                onPressed: () {
                  PermissionService().requestMicrophoneStoragePermission(
                      onPermissionDenied: () {
                    Fluttertoast.showToast(msg: 'Permission denied!!!');
                  });
                  Navigator.pop(context);
                },
                child: Text(
                  'Yes',
                  style: GoogleFonts.lato(
                      fontWeight: FontWeight.w500,
                      color: Colors.red,
                      fontSize: 15),
                ),
              ),
            ],
          );
        });
  }

  void startRecording(BuildContext context) {
    titleController.clear();

    Document document = Document(
        title: '', images: '', noOfImages: 1, priority: 0, archive: 0, type: 2);

    isRecording = false;
    bool isImportant = false;
    bool isArchive = false;

    _recordingIcon = Icons.keyboard_voice;
    IconData _importantIcon = Icons.bookmark_border;
    IconData _archiveIcon = Icons.archive;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: StatefulBuilder(builder: (context, changeState) {
              return Form(
                key: _recordingFormKey,
                child: SingleChildScrollView(
                  child: Wrap(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: TextInputValidator(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          controller: titleController,
                          hintText: 'Title',
                          inputType: TextInputType.text,
                          color: Theme.of(context).iconTheme.color,
                          autoFocus: false,
                        ),
                      ),
                      Center(
                        child: Container(
                            height: 22,
                            child: (isRecording)
                                ? Text(
                                    'Recording...',
                                    style: GoogleFonts.lato(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                : Text(
                                    'Start Recording',
                                    style: GoogleFonts.lato(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )),
                      ),
                      Container(height: 20),
                      Center(
                        child: AvatarGlow(
                          glowColor: Colors.red,
                          endRadius: 90.0,
                          duration: Duration(milliseconds: 2000),
                          repeat: true,
                          showTwoGlows: true,
                          repeatPauseDuration: Duration(milliseconds: 100),
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                shape: BoxShape.circle),
                            child: FittedBox(
                                child: IconButton(
                                    icon: Icon(_recordingIcon),
                                    onPressed: () async {
                                      isRecording = !isRecording;
                                      if (isRecording) {
                                        _recordingIcon = Icons.stop;
                                        if (await PermissionService()
                                            .hasMicrophoneStoragePermission()) {
                                          _start();
                                        } else {
                                          changeState(() {
                                            isRecording = false;
                                            _recordingIcon = Icons.play_arrow;
                                          });
                                          alertDialogBox();
                                        }
                                      } else {
                                        _recordingIcon = Icons.keyboard_voice;
                                        _stop();
                                      }
                                      changeState(() {});
                                    })),
                          ),
                        ),
                      ),
                      Container(height: 20),
                      Container(
                        decoration: BoxDecoration(
                            // border:Border(top: BorderSide(color: Theme.of(context).dividerColor),bottom: BorderSide(color: Theme.of(context).dividerColor))
                            ),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: FlatButton(
                                  child: Icon(_importantIcon),
                                  onPressed: () {
                                    isImportant = !isImportant;
                                    if (isImportant) {
                                      document.priority = 1;
                                      _importantIcon = Icons.bookmark;
                                    } else {
                                      document.priority = 0;
                                      _importantIcon = Icons.bookmark_border;
                                    }
                                    changeState(() {});
                                  }),
                            ),
                            Expanded(
                              child: FlatButton(
                                  child: Icon(_archiveIcon),
                                  onPressed: () {
                                    isArchive = !isArchive;
                                    if (isArchive) {
                                      document.archive = 1;
                                      _archiveIcon = Icons.unarchive;
                                    } else {
                                      document.archive = 0;
                                      _archiveIcon = Icons.archive;
                                    }
                                    changeState(() {});
                                  }),
                            ),
                            Expanded(
                              child: FlatButton(
                                  child: Icon(Icons.clear_all),
                                  onPressed: () async {
                                    if (isRecording) {
                                      _stop();
                                    }
                                    titleController.clear();
                                    int r = await deleteFile(_recording.path);
                                    if (r == 0) {
                                      Fluttertoast.showToast(
                                          msg: 'Some error Occured');
                                    }
                                    Fluttertoast.showToast(msg: 'Deleted');
                                    changeState(() {});
                                  }),
                            ),
                          ],
                        ),
                      ),
                      Container(height: 20),
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        height: 40,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: SizedBox(),
                            ),
                            FlatButton(
                                onPressed: () => cancelRecording(),
                                child: Text(
                                  'Cancel',
                                  style: GoogleFonts.lato(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )),
                            SizedBox(
                              width: 10,
                            ),
                            RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              elevation: 5.0,
                              color: Colors.red,
                              onPressed: () => saveRecordingDocument(document),
                              child: Text(
                                'Save',
                                style: GoogleFonts.lato(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: 20,
                      )
                    ],
                  ),
                ),
              );
            })));
  }

  saveRecordingDocument(Document document) {
    if (_recordingFormKey.currentState.validate()) {
      if (_recording.path != null && !isRecording) {
        DateTime current = DateTime.now();
        if (current.hour > 12) {
          document.period = 'PM';
          document.hour = current.hour - 12;
        } else {
          document.period = 'AM';
          document.hour = current.hour;
        }
        document.minute = current.minute;
        document.day = current.day;
        document.month = current.month;
        document.year = current.year;
        document.title = titleController.text;
        document.images = _recording.path;
        documentBloc.add(document);
        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(msg: 'Please Stop recording before saving');
      }
    }
  }

  cancelRecording() async {
    titleController.clear();
    if (isRecording) {
      _stop();
    }
    int r = await deleteFile(_recording.path);
    print(r);
    Fluttertoast.showToast(msg: 'Discarded');
    Navigator.pop(context);
  }

  _start() async {
    String directoryName = 'Audio';
    String path;
    try {
      Directory directory = await getApplicationDocumentsDirectory();
      path = directory.path;
      await Directory('$path/$directoryName').create(recursive: true);
      path = path + '/AUD_' + DateTime.now().millisecondsSinceEpoch.toString();
      print("Start recording: $path");
      await AudioRecorder.start(
          path: path, audioOutputFormat: AudioOutputFormat.AAC);
      _recording = Recording(duration: Duration(), path: "");
    } catch (e) {
      print(e);
    }
  }

  _stop() async {
    var recording = await AudioRecorder.stop();
    _recording = recording;
  }

  Future<int> deleteFile(String path) async {
    try {
      final file =  io.File(path);
      await file.delete();
      return 1;
    } catch (e) {
      return 0;
    }
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
      debugPrint('start to end');
      documentBloc.delete(document.id);
    } else {
      action = 'Archive';
      documentBloc.archive(document);
      debugPrint('end to start');
    }
    _listOfAllNotesScaffold.currentState.showSnackBar(
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

  void handleDismissImportant(DismissDirection direction, Document document,
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
    if (direction == DismissDirection.up) {
      action = 'removed from important';
      documentBloc.important(document);
    } else {
      action = 'archived';
      documentBloc.archive(document);
    }
    _listOfAllNotesScaffold.currentState.showSnackBar(
      SnackBar(
        content: Text("Note $action"),
        duration: Duration(seconds: 1),
        action: SnackBarAction(
            label: "Undo",
            textColor: Colors.red,
            onPressed: () {
              if (action == 'archived') {
                documentBloc.archive(documentCopied);
              } else {
                documentBloc.important(documentCopied);
              }
            }),
      ),
    );
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

  void onTapBottomAppbar(int index) {
    switch (index) {
      case 0:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => TextNote()));
        break;
      case 1:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => VoiceNote()));

        break;
      case 2:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => PaintNote()));
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

  int colorIndexVal(int index) {
    return index % 10;
  }

  void cancel() {
    setState(() {
      selectAllTextNote = false;
      selectionOperation = false;
      selectedNoteId.clear();
    });
  }
}
