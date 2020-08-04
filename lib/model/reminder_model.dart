import 'dart:convert';

class Reminder {
  int id;
  String title;
  String description;
  String type;
  int hour;
  int minute;
  String period;
  int day;
  int month;
  int year;
  String weekDays;
  int noOfWeeks;
  int status;

  Reminder(
      {this.id,
      this.title,
      this.description,
      this.hour,
      this.minute,
        this.period,
      this.type,
      this.day,
      this.month,
      this.year,
      this.weekDays,
      this.noOfWeeks,
      this.status});

  factory Reminder.fromMap(Map<String, dynamic> json) => Reminder(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      day: json['day'],
      month: json['month'],
      year: json['year'],
      hour: json['hour'],
      minute: json['minute'],
      period: json['period'],
      weekDays: json['weekDays'],
      noOfWeeks: json['noOfWeeks'],
      status: json['status'],
      type: json['type']);

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'day': day,
        'month': month,
        'year': year,
        'hour': hour,
        'minute': minute,
    'period':period,
        'weekDays': weekDays,
        'status': status,
        'noOfWeeks': noOfWeeks,
        'type': type
      };
}

Reminder documentFromJson(String str) {
  final jsonData = json.decode(str);
  return Reminder.fromMap(jsonData);
}

String documentToJson(Reminder data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}
