import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note_app/model/document_model.dart';
import 'package:note_app/screen/text/create_new_document.dart';
import 'package:note_app/screen/paint/paint_detailed_view.dart';

import 'custom_divider.dart';

class AllPaintNoteGridTile extends StatefulWidget {
  final Key key;
  final Document document;
  final bool selectAllTextNote;
  final int index;
  final ValueChanged<bool> isSelected;
  final bool isEditingEnabled;

  AllPaintNoteGridTile(
      {this.document,
      this.selectAllTextNote,
      this.index,
      this.isSelected,
      this.key,
      this.isEditingEnabled});

  @override
  _AllTextNoteGridTileState createState() =>
      _AllTextNoteGridTileState(document: document, index: index);
}

class _AllTextNoteGridTileState extends State<AllPaintNoteGridTile> {
  final Document document;
  final int index;

  _AllTextNoteGridTileState({this.document, this.index});

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
                MaterialPageRoute(
                    builder: (context) => PainterDetailedDocument(
                          appBarTitle: 'View',
                          document: document,
                        )));
          }
        },
        child: Container(
          alignment: Alignment.bottomLeft,
          decoration: BoxDecoration(
              color: (primaryColor==Colors.black)?Theme.of(context).appBarTheme.color:primaryColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color:
                      (isSelected) ? secondaryColor : Colors.transparent,
                  width: 2)),
          margin: EdgeInsets.only(
            bottom: 0,
          ),
          width: double.infinity,
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                  ),
                  height: MediaQuery.of(context).size.height / 2,
                  child: Image.file(
                    File(document.images),
                    fit: BoxFit.fill,
                  ),
                ),
                CustomDivider(
                  padding: 20,
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  width: double.infinity,
                  child: Text(
                    '${document.title}',
                    maxLines: 1,
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.only(left: 20),
                  width: double.infinity,
                  child: Text(
                    '${document.day}\t${intToStringMonth(document.month)},${document.hour}:${document.minute}\t${document.period}',
                    maxLines: 1,
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.w300,
                      fontSize: 12,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                )
              ],
            ),
          ),
        ));
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
