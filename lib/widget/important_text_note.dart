
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note_app/model/document_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:note_app/screen/text/create_new_document.dart';

import 'custom_divider.dart';
class ImportantTextNote extends StatelessWidget{

  final Color col;
  final Document document;
  final double width;
  final Color fontColor;

  ImportantTextNote({this.col,this.document,this.width,this.fontColor});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: (){
        Navigator.push(context, CupertinoPageRoute(builder: (context)=>CreateNewDocument(appBarTitle: 'Edit',document: document)));
      },
      child: Container(
        margin: EdgeInsets.only(right: 5),
        width: (width!=null)?width :double.infinity,
        child: Card(
            elevation: 1.0,
            color: col,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
              padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
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
                    padding: 0,
                    col: Colors.white.withAlpha(50),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    child: Text(
                      '${document.description}',
                      maxLines: 5,
                      style: GoogleFonts.lato(
                        color: fontColor,
                        fontWeight: FontWeight.w300,
                          fontSize: 14,
                          ),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }

}