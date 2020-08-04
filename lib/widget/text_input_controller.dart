import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextInputTitle extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType inputType;
  final Color col ;
  final int max;
  final double fontSize;
  TextInputTitle({this.controller, this.hintText, this.inputType,this.col,this.max,this.fontSize});


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return TextFormField(
        style: GoogleFonts.lato(fontWeight: FontWeight.w600, color: col,fontSize:(fontSize==null)?20:fontSize),
        keyboardType: inputType,
        maxLines: max,
        minLines: 1,
        autofocus: false,
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
            hintText: hintText,
            hintStyle: GoogleFonts.lato(
                color: col.withAlpha(100),
                fontWeight: FontWeight.w600,
                fontSize: (fontSize==null)?20:fontSize,
                ),

            )
    );

  }

}
