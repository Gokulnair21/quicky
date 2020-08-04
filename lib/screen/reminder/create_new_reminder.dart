import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:note_app/bloc/notification_bloc.dart';
import 'package:note_app/model/reminder_model.dart';
import 'package:note_app/plugin/notfication.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note_app/bloc/reminder_bloc.dart';
import 'package:note_app/provider/notification_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateNewReminder extends StatefulWidget {
  final String appBarTitle;
  final Reminder reminder;

  CreateNewReminder({this.appBarTitle, this.reminder});

  @override
  _CreateNewReminderState createState() =>
      _CreateNewReminderState(reminder: reminder);
}

class _CreateNewReminderState extends State<CreateNewReminder> {
  final Reminder reminder;

  _CreateNewReminderState({this.reminder});

  List<String> repeat = [
    'Once',
    'Daily',
    'Weekly',
  ];
  String currentType;
  List<Day> days = [];

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  TimeOfDay selectedTime;
  DateTime dateTime;

  bool sun = false;
  bool mon = false;
  bool tue = false;
  bool wed = false;
  bool thu = false;
  bool fri = false;
  bool sat = false;
  int id;

  final _newReminder = GlobalKey<FormState>();

  initValues() {
    sharedPrefsSetting(false);
    if (id == null) {
      id = 1;
    }
    currentType = repeat[0];
    selectedTime = TimeOfDay.now();
    dateTime = DateTime.now();
    days.clear();
    titleController.clear();
    descriptionController.clear();
    titleController.text=reminder.title;
    descriptionController.text=reminder.description;

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initValues();
  }

