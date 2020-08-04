import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note_app/model/document_model.dart';
import 'package:note_app/screen/text/create_new_document.dart';

import 'custom_divider.dart';

class AllTextNoteGridTile extends StatefulWidget {
  final Key key;
  final Document document;
  final bool selectAllTextNote;
  final int index;
  final ValueChanged<bool> isSelected;
  final bool isEditingEnabled;

  AllTextNoteGridTile(
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

class _AllTextNoteGridTileState extends State<AllTextNoteGridTile> {
  final Document document;
  final int index;

  _AllTextNoteGridTileState({this.document, this.index});



  bool isSelected = false;

  List<Color> containerColor = [
    Colors.white,
    Colors.red,
    Colors.yellow,
    Colors.orange,
    Colors.blue,
    Colors.green,
    Colors.indigo,
    Colors.pink,
    Colors.black,
    Colors.deepOrangeAccent,
    Colors.cyan,
    Colors.grey,
    Colors.purpleAccent,
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
    Color primaryColor=Theme.of(context).primaryColor;
    Color secondaryColor=Theme.of(context).iconTheme.color;

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
                    builder: (context) => CreateNewDocument(
                          appBarTitle: 'Edit',
                          document: document,
                        )));
          }
        },
        child: Container(
          //height: 241,
          decoration: BoxDecoration(
            color:(primaryColor==Colors.black)?Theme.of(context).appBarTheme.color:primaryColor,
              borderRadius: BorderRadius.circular(20),
              border:
                  Border.all(color: (isSelected) ? secondaryColor : Colors.transparent, width: 2)),
          margin: EdgeInsets.only(
            bottom: 0,
          ),
          width: double.infinity,
          child: Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Wrap(
              children: <Widget>[
                Container(
                  height: 10,
                ),
                Container(
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
                  height: 5,
                ),
                Container(
                  height: 15,
                  child: Row(
                    children: <Widget>[
                      Expanded(
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
                        child: CircleAvatar(
                            backgroundColor: containerColor[document.backgroundColor],
                            minRadius: 15,
                            maxRadius: 15,
                            child: Center(
                              child: Text(
                                'T',
                                style: GoogleFonts.lato(
                                    color: containerColor[document.textColor],
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12),
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 5,
                ),
                CustomDivider(
              padding: 0,
                ),
                Container(
                  height: 10,
                ),
                SizedBox(
                  child: Text(
                    '${document.description}',
                    maxLines: 10,
                    style: GoogleFonts.lato(
                        fontWeight: FontWeight.w300,
                        fontSize: 14,
                        ),
                  ),
                ),
                Container(
                  height: 10,
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
