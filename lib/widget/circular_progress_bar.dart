import 'package:flutter/material.dart';

class CentreCircularProgressIndicator extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.red),),);
  }

}