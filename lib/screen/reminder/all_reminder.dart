import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note_app/bloc/notification_bloc.dart';
import 'package:note_app/bloc/time_bloc.dart';
import 'package:note_app/model/reminder_model.dart';
import 'package:note_app/provider/notification_provider.dart';
import 'package:note_app/screen/reminder/create_new_reminder.dart';
import 'package:note_app/bloc/reminder_bloc.dart';
import 'package:note_app/plugin/notfication.dart';
import 'package:note_app/screen/splashscreen/splashscreen_no_data.dart';
import 'package:note_app/widget/cancelled_reminder_card.dart';
import 'package:note_app/widget/circular_progress_bar.dart';
import 'package:note_app/widget/fired_reminder_card.dart';
import 'package:note_app/widget/scheduled_reminder_card.dart';
import 'package:provider/provider.dart';

class AllReminders extends StatefulWidget {
  @override
  _AllRemindersState createState() => _AllRemindersState();
}

class _AllRemindersState extends State<AllReminders> {
  final Color white = Colors.white;
  final Color red = Colors.red;

  NotificationHandler notificationHandler = NotificationHandler();

  List<PendingNotificationRequest> scheduledNotifications = [];

  List<String> repeat = [
    'Once',
    'Daily',
    'Weekly',
  ];

  timerUpdate() {
    Timer.periodic(
        Duration(seconds: 1), (Timer timer) => timeBloc.changeTimeNow());
  }

  final _scaffoldKeyOfAllReminder=GlobalKey<ScaffoldState>();

  initReminders() {
    reminderBloc.initScheduledReminders();
    reminderBloc.initFiredReminder();
    reminderBloc.initCancelledReminder();
    reminderBloc.updateAllNo();
    reminderBloc.updateCancelledNo();
    reminderBloc.updateFiredNo();
    reminderBloc.updateScheduledNo();
    final notificationBloc = Provider.of<NotificationProvider>(context, listen: false).bloc;
    notificationBloc.reload();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    timerUpdate();
    initReminders();
  }

