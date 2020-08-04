import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_view/photo_view.dart';
class ViewImage extends StatelessWidget{
 final  String imagePath;
 final Color color=Colors.white;
 ViewImage({this.imagePath,});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          iconTheme: IconThemeData(
              opacity: 5.0,
              color: color
          ),
          leading: IconButton(
              icon: Icon(Icons.clear),
              onPressed: () => Navigator.pop(context)),
        ),
        backgroundColor: Colors.black,
        body: Container(
          height: double.infinity,
          width: double.infinity,
          child: Hero(
            tag: imagePath,
            child: PhotoView(
                loadFailedChild: Icon(Icons.error),
                imageProvider:FileImage(File(imagePath))
            )
          ),
        )

    );
  }

}