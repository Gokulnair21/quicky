import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ListTileOfDrawer extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;


  ListTileOfDrawer({this.icon, this.label, this.onTap,});
  @override
  Widget build(BuildContext context) {
    Color color=Theme.of(context).iconTheme.color;

    // TODO: implement build
    return  ListTile(
      leading: Icon(icon,color: color,),
      onTap: onTap,
      title: Text(label, style: GoogleFonts.lato(
          fontSize:15,
          color: color,
          fontWeight: FontWeight.w600)),
    );

  }

}