import 'dart:convert';

class Document {
  int id;
  String title;
  String description;
  String images;
  int noOfImages;
  int backgroundColor;
  int textColor;
  int descriptionFontStyle;
  int descriptionFontWeight;
  int descriptionTextAlignment;
  num descriptionFontSize;
  int descriptionTextDirection;
  int day;
  int month;
  int year;
  int hour;
  int minute;
  String period;
  int priority;
  int archive;
  int type;

  Document(
      {this.id,
      this.title,
      this.description,
      this.images,
      this.noOfImages,
      this.backgroundColor,
      this.textColor,
      this.descriptionFontStyle,
      this.descriptionFontWeight,
      this.descriptionTextAlignment,
      this.descriptionFontSize,
      this.descriptionTextDirection,
      this.day,
      this.month,
      this.year,
      this.hour,
      this.minute,
      this.period,
      this.priority,
      this.archive,
      this.type});

  factory Document.fromMap(Map<String, dynamic> json) => Document(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      images: json['images'],
      noOfImages: json['noOfImages'],
      backgroundColor: json['backgroundColor'],
      textColor: json['textColor'],
      descriptionFontStyle: json['descriptionFontStyle'],
      descriptionFontWeight: json['descriptionFontWeight'],
      descriptionTextAlignment: json['descriptionTextAlignment'],
      descriptionFontSize: json['descriptionFontSize'],
      descriptionTextDirection: json['descriptionTextDirection'],
      day: json['day'],
      month: json['month'],
      year: json['year'],
      hour: json['hour'],
      minute: json['minute'],
      period: json['period'],
      priority: json['priority'],
      archive: json['archive'],
      type: json['type']);

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'images': images,
        'noOfImages': noOfImages,
        'backgroundColor': backgroundColor,
        'textColor': textColor,
        'descriptionFontStyle': descriptionFontStyle,
        'descriptionFontWeight': descriptionFontWeight,
        'descriptionTextAlignment': descriptionTextAlignment,
        'descriptionFontSize': descriptionFontSize,
        'descriptionTextDirection': descriptionTextDirection,
        'day': day,
        'month': month,
        'year': year,
        'hour': hour,
        'minute': minute,
        'period': period,
        'priority': priority,
        'archive': archive,
        'type': type
      };
}

Document documentFromJson(String str) {
  final jsonData = json.decode(str);
  return Document.fromMap(jsonData);
}

String documentToJson(Document data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}
