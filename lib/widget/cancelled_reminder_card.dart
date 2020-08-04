import 'package:flutter/material.dart';
import 'package:note_app/model/reminder_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note_app/screen/reminder/view_reminder.dart';

import 'custom_divider.dart';

class CancelledReminder extends StatelessWidget {
  final Reminder reminder;

  CancelledReminder({this.reminder});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Color primaryColor = Theme.of(context).primaryColor;
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ViewReminder(
                    reminder: reminder,
                  ))),
      child: Container(
          alignment: Alignment.bottomLeft,
          decoration: BoxDecoration(
            color: (primaryColor == Colors.black)
                ? Theme.of(context).appBarTheme.color
                : primaryColor,
            borderRadius: BorderRadius.circular(20),
          ),
          margin: EdgeInsets.only(
            bottom: 15,
          ),
          width: double.infinity,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Text(
                        reminder.title,
                        maxLines: 2,
                        style: GoogleFonts.lato(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: CustomDivider(
                        padding: 0,
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 20,
                      padding: EdgeInsets.only(left: 20),
                      child: SizedBox(
                        child: Text(
                          '${reminder.type}',
                          maxLines: 1,
                          style: GoogleFonts.lato(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    (reminder.type == 'Daily' || reminder.type == 'Weekly')
                        ? Container(
                            width: double.infinity,
                            height: 20,
                            padding: EdgeInsets.only(left: 20),
                            child: SizedBox(
                              child: Text(
                                '${reminder.hour}:${reminder.minute}\t${reminder.period}',
                                maxLines: 1,
                                style: GoogleFonts.lato(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          )
                        : SizedBox(),
                    (reminder.type == 'Once')
                        ? Container(
                            width: double.infinity,
                            height: 20,
                            padding: EdgeInsets.only(left: 20),
                            child: SizedBox(
                              child: Text(
                                '${reminder.day}\t${intToStringMonth(reminder.month)}\t,\t${reminder.hour}:${reminder.minute}\t${reminder.period}',
                                maxLines: 1,
                                style: GoogleFonts.lato(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          )
                        : SizedBox(),
                    (reminder.type == 'Weekly')
                        ? Container(
                      width: double.infinity,
                      height: 20,
                      padding: EdgeInsets.only(left: 20),
                      child: SizedBox(
                        child: Text(
                          '${reminder.weekDays.substring(1,reminder.weekDays.length-1)}',
                          maxLines: 1,
                          style: GoogleFonts.lato(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    )
                        : SizedBox(),
                    SizedBox(
                      height: 5,
                    )
                  ],
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: Icon(Icons.notifications_none),
              ),
              SizedBox(
                width: 20,
              )
            ],
          )),
    );
  }

  Widget text(String label) {
    return Text(label,
        style: GoogleFonts.lato(fontSize: 15, fontWeight: FontWeight.w600));
  }

  String intToStringMonth(int index) {
    switch (index) {
      case 1:
        return 'Jan';
        break;
      case 2:
        return 'Feb';
        break;
      case 3:
        return 'Mar';
        break;
      case 4:
        return 'Apr';
        break;
      case 5:
        return 'May';
        break;
      case 6:
        return 'Jun';
        break;
      case 7:
        return 'Jul';
        break;
      case 8:
        return 'Aug';
        break;
      case 9:
        return 'Sep';
        break;
      case 10:
        return 'Oct';
        break;
      case 11:
        return 'Nov';
        break;
      case 12:
        return 'Dec';
        break;
    }
    return '';
  }
}
