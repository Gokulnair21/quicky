import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note_app/model/document_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:note_app/screen/paint/paint_detailed_view.dart';
import 'package:note_app/screen/voice/voice_document_viewer.dart';

import 'custom_divider.dart';

class ImportantVoiceNote extends StatelessWidget {
  final Color col;
  final Document document;
  final double width;
  final Color fontColor;

  ImportantVoiceNote({this.col, this.document, this.width, this.fontColor});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => VoiceNoteDocument(
                      appBarTitle: 'Edit',
                      document: document,
                    )));
      },
      child: Container(
        margin: EdgeInsets.only(right: 5),
        width: (width != null) ? width : double.infinity,
        child: Card(
            elevation: 1.0,
            color: col,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      left: 10,
                      right: 10,
                    ),
                    child: Text(
                      '${document.title}',
                      maxLines: 1,
                      style: GoogleFonts.lato(
                        color: fontColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  CustomDivider(
                    padding: 10,
                    col: Colors.white.withAlpha(50),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    height: 107,
                    child: Center(
                      child: Icon(
                        Icons.keyboard_voice,
                        color: fontColor,
                        size: 40,
                      ),
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }
}
