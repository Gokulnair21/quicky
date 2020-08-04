import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note_app/bloc/document_all_values_bloc.dart';
import 'package:note_app/bloc/reminder_bloc.dart';
import 'package:note_app/bloc/theme_bloc.dart';
import 'package:note_app/plugin/notfication.dart';
import 'package:note_app/widget/custom_divider.dart';
import 'package:note_app/widget/text_input_controller_with_validator.dart';
import 'package:provider/provider.dart';
import 'package:note_app/provider/theme_provider.dart';
import 'package:note_app/model/app_theme.dart';
import 'package:note_app/widget/custom_switch.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsUi extends StatefulWidget {
  @override
  _SettingsUiState createState() => _SettingsUiState();
}

class _SettingsUiState extends State<SettingsUi> {
  final Color black = Colors.black;
  final Color white = Colors.white;
  final Color red = Colors.red;

  String passwordValue;

  GlobalKey<ScaffoldState> _settingsScaffold = GlobalKey<ScaffoldState>();

  SharedPreferences prefs;
  final _newPasswordState = GlobalKey<FormState>();
  final _changePasswordState = GlobalKey<FormState>();
  final _gridLengthState = GlobalKey<FormState>();
  final changePasswordController = TextEditingController();
  final passwordController = TextEditingController();
  final gridController = TextEditingController();

  initValue() async {
    prefs = await SharedPreferences.getInstance();
    passwordValue = prefs.getString('passwordValue');
  }

  TimeOfDay selectedTime;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initValue();
    selectedTime=TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<SettingsProvider>(context).bloc;

