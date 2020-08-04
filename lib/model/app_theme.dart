import 'package:flutter/material.dart';

final Color white = Colors.white;
final Color black = Colors.black;
final Color red = Colors.red;
final Color blackVariant=Color(0xff424242);
final Color  backgroundScaffold=Color(0xff212121);

List<ThemeData> themeData = [
  ThemeData(
      bottomAppBarTheme: BottomAppBarTheme(color: white),
      brightness: Brightness.light,
      dividerColor: black.withAlpha(30),
      primaryColor: white,
      iconTheme: IconThemeData(color: black),
      appBarTheme: AppBarTheme(color:white,iconTheme: IconThemeData(color: black),actionsIconTheme: IconThemeData(color: black)),
      ),
  ThemeData(
    primaryColor:black,
    bottomAppBarTheme: BottomAppBarTheme(color: Colors.white.withAlpha(20)),
      iconTheme: IconThemeData(color: white),
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundScaffold,
      dividerColor: Colors.white.withAlpha(30),
      appBarTheme: AppBarTheme(iconTheme: IconThemeData(color: white),color: Colors.white.withAlpha(20),actionsIconTheme: IconThemeData(color: white)))
];
