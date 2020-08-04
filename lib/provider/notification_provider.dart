import 'package:flutter/material.dart';
import 'package:note_app/bloc/notification_bloc.dart';


class NotificationProvider with ChangeNotifier{
  NotificationBloc notificationBloc;
  NotificationProvider() {
    notificationBloc = NotificationBloc();

    notificationBloc.loadListOfScheduledNotifications();
  }

  NotificationBloc get bloc => notificationBloc;
}