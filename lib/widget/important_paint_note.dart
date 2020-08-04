
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note_app/model/document_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:note_app/screen/paint/paint_detailed_view.dart';
class ImportantPaintNote extends StatelessWidget{
  final Color col;
  final Document document;
  final double width;
  final Color fontColor;


  ImportantPaintNote({this.col,this.document,this.width,this.fontColor});


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: (){
        Navigator.push(context, CupertinoPageRoute(builder: (context)=>PainterDetailedDocument(appBarTitle: 'Edit',document: document,)));
      },
      child: Container(
        margin: EdgeInsets.only(right: 5),
        width: (width!=null)?width :double.infinity,
        child: Card(
            elevation: 1.0,
            color:col,
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
                        color:fontColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          ),
                    ),
                  ),
                  SizedBox(
                    height: 13,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10))),
                    height: 120,
                    width: 150,
                    child: Image.file(
                      File(document.images),
                      fit: BoxFit.fill,
                    ),
                  )
                ],
              ),
            )),
      ),
    );

  }

}