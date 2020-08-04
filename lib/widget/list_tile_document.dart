import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ListTileOfDocs extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color col;

  ListTileOfDocs({this.icon, this.label, this.onTap,this.col});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  ListTile(
        leading: Icon(icon, color: col,),
        onTap: onTap,
        title: Text(label, style: GoogleFonts.lato(
            fontSize:15,
            color: col,
            fontWeight: FontWeight.w600)),
      );

  }

}