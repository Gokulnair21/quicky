import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreenNoData extends StatelessWidget {
  final String label;

  SplashScreenNoData({this.label});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      alignment: Alignment.bottomCenter,
      height: MediaQuery.of(context).size.height/2.5,
      child:  Text(
          label,
          style: GoogleFonts.lato(
              fontSize: 25, fontWeight: FontWeight.w700,color: Theme.of(context).iconTheme.color.withAlpha(100)),textAlign: TextAlign.center,

      ),
    );
  }
}