  @override
  Widget build(BuildContext context) {
  reminderBloc.test();
    final notificationBloc =
        Provider.of<NotificationProvider>(context, listen: true).bloc;

    // TODO: implement build
    return Scaffold(
      key: _scaffoldKeyOfAllReminder,
      appBar: getAppBar(notificationBloc),
      body: mainReminderScreen(notificationBloc),
      floatingActionButton: FloatingActionButton(
          tooltip: 'New\tReminder',
          backgroundColor: red,
          child: Icon(
            Icons.add_alert,
            color: white,
          ),
          onPressed: () {
            Reminder newReminder = Reminder(
                title: '',
                description: '',
                weekDays: '',
                type: '',
                period: '',
                id: null);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateNewReminder(
                    appBarTitle: 'New', reminder: newReminder),
              ),
            );
          }),
    );
  }

  Widget mainReminderScreen(NotificationBloc notificationBloc) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            StreamBuilder<int>(
              stream: reminderBloc.allReminderNo,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data == 0) {
                    return SplashScreenNoData(
                        label: 'Wanna have some reminders\t?\nThen proceed...');
                  }
                  reminderBloc.updateScheduledNo();
                  reminderBloc.updateCancelledNo();
                  return dashBoard();
                }
                return CentreCircularProgressIndicator();
              },
            ),
            //dashBoard(),
            SizedBox(
              height: 15,
            ),

            StreamBuilder<List<PendingNotificationRequest>>(
              stream: notificationBloc.notification,
              builder: (context, snapshotNotification) {
                if (snapshotNotification.hasData) {
                  scheduledNotifications.addAll(snapshotNotification.data);
                  return StreamBuilder<List<Reminder>>(
                    initialData: reminderBloc.scheduledReminders,
                    stream: reminderBloc.scheduledReminder,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: Text('snapshot no data'),
                        );
                      }
                      if (snapshot.hasData) {
                        if (snapshot.data.length == 0) {
                          return SizedBox();
                        }
                        return Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Wrap(
                            children: <Widget>[
                              Container(
                                alignment: Alignment.centerLeft,
                                height: 30,
                                child: Text(
                                  'Reminders scheduled',
                                  style: GoogleFonts.lato(
                                    fontSize: 15,
                                    color: Colors.green,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              Container(
                                height: 10,
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) {
                                  Reminder data = snapshot.data[index];
                                  if (snapshot.data.length !=
                                      scheduledNotifications.length) {
                                    conversionToFired(data);
                                  }
                                  return Dismissible(
                                    dismissThresholds: {
                                      DismissDirection.horizontal: 0.8,
                                    },
                                    onDismissed: (direction) {
                                      dismiss(direction, data);
                                    },
                                    confirmDismiss: (direction) =>
                                        promptUser(direction, data),
                                    key: ValueKey(data.id),
                                    secondaryBackground: Container(
                                      margin: EdgeInsets.only(bottom: 10),
                                      padding: EdgeInsets.only(right: 20),
                                      color: Colors.amber,
                                      alignment: Alignment.centerRight,
                                      child: Icon(
                                        Icons.notifications_off,
                                        color: white,
                                      ),
                                    ),
                                    background: Container(
                                      margin: EdgeInsets.only(bottom: 10),
                                      padding: EdgeInsets.only(left: 20),
                                      color: Colors.red,
                                      alignment: Alignment.centerLeft,
                                      child: Icon(Icons.delete, color: white),
                                    ),
                                    direction: DismissDirection.horizontal,
                                    child: ScheduledReminder(
                                      reminder: data,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      }
                      return CircularProgressIndicator();
                    },
                  );
                }
                return Center(
                  child: Text('loading'),
                );
              },
            ),
            StreamBuilder<List<Reminder>>(
              initialData: reminderBloc.cancelledReminders,
              stream: reminderBloc.cancelledReminder,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: Text('snapshot has no data'),
                  );
                }
                if (snapshot.hasData) {
                  if (snapshot.data.length == 0) {
                    return SizedBox();
                  }
                  return Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Wrap(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          height: 30,
                          child: Text(
                            'Reminders cancelled',
                            style: GoogleFonts.lato(
                              fontSize: 15,
                              color: Colors.amber,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Container(
                          height: 10,
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            Reminder data = snapshot.data[index];
                            return Dismissible(
                              key: ValueKey(data.id),
                              dismissThresholds: {
                                DismissDirection.horizontal: 0.8,
                              },
                              background: Container(
                                margin: EdgeInsets.only(bottom: 10),
                                padding: EdgeInsets.only(left: 20),
                                color: Colors.red,
                                alignment: Alignment.centerLeft,
                                child: Icon(Icons.delete, color: white),
                              ),
                              direction: DismissDirection.startToEnd,
                              onDismissed: (direction) {
                                reminderBloc.delete(data.id);
                                showSnackBar();
                              },
                              child: CancelledReminder(
                                reminder: data,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                }
                return CircularProgressIndicator();
              },
            ),
            StreamBuilder<List<Reminder>>(
              initialData: reminderBloc.firedReminders,
              stream: reminderBloc.firedReminder,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: Text('snapshot has no data'),
                  );
                }
                if (snapshot.hasData) {
                  if (snapshot.data.length == 0) {
                    return SizedBox();
                  }
                  return Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Wrap(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          height: 30,
                          child: Text(
                            'Reminders fired',
                            style: GoogleFonts.lato(
                              fontSize: 15,
                              color: Colors.red,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Container(
                          height: 10,
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            Reminder data = snapshot.data[index];
                            return Dismissible(
                              key: ValueKey(data.id),
                              direction: DismissDirection.horizontal,
                              background: Container(
                                margin: EdgeInsets.only(bottom: 10),
                                padding: EdgeInsets.only(left: 20),
                                color: Colors.red,
                                alignment: Alignment.centerLeft,
                                child: Icon(Icons.delete, color: white),
                              ),
                              secondaryBackground: Container(
                                margin: EdgeInsets.only(bottom: 10),
                                padding: EdgeInsets.only(right: 20),
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                child: Icon(Icons.delete, color: white),
                              ),
                              onDismissed: (d) {
                                reminderBloc.delete(data.id);
                                showSnackBar();
                              },
                              child: FiredReminder(
                                reminder: data,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                }
                return CircularProgressIndicator();
              },
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }

  Widget dashBoard() {
    final color = Colors.white.withAlpha(70);
    return Container(
      height: 260,
      margin: EdgeInsets.only(top: 10, right: 10, left: 10),
      width: double.infinity,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.red,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              alignment: Alignment.centerLeft,
              height: 30,
              child: Text(
                'Dashboard',
                style: GoogleFonts.lato(
                  fontSize: 15,
                  color: white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: color))),
                child: Center(
                  child: currentTime(),
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                          child: typesOfRemindersData(
                              'Scheduled', 1, reminderBloc.scheduledNo)),
                    ),
                    Expanded(
                      child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  left: BorderSide(
                                    color: color,
                                  ),
                                  right: BorderSide(color: color))),
                          child: typesOfRemindersData(
                              'Cancelled', 2, reminderBloc.cancelledNo)),
                    ),
                    Expanded(
                      child: Container(
                          child: typesOfRemindersData(
                              'Fired', 0, reminderBloc.firedNo)),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget typesOfRemindersData(String label, int status, Stream<int> stream) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            height: 40,
            alignment: Alignment.center,
            child: Text(
              label,
              style: GoogleFonts.lato(
                  fontWeight: FontWeight.w600, fontSize: 12, color: white),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white.withAlpha(50), shape: BoxShape.circle),
              child: Center(
                child: StreamBuilder<int>(
                    initialData: 0,
                    stream: stream,
                    builder: (context, snapshot) {
                      return Text('${snapshot.data}',
                          style: GoogleFonts.lato(
                              fontWeight: FontWeight.w600,
                              fontSize: 25,
                              color: white));
                    }),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }

  Widget currentTime() {
    String period = (TimeOfDay.now().hour >= 12) ? 'PM' : 'AM';
    return StreamBuilder<TimeOfDay>(
      initialData: TimeOfDay.now(),
      stream: timeBloc.time,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Text('loading');
        }
        if (snapshot.hasData) {
          final time = snapshot.data;
          return Container(
            decoration: BoxDecoration(
                color: Colors.white.withAlpha(50),
                borderRadius: BorderRadius.circular(50)),
            child: Text(
              '\t\t${hour(time.hourOfPeriod)}:${minute(time.minute)}\t\t$period\t\t',
              style: GoogleFonts.lato(
                  fontWeight: FontWeight.w800, fontSize: 35, color: white),
            ),
          );
        }
        return Text('loading');
      },
    );
  }

  Widget getAppBar(NotificationBloc notificationBloc) {
    return AppBar(
      elevation: 0.0,
      title: Text(
        'Reminders',
        style: GoogleFonts.lato(
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  //Functions

  void conversionToFired(Reminder reminder) {
    int cipherValue = 210799;
    int l = scheduledNotifications.length;
    if (reminder.type == repeat[2]) {
      for (int i = 0; i < l; i++) {
        if (scheduledNotifications[i].id == reminder.id * cipherValue) {
          return;
        }
      }
    } else {
      for (int i = 0; i < l; i++) {
        if (scheduledNotifications[i].id == reminder.id) {
          return;
        }
      }
      reminderBloc.fired(reminder);
    }
  }

  void dismiss(DismissDirection direction, Reminder reminder) {
    int cipherValue = 210799;
    if (reminder.type == repeat[2]) {
      for (int i = 0; i < reminder.noOfWeeks; i++) {
        cancelNotification(reminder.id * cipherValue + i);
      }
    } else {
      cancelNotification(reminder.id);
    }
    if (direction == DismissDirection.endToStart) {
      reminderBloc.cancelled(reminder);
    } else {
      reminderBloc.delete(reminder.id);
    }
  }

  void cancelNotification(int id) {
    notificationHandler.cancelNotification(id);
  }

  String minute(int minute) {
    if (minute < 10) {
      return '0$minute';
    }
    return '$minute';
  }

  String hour(int hour) {
    if (hour == 0) {
      return '12';
    } else if (hour >= 1 && hour < 10) {
      return '0$hour';
    }
    return '$hour';
  }

  String second(int second) {
    if (second < 10) {
      return '0$second';
    }
    return '$second';
  }


  void showSnackBar(){
    _scaffoldKeyOfAllReminder.currentState.showSnackBar(SnackBar(content:Text('Reminder deleted',style: GoogleFonts.lato(),) ,duration: Duration(seconds: 1),));
  }

  Future<bool> promptUser(DismissDirection direction, Reminder reminder) async {
    String action;
    if (direction == DismissDirection.endToStart) {
      action = "cancel notification";
    } else {
      action = "delete";
    }

    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            content: Text(
                "Are you sure you want to $action?This action cannot be retrieved.",
                style: GoogleFonts.lato(
                    fontWeight: FontWeight.w500, fontSize: 15)),
            actions: <Widget>[
              FlatButton(
                child: Text('Cancel',
                    style: GoogleFonts.lato(
                        fontWeight: FontWeight.w500, color: red, fontSize: 15)),
                onPressed: () {
                  return Navigator.of(context).pop(false);
                },
              ),
              FlatButton(
                child: Text("Ok",
                    style: GoogleFonts.lato(
                        fontWeight: FontWeight.w500, color: red, fontSize: 15)),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          ),
        ) ??
        false;
  }
}
