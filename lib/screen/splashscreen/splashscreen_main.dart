import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note_app/bloc/document_all_values_bloc.dart';
import 'package:note_app/provider/theme_provider.dart';
import 'package:note_app/screen/authentication_screen.dart';
import 'package:note_app/screen/list_of_notes.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';



class SplashScreenHome extends StatefulWidget {
  @override
  _SplashScreenStateHome createState() => _SplashScreenStateHome();
}

class _SplashScreenStateHome extends State<SplashScreenHome> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //documentBloc.getDocument();
    //documentBloc.getImportantDocument();
  }


  @override
  Widget build(BuildContext context) {
    final bloc = Provider
        .of<SettingsProvider>(context)
        .bloc;

    final _backgroundColor=Theme.of(context).scaffoldBackgroundColor;

    return StreamBuilder<bool>(
      stream: bloc.password,
      builder: (context, snapshot) {
        if(snapshot.data==null)
          {
            return SplashScreen(
                seconds: 4,
                title: Text('Quicky',
                  style: GoogleFonts.lato(
                      fontWeight: FontWeight.w700,
                      fontSize: 26.0
                  ),),
                backgroundColor: _backgroundColor,
                styleTextUnderTheLoader: TextStyle(),
                onClick: () => Fluttertoast.showToast(msg: "Quicky is loading..."),
                loaderColor: Colors.red
            );
          }
          if(snapshot.hasData){
            return SplashScreen(
                seconds: 1,
                navigateAfterSeconds: (snapshot.data)
                    ? AuthenticationScreen()
                    : ListOfNotes(),
                title: Text('Quicky',
                  style: GoogleFonts.lato(
                      fontWeight: FontWeight.w700,
                      fontSize: 26.0
                  ),),
                backgroundColor: _backgroundColor,
                styleTextUnderTheLoader: TextStyle(),
                onClick: () => Fluttertoast.showToast(msg: "Quicky is loading..."),
                loaderColor: Colors.red
            );
          }
        return SizedBox();
      },
    );
  }
}
