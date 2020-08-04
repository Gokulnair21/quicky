import 'package:rxdart/rxdart.dart';
import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:note_app/plugin/notfication.dart';

class NotificationBloc {

  //Theme data
  final _notificationData = BehaviorSubject<List<PendingNotificationRequest>>();
  Stream<List<PendingNotificationRequest>> get notification => _notificationData.stream;
  Function(List<PendingNotificationRequest>) get changeNotificationData => _notificationData.sink.add;

  loadListOfScheduledNotifications()async{
    NotificationHandler notificationHandler=NotificationHandler();
    changeNotificationData(await notificationHandler.getScheduledNotification());
  }

  reload()async{
    NotificationHandler notificationHandler=NotificationHandler();
    changeNotificationData(await notificationHandler.getScheduledNotification());
  }

  dispose() {
    _notificationData.close();

  }
}