    // TODO: implement build
    return Scaffold(
      key: _settingsScaffold,
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          'Settings',
          style: GoogleFonts.lato(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 5,
            ),
            myHeadingText('Personalization'),
            StreamBuilder<bool>(
                stream: bloc.viewType,
                builder: (context, AsyncSnapshot<bool> snapshot) {
                  if (snapshot.data == null) {
                    return SizedBox();
                  }
                  return settingsListTile(
                      function: () => setDefaultView(bloc, snapshot.data),
                      title: 'Default view of notes',
                      subtitle: (snapshot.data) ? 'List' : 'Grid');
                }),
            StreamBuilder<ThemeData>(
              stream: bloc.theme,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SwitchListTile(
                    activeColor: red,
                    contentPadding:
                        EdgeInsets.only(left: 10, right: 10, bottom: 0, top: 0),
                    value: (snapshot.data == themeData[0]) ? false : true,
                    onChanged: (value) {
                      if (value) {
                        bloc.changeTheme(themeData[1]);
                      } else {
                        bloc.changeTheme(themeData[0]);
                      }
                      bloc.saveThemePreferences();
                    },
                    subtitle: Text(
                      'Dark mode saves your battery too!',
                      style: GoogleFonts.lato(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                    ),
                    title: Text(
                      'Enable dark mode',
                      style: GoogleFonts.lato(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                    ),
                  );
                }
                return SizedBox();
              },
            ),
            StreamBuilder<int>(
              stream: bloc.gridLength,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return settingsListTile(
                      function: () =>
                          gridBottomSheetSetter(context, snapshot.data, bloc),
                      title: 'Change grid length in paint note',
                      subtitle: '${snapshot.data}');
                }
                return SizedBox();
              },
            ),
            CustomDivider(
              padding: 0,
            ),
            myHeadingText('Notes'),
            settingsListTile(
                function: () => alertDialogBox(
                    label:
                        'Are you sure you want to delete all notes permanently?',
                    yesFunction: deleteAll),
                title: 'Delete all notes',
                subtitle: 'Permanently delete all notes'),
            settingsListTile(
                function: () => alertDialogBox(
                    label:
                        'Are you sure you want to delete all text notes permanently?',
                    yesFunction: () => deleteParticularType(1)),
                title: 'Delete all text notes',
                subtitle: 'Permanently delete all text notes'),
            settingsListTile(
                function: () => alertDialogBox(
                    label:
                        'Are you sure you want to delete all voice notes permanently?',
                    yesFunction: () => deleteParticularType(2)),
                title: 'Delete all voice notes',
                subtitle: 'Permanently delete all voice notes'),
            settingsListTile(
                function: () => alertDialogBox(
                    label:
                        'Are you sure you want to delete all paint notes permanently?',
                    yesFunction: () => deleteParticularType(3)),
                title: 'Delete all paint notes',
                subtitle: 'Permanently delete all paint notes'),
            CustomDivider(
              padding: 0,
            ),
            myHeadingText('Reminders'),
            SizedBox(
              height: 10,
            ),
            settingsListTile(
                function: () {
                  NotificationHandler notify = NotificationHandler();
                  notify.cancelAllNotification();
                  reminderBloc.cancelAll();
                  Fluttertoast.showToast(msg: 'All reminders are cancelled');
                },
                title: 'Cancel all reminders',
                subtitle:
                    'All scheduled reminders will be converted to cancelled reminders'),
            settingsListTile(
                function: () => alertDialogBox(
                    label:
                        'Are you sure you want to delete all reminders permanently?',
                    yesFunction: () => deleteAllReminder()),
                title: 'Delete all reminders',
                subtitle:
                    'This will include scheduled,fired and cancelled reminders too'),
            CustomDivider(
              padding: 0,
            ),
            myHeadingText('Security'),
            StreamBuilder<bool>(
              stream: bloc.password,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Wrap(
                    children: <Widget>[
                      SwitchListTile(
                        activeColor: red,
                        contentPadding: EdgeInsets.only(left: 10, right: 10),
                        value: snapshot.data,
                        onChanged: (value) async {
                          if (value) {
                            bloc.changePassword(true);
                            if (passwordValue == null || passwordValue == '') {
                              await newPassword(context, bloc);
                            }
                          } else {
                            bloc.changePassword(false);
                          }
                          bloc.savePasswordPreferences();
                        },
                        subtitle: Text(
                          'This feature will set a secure login method',
                          style: GoogleFonts.lato(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                        ),
                        title: Text(
                          'Enable authentication',
                          style: GoogleFonts.lato(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                        ),
                      ),
                      (snapshot.data)
                          ? settingsListTile(
                              function: () => changePassword(context),
                              title: 'Change\tpassword',
                              subtitle: 'Change the password of secure login')
                          : SizedBox(),
                    ],
                  );
                }
                return SizedBox();
              },
            ),
            SizedBox(
              height: 5,
            ),
          ],
        ),
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
            fontSize: 12, fontWeight: FontWeight.w600, color: red),
      ),
    );
  }

  Widget settingsListTile({VoidCallback function, String title, String subtitle}) {
    return ListTile(
      contentPadding: EdgeInsets.only(left: 10, right: 10),
      onTap: function,
      title: Text(
        title,
        style: GoogleFonts.lato(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.lato(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        maxLines: 2,
      ),
    );
  }

  Widget roundedSwitchListTile({String title, bool value, VoidCallback onTap}) {
    return ListTile(
        enabled: true,
        contentPadding: EdgeInsets.only(left: 20, right: 10),
        onTap: onTap,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(child: RoundSwitch(value)),
            SizedBox(
              width: 30,
            ),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.lato(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ));
  }

  void setDefaultView(SettingsBloc bloc, bool val) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return Dialog(
              elevation: 4.0,
              child: StatefulBuilder(builder: (context, changeState) {
                return Container(
                  child: Wrap(
                    children: <Widget>[
                      ListTile(
                        contentPadding: EdgeInsets.only(left: 20, right: 10),
                        title: Text(
                          'View type',
                          style: GoogleFonts.lato(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      roundedSwitchListTile(
                        title: 'List',
                        value: val,
                        onTap: () {
                          val = !val;
                          changeState(() {});
                        },
                      ),
                      roundedSwitchListTile(
                        title: 'Grid',
                        value: (!val),
                        onTap: () {
                          val = !val;
                          changeState(() {});
                        },
                      ),
                    ],
                  ),
                );
              }));
        }).then((value) {
      if (val) {
        bloc.changeViewType(true);
      } else {
        bloc.changeViewType(false);
      }
      bloc.saveViewTypePreferences();
    });
  }

  void alertDialogBox({
    String label,
    VoidCallback yesFunction,
  }) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return AlertDialog(
            title: Text(
              label,
              style:
                  GoogleFonts.lato(fontWeight: FontWeight.w500, fontSize: 15),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text('No',
                    style: GoogleFonts.lato(
                        fontWeight: FontWeight.w500, color: red, fontSize: 15)),
              ),
              FlatButton(
                onPressed: yesFunction,
                child: Text(
                  'Yes',
                  style: GoogleFonts.lato(
                      fontWeight: FontWeight.w500, color: red, fontSize: 15),
                ),
              ),
            ],
          );
        });
  }

  Future<void> newPassword(BuildContext context, SettingsBloc bloc) async {
    passwordController.clear();
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        child: StatefulBuilder(
          builder: (context, changeState) {
            return Form(
              key: _newPasswordState,
              child: Container(
                padding: EdgeInsets.all(10.0),
                child: Wrap(
                  children: <Widget>[
                    Theme(
                      data: ThemeData(
                        hintColor:
                            Theme.of(context).iconTheme.color.withAlpha(100),
                        primaryColor: red.withAlpha(150),
                      ),
                      child: TextInputValidator(
                        color: Theme.of(context).iconTheme.color,
                        controller: passwordController,
                        inputType: TextInputType.text,
                        border: UnderlineInputBorder(),
                        hintText: 'New password',
                        autoFocus: true,
                      ),
                    ),
                    Container(
                      height: 10,
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: 30,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: SizedBox(),
                          ),
                          customFlatButton(
                            label: 'Cancel',
                            function: () {
                              bloc.changePassword(false);
                              bloc.savePasswordPreferences();
                              Navigator.pop(context);
                            },
                          ),
                          customFlatButton(
                            label: 'Ok',
                            function: () {
                              if (_newPasswordState.currentState.validate()) {
                                savePasswordValue(passwordController.text);
                                Navigator.pop(context);
                                Fluttertoast.showToast(msg: 'Password Saved');
                              }
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void changePassword(BuildContext context) {
    passwordController.clear();
    changePasswordController.clear();
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Dialog(
              child: StatefulBuilder(builder: (context, changeState) {
                return Form(
                  key: _changePasswordState,
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: Wrap(
                      children: <Widget>[
                        Theme(
                          data: ThemeData(
                              hintColor: Theme.of(context)
                                  .iconTheme
                                  .color
                                  .withAlpha(100),
                              primaryColor: red.withAlpha(150)),
                          child: TextInputValidator(
                            color: Theme.of(context).iconTheme.color,
                            controller: passwordController,
                            inputType: TextInputType.text,
                            border: UnderlineInputBorder(),
                            hintText: 'Old password',
                            autoFocus: true,
                          ),
                        ),
                        Container(
                          height: 10,
                        ),
                        Theme(
                          data: ThemeData(
                              hintColor: Theme.of(context)
                                  .iconTheme
                                  .color
                                  .withAlpha(100),
                              primaryColor: red.withAlpha(150)),
                          child: TextInputValidator(
                            color: Theme.of(context).iconTheme.color,
                            controller: changePasswordController,
                            inputType: TextInputType.text,
                            border: UnderlineInputBorder(),
                            hintText: 'New password',
                            autoFocus: true,
                          ),
                        ),
                        Container(
                          height: 10,
                        ),
                        Container(
                          height: 30,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: SizedBox(),
                              ),
                              customFlatButton(
                                  label: 'Cancel',
                                  function: () {
                                    Navigator.pop(context);
                                  }),
                              customFlatButton(
                                label: 'Change',
                                function: () {
                                  if (_changePasswordState.currentState
                                      .validate()) {
                                    if (passwordController.text ==
                                        passwordValue) {
                                      savePasswordValue(
                                          changePasswordController.text);
                                      Fluttertoast.showToast(
                                          msg: 'Password changed');
                                      Navigator.pop(context);
                                    } else {
                                      Fluttertoast.showToast(
                                          msg:
                                              'Please recheck your old password');
                                    }
                                  }
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
            ));
  }

  Widget customFlatButton({String label, VoidCallback function}) {
    return FlatButton(
      onPressed: function,
      child: Text(
        label,
        style: GoogleFonts.lato(
            fontSize: 15, fontWeight: FontWeight.w500, color: red),
      ),
    );
  }

  void gridBottomSheetSetter(
      BuildContext context, int val, SettingsBloc settingsBloc) {
    gridController.text = val.toString();
    showModalBottomSheet<void>(
      context: context,
      enableDrag: true,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: Container(
          padding: EdgeInsets.only(
              left: 10,
              right: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom),
          width: double.infinity,
          child: Form(
            key: _gridLengthState,
            child: Wrap(
              children: <Widget>[
                Container(
                  child: Center(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: TextInputValidator(
                          color: Theme.of(context).iconTheme.color,
                          hintText: 'Grid length',
                          controller: gridController,
                          autoFocus: true,
                          inputType: TextInputType.number,
                        )),
                        FlatButton(
                          onPressed: () {
                            if (_gridLengthState.currentState.validate()) {
                              if (gridController.text != '0') {
                                settingsBloc.changeGridLength(
                                    int.tryParse(gridController.text));
                                settingsBloc.saveGridLength();
                                Fluttertoast.showToast(
                                    msg: 'Grid size updated');
                                Navigator.pop(context);
                              } else {
                                Fluttertoast.showToast(
                                    msg: 'Grid size cannot be zero');
                              }
                            }
                          },
                          child: Text(
                            'OK',
                            style: GoogleFonts.lato(
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void deleteParticularType(int type) {
    documentBloc.deleteASingleType(type);
    Fluttertoast.showToast(msg: 'Deleted!!!');
    Navigator.pop(context);
  }

  void deleteAllReminder() {
    NotificationHandler notificationHandler = NotificationHandler();
    notificationHandler.cancelAllNotification();
    reminderBloc.deleteAll();
    Fluttertoast.showToast(msg: 'Deleted!!!');
    Navigator.pop(context);
  }

  void deleteAll() {
    documentBloc.deleteAll();
    Fluttertoast.showToast(msg: 'Deleted!!!');
    Navigator.pop(context);
  }

  void savePasswordValue(String value) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString('passwordValue', value);
  }

  String minute(int min){
    if(min<10){
      return '0$min';
    }
    return '$min';
  }

}