  @override
  Widget build(BuildContext context) {
    final notificationBloc = Provider.of<NotificationProvider>(context).bloc;
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text(
            widget.appBarTitle,
            style: GoogleFonts.lato(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          actions: <Widget>[
            IconButton(
              tooltip: 'Clear',
              icon: Icon(Icons.clear_all),
              onPressed: () => resetToDefault(),
            ),
            IconButton(
              tooltip: 'Set reminder',
              icon: Icon(Icons.check),
              onPressed: () => saveAndSetNotification(notificationBloc),
            ),
          ],
        ),
        body: Form(
          key: _newReminder,
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                children: <Widget>[
                  Container(
                    child: Wrap(
                      children: <Widget>[
                        Padding(
                          padding:
                              EdgeInsets.only(left: 10, right: 10, top: 10),
                          child: TextFormField(
                            maxLines: 1,
                            style: GoogleFonts.lato(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).iconTheme.color,
                                fontSize: 18),
                            keyboardType: TextInputType.multiline,
                            controller: titleController,
                            autofocus: true,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter a title';
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Title',
                              hintStyle: GoogleFonts.lato(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                              errorStyle: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 10),
                          child: TextFormField(
                              style: GoogleFonts.lato(
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).iconTheme.color,
                                  fontSize: 16),
                              keyboardType: TextInputType.multiline,
                              maxLines: 999,
                              minLines: 1,
                              autofocus: false,
                              controller: descriptionController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Description...',
                                hintStyle: GoogleFonts.lato(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: Column(
                      children: <Widget>[
                        myHeadingText('Notification\tsettings'),
                        ListTile(
                          contentPadding: EdgeInsets.only(left: 10, right: 10),
                          //width: double.infinity,
                          title: DropdownButton<String>(
                            isExpanded: true,
                            autofocus: false,
                            value: currentType,
                            elevation: 0,
                            style: GoogleFonts.lato(
                                fontWeight: FontWeight.w600, fontSize: 15),
                            onChanged: (String newValue) {
                              setState(() {
                                currentType = newValue;
                              });
                            },
                            items: repeat
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: GoogleFonts.lato(
                                      color: Theme.of(context).iconTheme.color,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        timeSetting(),
                        SizedBox(
                          height: 10,
                        ),
                        (currentType == repeat[2]) ? weekDays() : SizedBox(),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Widget containerRep(String label, bool status) {
    final color = (status)
        ? Theme.of(context).iconTheme.color
        : Theme.of(context).iconTheme.color.withAlpha(150);
    return Container(
      height: 30,
      alignment: Alignment.center,
      margin: EdgeInsets.only(left: 10, right: 10),
      key: Key(label),
      decoration: BoxDecoration(
          color: (status) ? Colors.red : Colors.transparent,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: color)),
      child: Text(
        label,
        style: GoogleFonts.lato(
            fontWeight: FontWeight.w900, fontSize: 13, color: color),
      ),
    );
  }

  Widget timeSetting() {
    final color = Theme.of(context).iconTheme.color;
    return Container(
      child: Column(
        children: <Widget>[
          ListTile(
            contentPadding: EdgeInsets.only(left: 10, right: 10),
            subtitle: Text(
                '${selectedTime.hourOfPeriod}:${selectedTime.minute}\t${selectedTime.period.toString().substring(10)}',
                style: GoogleFonts.lato(
                    fontSize: 15, fontWeight: FontWeight.w600)),
            trailing: Icon(
              Icons.alarm,
              color: color,
            ),
            onTap: () async {
              selectedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (selectedTime == null) {
                selectedTime = TimeOfDay.now();
              }
              print(selectedTime);
              setState(() {});
            },
            title: Text('Set a time',
                style: GoogleFonts.lato(
                    fontSize: 15, fontWeight: FontWeight.w600)),
          ),
          (currentType != 'Daily' && currentType != 'Weekly')
              ? ListTile(
                  contentPadding: EdgeInsets.only(left: 10, right: 10),
                  trailing: Icon(
                    Icons.calendar_today,
                    color: color,
                  ),
                  subtitle: Text(
                      '${dateTime.day}-${dateTime.month}-${dateTime.year}',
                      style: GoogleFonts.lato(
                          fontSize: 15, fontWeight: FontWeight.w600)),
                  onTap: () async {
                    dateTime = await showDatePicker(
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(Duration(days: 9999999)),
                      context: context,
                      initialDate: DateTime.now(),
                    );
                    if (dateTime == null) {
                      dateTime = DateTime.now();
                    }
                    setState(() {});
                  },
                  title: Text('Set a date',
                      style: GoogleFonts.lato(
                          fontSize: 15, fontWeight: FontWeight.w600)),
                )
              : SizedBox(),
        ],
      ),
    );
  }

  Widget weekDays() {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            height: 30,
            child: Row(
              children: <Widget>[
                Expanded(
                    child: GestureDetector(
                        onTap: () {
                          sun = !sun;
                          addOrRemove(sun, Day.Sunday);
                          setState(() {});
                        },
                        child: containerRep('Sun', sun))),
                Expanded(
                    child: GestureDetector(
                        onTap: () {
                          mon = !mon;
                          addOrRemove(mon, Day.Monday);
                          setState(() {});
                        },
                        child: containerRep('Mon', mon))),
                Expanded(
                    child: GestureDetector(
                        onTap: () {
                          tue = !tue;
                          addOrRemove(tue, Day.Tuesday);
                          setState(() {});
                        },
                        child: containerRep('Tue', tue))),
                Expanded(
                    child: GestureDetector(
                        onTap: () {
                          wed = !wed;
                          addOrRemove(wed, Day.Wednesday);
                          setState(() {});
                        },
                        child: containerRep('Wed', wed))),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            height: 30,
            child: Row(
              children: <Widget>[
                Expanded(
                    child: GestureDetector(
                        onTap: () {
                          thu = !thu;
                          addOrRemove(thu, Day.Thursday);
                          setState(() {});
                        },
                        child: containerRep('Thu', thu))),
                Expanded(
                    child: GestureDetector(
                        onTap: () {
                          fri = !fri;
                          addOrRemove(fri, Day.Friday);
                          setState(() {});
                        },
                        child: containerRep('Fri', fri))),
                Expanded(
                    child: GestureDetector(
                        onTap: () {
                          sat = !sat;
                          addOrRemove(sat, Day.Saturday);
                          setState(() {});
                        },
                        child: containerRep('Sat', sat))),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }

  Widget myHeadingText(String label) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: 10, right: 10),
      width: double.infinity,
      height: 20,
      child: Text(
        label,
        style: GoogleFonts.lato(
            fontSize: 12, fontWeight: FontWeight.w600, color: Colors.red),
      ),
    );
  }

  void addOrRemove(bool val, Day day) {
    if (val) {
      days.add(day);
    } else {
      days.remove(day);
    }
  }

  void saveAndSetNotification(NotificationBloc bloc) async {
    NotificationHandler notificationHandler = NotificationHandler();
    if (_newReminder.currentState.validate()) {
      if (id == null) {
        id = 1;
      }
      if(reminder.id!=null){
        reminder.id=reminder.id;
      }else{
        reminder.id = id;
      }
      reminder.title = titleController.text;
      reminder.description = descriptionController.text;
      reminder.type = currentType;
      reminder.hour = selectedTime.hourOfPeriod;
      reminder.minute = selectedTime.minute;
      reminder.period = (selectedTime.hour >= 12) ? 'PM' : 'AM';
      reminder.day = dateTime.day;
      reminder.month = dateTime.month;
      reminder.year = dateTime.year;
      reminder.noOfWeeks = days.length;
      saveWeekDays();
      reminder.status = 1;
      switch (currentType) {
        case 'Once':
          notificationHandler.singleNotification(
              reminder.title,
              reminder.id,
              'hi Once $id',
              dateTime.year,
              dateTime.day,
              dateTime.month,
              selectedTime.hour,
              selectedTime.minute);
          break;
        case 'Daily':
          notificationHandler.dailyNotification(
              Time(selectedTime.hour, selectedTime.minute),
              reminder.title,
              reminder.id,
              'hi Daily $id');
          break;
        case 'Weekly':
          notificationHandler.showNotificationOnSpecificWeekday(
              Time(selectedTime.hour, selectedTime.minute),
              reminder.title,
              reminder.id,
              'Hi Weekly $id',
              days);
          break;
      }
      if(id==reminder.id){
        reminderBloc.add(reminder);
        id = id + 1;
        sharedPrefsSetting(true);
      }
      else{
        reminderBloc.update(reminder);
      }
      await bloc.reload();
      Fluttertoast.showToast(msg: 'Reminder has been set');
      Navigator.pop(context);
    }
  }

  void sharedPrefsSetting(bool set) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (set) {
      prefs.setInt('reminderId', id);
    } else {
      id = prefs.getInt('reminderId');
    }
  }

  void saveWeekDays() {
    List<String> daysInString = [];
    for (int i = 0; i < days.length; i++) {
      switch (days[i]) {
        case Day.Monday:
          daysInString.add('Mon');
          break;
        case Day.Tuesday:
          daysInString.add('Tue');
          break;
        case Day.Wednesday:
          daysInString.add('Wed');
          break;
        case Day.Thursday:
          daysInString.add('Thur');
          break;
        case Day.Friday:
          daysInString.add('Fri');
          break;
        case Day.Saturday:
          daysInString.add('Sat');
          break;
        case Day.Sunday:
          daysInString.add('Sun');
          break;
      }
    }
    reminder.weekDays = daysInString.toString();
  }


  void resetToDefault(){
    currentType=repeat[0];
    titleController.clear();
    descriptionController.clear();
    selectedTime=TimeOfDay.now();
    dateTime=DateTime.now();
    days.clear();
    setState(() {
    });
  }
}
