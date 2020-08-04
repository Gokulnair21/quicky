import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDivider extends StatelessWidget {

  final double padding;
  final Color col;
  CustomDivider({this.padding,this.col});
  
  


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: EdgeInsets.only(left:padding,right: padding ),
      child: Divider(
        color: (col==null)?Theme.of(context).dividerColor :col,
          thickness: 1),
    );

  }

}
