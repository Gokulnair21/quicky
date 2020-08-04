import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note_app/screen/archieve_notes.dart';
import 'package:note_app/screen/list_of_notes.dart';
import 'package:note_app/screen/settings_interface.dart';
import 'package:note_app/widget/list_tile_drawer.dart';

import 'list_tile_document.dart';

class CustomDrawer extends StatefulWidget {
  final String keyVal;

  CustomDrawer({this.keyVal});

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final Color black = Colors.black;

  final Color white = Colors.white;

  final List<String> scaffoldKeys = [
    '_listOfNotesScaffold',
    '_archiveScaffold',
    '_settingsScaffold'
  ];

  @override
  Widget build(BuildContext context) {
    Color divider = Theme.of(context).dividerColor.withAlpha(30);
    // TODO: implement build
    return SafeArea(
      child: Drawer(
          child: ListView(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Container(
              margin: EdgeInsets.only(left: 5, right: 5),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.red, borderRadius: BorderRadius.circular(50)),
              height: 50,
              child: Text(
                'Quicky',
                style: GoogleFonts.lato(
                    fontSize: 25, color: white, fontWeight: FontWeight.w800),
              )),
          SizedBox(
            height: 20,
          ),
          Container(
            decoration: BoxDecoration(
              color: (widget.keyVal == scaffoldKeys[0])?Colors.red:Colors.transparent,
                border: Border(bottom: BorderSide(color: divider))),
            child: ListTileOfDrawer(
              icon: Icons.home,
              label: 'Home',
              onTap: () {

                  Navigator.pushReplacement(context,
                      CupertinoPageRoute(builder: (context) => ListOfNotes()));

              },
            ),
          ),
          ListTileOfDrawer(
            icon: Icons.archive,
            label: 'Archive',
            onTap: () {
              if (widget.keyVal == scaffoldKeys[1]) {
                Navigator.pop(context);
              } else {
                Navigator.pushReplacement(context,
                    CupertinoPageRoute(builder: (context) => ArchiveNotes()));
              }
            },
          ),
          Container(
            decoration: BoxDecoration(
                //borderRadius: BorderRadius.only(bottomRight: Radius.circular(20),topRight: Radius.circular(20) ),
                // color: Colors.red,
                border: Border(bottom: BorderSide(color: divider))),
            child: ListTileOfDrawer(
              icon: Icons.delete_outline,
              label: 'Trash',
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          ListTileOfDrawer(
            icon: Icons.settings,
            label: 'Settings',
            onTap: () {
              if (widget.keyVal == scaffoldKeys[2]) {
                Navigator.pop(context);
              } else {
                Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => SettingsUi()));
              }
            },
          ),
          ListTileOfDrawer(
            icon: Icons.help_outline,
            label: 'Help',
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTileOfDrawer(
            icon: Icons.feedback,
            label: 'Feedback',
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      )),
    );
  }
}
