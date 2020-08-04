import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note_app/model/document_model.dart';
import 'package:note_app/screen/paint/paint_detailed_view.dart';
import 'package:note_app/screen/voice/voice_document_viewer.dart';

class AllVoiceNoteListTile extends StatefulWidget {
  final Key key;
  final Document document;
  final bool selectAllTextNote;
  final int index;
  final ValueChanged<bool> isSelected;
  final bool isEditingEnabled;

  AllVoiceNoteListTile(
      {this.document,
      this.selectAllTextNote,
      this.index,
      this.isSelected,
      this.key,
      this.isEditingEnabled});

  @override
  _AllTextNoteListTileState createState() =>
      _AllTextNoteListTileState(document: document, index: index);
}

class _AllTextNoteListTileState extends State<AllVoiceNoteListTile> {
  final Document document;
  final int index;

  _AllTextNoteListTileState({this.document, this.index});

  final Color white = Colors.white;
  final Color black = Colors.black;

  bool isSelected = false;

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

  void checker() {
    if (widget.selectAllTextNote) {
      isSelected = true;
    }
    if (!widget.isEditingEnabled) {
      isSelected = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    checker();

    Color primaryColor = Theme.of(context).primaryColor;
    Color secondaryColor = Theme.of(context).iconTheme.color;

    // TODO: implement build
    return GestureDetector(
      onLongPress: () {
        isSelected = !isSelected;
        widget.isSelected(isSelected);
        setState(() {});
      },
      onTap: () {
        if (widget.isEditingEnabled) {
          isSelected = !isSelected;
          widget.isSelected(isSelected);
          setState(() {});
        } else {
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) => VoiceNoteDocument(
                        appBarTitle: 'Edit',
                        document: document,
                      )));
        }
      },
      child: Container(
          alignment: Alignment.bottomLeft,
          decoration: BoxDecoration(
              color: (primaryColor == Colors.black)
                  ? Theme.of(context).appBarTheme.color
                  : primaryColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: (isSelected) ? secondaryColor : Colors.transparent,
                  width: 2)),
          margin: EdgeInsets.only(
            bottom: 15,
          ),
          width: double.infinity,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Text(
                        document.title,
                        maxLines: 2,
                        style: GoogleFonts.lato(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.infinity,
                      height: 20,
                      padding: EdgeInsets.only(left: 20),
                      child: SizedBox(
                        child: Text(
                          '${document.day}\t${intToStringMonth(document.month)},${document.hour}:${document.minute}\t${document.period}',
                          maxLines: 1,
                          style: GoogleFonts.lato(
                            fontWeight: FontWeight.w300,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    )
                  ],
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: Icon(Icons.keyboard_voice),
              ),
              SizedBox(
                width: 20,
              )
            ],
          )),
    );
  }

  String intToStringMonth(int index) {
    switch (index) {
      case 1:
        return 'Jan';
        break;
      case 2:
        return 'Feb';
        break;
      case 3:
        return 'Mar';
        break;
      case 4:
        return 'Apr';
        break;
      case 5:
        return 'May';
        break;
      case 6:
        return 'Jun';
        break;
      case 7:
        return 'Jul';
        break;
      case 8:
        return 'Aug';
        break;
      case 9:
        return 'Sep';
        break;
      case 10:
        return 'Oct';
        break;
      case 11:
        return 'Nov';
        break;
      case 12:
        return 'Dec';
        break;
    }
    return '';
  }
}
