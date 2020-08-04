import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HelpReminderTips extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          'FAQ',
          style: GoogleFonts.lato(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              myListTile(title: '1.Why am I not  receiving a notification\t?', subTitle: 'Check if your mobile has autostart option in settings.If yes then Goto Autostart->Search for "Quicky" and turn it on'),
              myListTile(title: '2.Does using grid in paint note,will the grid too will be saved ?',subTitle: 'Not at all,Pro tip:You can change grid size in Settings'),
            ],
          ),
        ),
      ),
    );
  }

  Widget myListTile({String title, String subTitle}) {
    return ListTile(
      contentPadding: EdgeInsets.all(0),
      title: Text(
        title,
        style: GoogleFonts.lato(fontWeight: FontWeight.w600, fontSize: 15),
      ),
      subtitle: Text(
        subTitle,
        style: GoogleFonts.lato(fontWeight: FontWeight.w600, fontSize: 13),
      ),
    );
  }
}
