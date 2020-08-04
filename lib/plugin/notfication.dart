import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHandler{
  NotificationHandler() {
    initializeNotifications();
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  initializeNotifications() {
    var initializeSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initialSettings = InitializationSettings(
        initializeSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initialSettings,
        onSelectNotification: selectNotification);
  }

  Future selectNotification(String payload) async {
    if (payload != null) {
      print(payload);
    }
  }
 Future singleNotification(String message,int id, String payload,int year,int date,int month,int hour,int minute)async{
   var scheduledNotificationDateTime = DateTime(year,month,date,hour,minute);
   var androidChannel = AndroidNotificationDetails(
     'channel-id',
     'channel-name',
     'channel-description',
     importance: Importance.Max,
     priority: Priority.Max,
   );

   var iosChannel = IOSNotificationDetails();
   var platformChannel = NotificationDetails(androidChannel, iosChannel);
   flutterLocalNotificationsPlugin.schedule(id, 'Reminder', message, scheduledNotificationDateTime,platformChannel, payload:payload);
 }
 
 
  Future dailyNotification(Time time, String message,int id, String payload,) async {
    var androidChannel = AndroidNotificationDetails(
      'channel-id',
      'channel-name',
      'channel-description',
      importance: Importance.Max,
      priority: Priority.Max,
    );

    var iosChannel = IOSNotificationDetails();
    var platformChannel = NotificationDetails(androidChannel, iosChannel);
    flutterLocalNotificationsPlugin.showDailyAtTime(
        id, 'Reminder', message, time, platformChannel,
        payload: payload);
  }


  Future showNotificationOnSpecificWeekday(Time time, String message,int id, String payload,List<Day> day)async{

    int cipherValue=210799;
    for(int i=0;i<day.length;i++){
      var androidPlatformChannelSpecifics =
      AndroidNotificationDetails('show weekly channel id',
          'show weekly channel name', 'show weekly description');
      var iOSPlatformChannelSpecifics =
      IOSNotificationDetails();
      var platformChannelSpecifics = NotificationDetails(
          androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
          id*cipherValue+i,
          'Reminder',
          message,
          day[i],
          time,
          platformChannelSpecifics,payload:payload);
    }
    }


  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
  Future<void> cancelAllNotification() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  getScheduledNotification()async{
    List<PendingNotificationRequest> pendingNotificationRequests =
    await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    return pendingNotificationRequests;
  }


//  void dailyNotificationFunction(String subtitle,int hour, int minute, String period, int id, String payload) {
//    if (period == 'PM') {
//      hour = hour + 12;
//      dailyNotification(Time(hour, minute, 0), 'Wake up',subtitle, id, payload);
//    } else {
//      dailyNotification(Time(hour, minute, 0), 'Wake up',subtitle, id, payload);
//    }
//  }
//  Future periodicNotification(String message, String subtext, int id, String payload,
//      {String sound}) async {
//    var androidChannel = AndroidNotificationDetails(
//      'repeating channel-id',
//      'repeating channel-name',
//      'repeating channel-description',
//      importance: Importance.Max,
//      priority: Priority.Max,
//    );
//
//    var iosChannel = IOSNotificationDetails();
//    var platformChannel = NotificationDetails(androidChannel, iosChannel);
//    flutterLocalNotificationsPlugin.periodicallyShow(
//        id, message, subtext,RepeatInterval.Hourly, platformChannel,
//        payload: payload);
//  }
//



}
