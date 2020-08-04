import 'dart:async';
import 'package:flutter/material.dart';

class TimerBloc {

TimerBloc(){
  changeTimeNow();
}
  final _timerController=StreamController<TimeOfDay>.broadcast();
  get time=>_timerController.stream;

  Function(TimeOfDay) get changeTime => _timerController.sink.add;


  changeTimeNow(){
    changeTime(TimeOfDay.now());
  }

  dispose(){
    _timerController.close();
  }

}

final timeBloc=TimerBloc();