import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

class PermissionService{

  final PermissionHandler _permissionHandler = PermissionHandler();

  Future<bool> requestPermission(PermissionGroup permission) async {
    var result = await _permissionHandler.requestPermissions([permission]);
    if (result[permission] == PermissionStatus.granted) {
      return true;
    }
    return false;
  }


  Future<bool> requestStoragePermission({Function onPermissionDenied}) async {
    var granted = await requestPermission(PermissionGroup.storage);
    if (!granted) {
      onPermissionDenied();
    }
    return granted;
  }

  Future<bool> requestMicrophoneStoragePermission({Function onPermissionDenied}) async {
    var granted1 = await requestPermission(PermissionGroup.microphone);
    var granted2 = await requestPermission(PermissionGroup.storage);

    if (!(granted1 && granted2)) {
      onPermissionDenied();
    }
    if(granted1 && granted2){
      return true;
    }
    return false;

  }



  Future<bool> hasStoragePermission() async {
    return hasPermission(PermissionGroup.storage);
  }



  Future<bool> hasMicrophoneStoragePermission() async {
    bool val1=await  hasPermission(PermissionGroup.microphone);
    bool val2=await  hasPermission(PermissionGroup.microphone);
    if(val1 & val2){
      return true;
    }
    else{
      return false;
    }
  }



  Future<bool> hasPermission(PermissionGroup permission) async {
    var permissionStatus =
    await _permissionHandler.checkPermissionStatus(permission);
    return permissionStatus == PermissionStatus.granted;
  }





}

