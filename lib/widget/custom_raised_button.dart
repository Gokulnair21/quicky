import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomRaisedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final Color bgColor ;
  final Color textColor ;
  final double elevation;
  final double fontSize;

  CustomRaisedButton({this.onPressed, this.label,this.textColor,this.bgColor,this.elevation,this.fontSize});



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return RaisedButton(
      elevation: elevation,
      color: bgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      onPressed: onPressed,
      child: Center(
        child: Text(label,
            style: GoogleFonts.lato(
                color: textColor,
                fontWeight: FontWeight.w600,
                fontSize: fontSize)),
      ),
    );
  }
}
