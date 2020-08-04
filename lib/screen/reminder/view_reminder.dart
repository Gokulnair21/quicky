import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note_app/bloc/reminder_bloc.dart';
import 'package:note_app/model/reminder_model.dart';
import 'package:note_app/plugin/notfication.dart';
import 'create_new_reminder.dart';

class ViewReminder extends StatefulWidget {
  final Reminder reminder;

  ViewReminder({this.reminder});

  @override
  _ViewScheduledReminderState createState() => _ViewScheduledReminderState();
}

class _ViewScheduledReminderState extends State<ViewReminder> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  List<String> repeat = [
    'Once',
    'Daily',
    'Weekly',
  ];

  NotificationHandler notificationHandler = NotificationHandler();

  String status = '';

  final _viewReminder = GlobalKey<FormState>();

  initValues() {
    titleController.text = widget.reminder.title;
    descriptionController.text = widget.reminder.description;
    if (widget.reminder.status == 0) {
      status = 'Fired';
    } else if (widget.reminder.status == 1) {
      status = 'Schedueld';
    } else {
      status = 'Cancelled';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initValues();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          'View',
          style: GoogleFonts.lato(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: <Widget>[
          (widget.reminder.status != 0)
              ? IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    if(widget.reminder.status==1){
                      reminderCancel(widget.reminder);
                      reminderBloc.cancelled(widget.reminder);
                    }
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CreateNewReminder(
                                  appBarTitle: 'Change reminder time',
                                  reminder: widget.reminder,
                                )));
                  }
                )
              : SizedBox(),
          IconButton(
            icon: Icon(Icons.update),
            tooltip: 'Update',
            onPressed: () {
              if (_viewReminder.currentState.validate()) {
                widget.reminder.title = titleController.text;
                widget.reminder.description = descriptionController.text;
                reminderBloc.update(widget.reminder);
                Fluttertoast.showToast(msg: 'Updated');
                Navigator.pop(context);
              }
            },
          )
        ],
      ),
      body: Form(
        key: _viewReminder,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                myHeadingText('Reminder\tdetails'),
                SizedBox(
                  height: 20,
                ),
                reminderDetails(),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  maxLines: 1,
                  style: GoogleFonts.lato(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).iconTheme.color,
                      fontSize: 18),
                  keyboardType: TextInputType.multiline,
                  controller: titleController,
                  autofocus: false,
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
                TextFormField(
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
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
              (widget.reminder.status==1)?ListTile(
              contentPadding: EdgeInsets.all(0),
              title: Text(
                'Note:',
                style: GoogleFonts.lato(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              subtitle: Text(
                'The changes you do will not affect to reminder notification so if you want to change the detials of reminder,then click on Pencil icon',
                style: GoogleFonts.lato(fontWeight: FontWeight.w600, fontSize: 12),
              ),
            ):SizedBox()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget reminderDetails() {
    final color = Theme.of(context).iconTheme.color.withAlpha(70);

    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color)),
      height: 100,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              child: Column(
                children: <Widget>[
                  detailsHeading('Status'),
                  Expanded(child: detailsValue(status))
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  border: Border(
                      left: BorderSide(color: color),
                      right: BorderSide(color: color))),
              child: Column(
                children: <Widget>[
                  detailsHeading('Type'),
                  Expanded(child: detailsValue(widget.reminder.type))
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Column(
                children: <Widget>[
                  detailsHeading('Time'),
                  Expanded(
                      child: detailsValue(
                          '${widget.reminder.hour}:${widget.reminder.minute}\t\t${widget.reminder.period}'))
                ],
              ),
            ),
          ),
          (widget.reminder.type == repeat[0])
              ? Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(left: BorderSide(color: color))),
                    child: Column(
                      children: <Widget>[
                        detailsHeading('Date'),
                        Expanded(
                            child: detailsValue(
                                '${widget.reminder.day}-${widget.reminder.month}-${widget.reminder.year}'))
                      ],
                    ),
                  ),
                )
              : SizedBox(),
          (widget.reminder.type == repeat[2])
              ? Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(left: BorderSide(color: color))),
                    child: Column(
                      children: <Widget>[
                        detailsHeading('Week\tDays'),
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              widget.reminder.weekDays.substring(
                                  1, widget.reminder.weekDays.length - 1),
                              maxLines: 3,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lato(
                                  fontWeight: FontWeight.w600, fontSize: 10),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              : SizedBox()
        ],
      ),
    );
  }

  Widget detailsHeading(String label) {
    final color = Theme.of(context).iconTheme.color.withAlpha(70);
    return Container(
      decoration:
          BoxDecoration(border: Border(bottom: BorderSide(color: color))),
      alignment: Alignment.center,
      height: 30,
      child: Text(
        label,
        style: GoogleFonts.lato(fontWeight: FontWeight.w600, fontSize: 12),
      ),
    );
  }

  Widget detailsValue(String value) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        value,
        style: GoogleFonts.lato(fontWeight: FontWeight.w600, fontSize: 15),
      ),
    );
  }

  Widget myHeadingText(String label) {
    return Container(
      alignment: Alignment.centerLeft,
      width: double.infinity,
      height: 20,
      child: Text(
        label,
        style: GoogleFonts.lato(
            fontSize: 12, fontWeight: FontWeight.w600, color: Colors.red),
      ),
    );
  }

  void reminderCancel(Reminder reminder){
    int cipherValue = 210799;
    if (reminder.type == repeat[2]) {
      for (int i = 0; i < reminder.noOfWeeks; i++) {
        cancelNotification(reminder.id * cipherValue + i);
      }
    } else {
      cancelNotification(reminder.id);
    }
  }
  void cancelNotification(int id) {
    notificationHandler.cancelNotification(id);
  }
}
