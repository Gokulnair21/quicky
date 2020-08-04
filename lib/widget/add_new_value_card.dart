import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class AddNewValueCard extends StatelessWidget{

  final double width;
  final IconData icon;
  final String label;
  final double height;
  final double iconSize;

  AddNewValueCard({this.width,this.height,this.icon,this.label,this.iconSize});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SizedBox(
      height: height,
      width: width,
      child: Card(
          color: Theme.of(context).iconTheme.color.withAlpha(10),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(icon, color: Colors.red, size: iconSize),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    label,
                    style: GoogleFonts.lato(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    ),
                  )
                ],
              ))),
    );
  }

}