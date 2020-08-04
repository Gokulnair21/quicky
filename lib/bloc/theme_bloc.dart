import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:note_app/model/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsBloc {

  //Theme data
  final _themeData = BehaviorSubject<ThemeData>();
  Stream<ThemeData> get theme => _themeData.stream;
  Function(ThemeData) get changeTheme => _themeData.sink.add;

  //View type
  final _viewType=BehaviorSubject<bool>();
  Stream<bool> get viewType=>_viewType.stream;
  Function(bool) get changeViewType=>_viewType.sink.add;

  //isPasswordEnabled
  final _password=BehaviorSubject<bool>();
  Stream<bool> get password=>_password.stream;
  Function(bool) get changePassword=>_password.sink.add;

  //gridLength
  final _gridLength=BehaviorSubject<int>();
  Stream<int> get gridLength=>_gridLength.stream;
  Function(int) get changeGridLength=>_gridLength.sink.add;



  //Saving preferences

  saveThemePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_themeData.value == themeData[0]) {
      await prefs.setBool('dark', false);
    } else {
      await prefs.setBool('dark', true);
    }
  }

  saveViewTypePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_viewType.value == false) {
      await prefs.setBool('viewType', false);
    } else {
      await prefs.setBool('viewType', true);
    }
  }

  savePasswordPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_password.value == false) {
      await prefs.setBool('password', false);
    } else {
      await prefs.setBool('password', true);
    }
  }


  saveGridLength()async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    await prefs.setInt('gridLength',_gridLength.value );
  }

  loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool darkMode = await prefs.get('dark');
    bool viewType=await prefs.get('viewType');
    bool passwordS=await prefs.get('password');
    int grid= prefs.getInt('gridLength');
    bool scheduleNote= prefs.getBool('scheduleNote');

    //theme data
    if (darkMode != null) {
      (darkMode == false)
          ? changeTheme(themeData[0])
          : changeTheme(themeData[1]);
    } else {
      changeTheme(themeData[0]);
    }

    //viewType
    if(viewType!=null){
      (viewType==false)?changeViewType(false):changeViewType(true);
    }
    else{
      changeViewType(true);
    }

    //password
    if(passwordS!=null){
      (passwordS==false)?changePassword(false):changePassword(true);
    }
    else{
      changePassword(false);
    }

    //gridLength
    if(grid==null){
        changeGridLength(20);
    }else{
      changeGridLength(grid);
    }




  }






  dispose() {
    _themeData.close();
    _viewType.close();
    _password.close();
    _gridLength.close();
  }
}
