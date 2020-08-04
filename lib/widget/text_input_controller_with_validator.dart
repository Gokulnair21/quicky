import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextInputValidator extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType inputType;
  final bool autoFocus;
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;
  final InputBorder border;
  final int maxLines;

  TextInputValidator({this.controller, this.hintText, this.inputType, this.autoFocus,this.color,this.fontSize,this.fontWeight,this.border,this.maxLines});




  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return TextFormField(
      maxLines: (maxLines!=null)?maxLines:1,
        minLines: 1,
        style: GoogleFonts.lato(fontWeight:(fontWeight!=null)? fontWeight:FontWeight.w500, color: color,fontSize: (fontSize!=null)?fontSize:15),
        keyboardType: inputType,
        controller: controller,
        autofocus: autoFocus,
        validator: (value) {
          if (value.isEmpty) {
            return 'Please fill the field';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          border: (border==null)?InputBorder.none:border,
            hintText: hintText,
            hintStyle: GoogleFonts.lato(
                fontWeight: (fontWeight!=null)? fontWeight:FontWeight.w500,
                fontSize: (fontSize!=null)?fontSize:15,
                ),
            errorStyle: TextStyle(
              color: Colors.red,
            ),
            ));

  }

}
