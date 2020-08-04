import 'package:flutter/material.dart';

class RoundSwitch extends StatelessWidget{

  final bool val;
  RoundSwitch(this.val);
  final Color red=Colors.red;
  final Color transparent=Colors.transparent;

  @override
  Widget build(BuildContext context) {

    final col=Theme.of(context).dialogBackgroundColor;
    // TODO: implement build
    return GestureDetector(
      child: Container(
        height: 17,
        width: 17,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: red,width: 2)
        ),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:(val)?red:transparent,
            border: Border.all(color:col,width: 2)
          ),
        ),

      ),
    );
  }

}