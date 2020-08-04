import 'package:flutter/material.dart';
import 'package:note_app/provider/notification_provider.dart';
import 'package:note_app/screen/list_of_notes.dart';
import 'package:note_app/provider/theme_provider.dart';
import 'package:note_app/screen/splashscreen/splashscreen_main.dart';
import 'package:provider/provider.dart';
import 'package:note_app/screen/authentication_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SettingsProvider>(
            create: (_) => SettingsProvider()),
        ChangeNotifierProvider<NotificationProvider>(create: (_)=>NotificationProvider()),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, child) {
          return StreamBuilder<ThemeData>(
            stream: settings.bloc.theme,
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return SizedBox();
              }
              return MaterialApp(
                  title: 'Quicky',
                  home: SplashScreenHome(),
                  debugShowCheckedModeBanner: false,
                  theme: snapshot.data,
              );
            },
          );
        },
      ),
    );
  }
}
