import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note_app/widget/custom_raised_button.dart';
import 'list_of_notes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:note_app/widget/top_bar_curve_design.dart';

class AuthenticationScreen extends StatefulWidget {
  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final passwordController = TextEditingController();
  final _passwordFormKey = GlobalKey<FormState>();
  IconData visibleIcon;
  bool isVisible;

  SharedPreferences prefs;
  String passwordValue;

  initData() async {
    visibleIcon = Icons.visibility;
    isVisible = true;
    prefs = await SharedPreferences.getInstance();
    passwordValue = prefs.getString('passwordValue');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initData();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Form(
          key: _passwordFormKey,
          child: CustomScrollView(
            scrollDirection: Axis.vertical,
            physics: ClampingScrollPhysics(),
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Stack(
                          children: <Widget>[
                            TopBar(height: 200.0,),
                            Container(
                              padding: EdgeInsets.only(left: 10,top: 20),
                              child: Text(
                                'Login',
                                style: GoogleFonts.lato(
                                    fontSize: 25, fontWeight: FontWeight.w700, color: Colors.white),
                              ) ,
                            )
                          ],
                        )
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        child: Wrap(
                          children: <Widget>[
                            Container(
                              padding:
                                  EdgeInsets.only(left: 10, right: 10, top: 20),
                              child: Theme(
                                data: ThemeData(
                                  primaryColor: Theme.of(context)
                                      .iconTheme
                                      .color
                                      .withAlpha(100),
                                ),
                                isMaterialAppTheme: true,
                                child: TextFormField(
                                    style: GoogleFonts.lato(
                                        color: Theme.of(context).iconTheme.color,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20),
                                    keyboardType: TextInputType.text,
                                    controller: passwordController,
                                    autofocus: true,
                                    obscureText: isVisible,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Please enter the password';
                                      } else {
                                        return null;
                                      }
                                    },
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      hintText: 'Password',
                                      suffixIcon: IconButton(
                                        color: Theme.of(context).iconTheme.color,
                                        icon: Icon(visibleIcon),
                                        onPressed: () => changeVisibility(),
                                      ),
                                      hintStyle: GoogleFonts.lato(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20,
                                        color: Theme.of(context).iconTheme.color,
                                      ),
                                      errorStyle: TextStyle(
                                        color: Colors.red,
                                      ),
                                    )),
                              ),
                            ),
                            Container(
                              height: 30,
                            ),
                            Container(
                              height: 80,
                              child: Center(
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  elevation: 5.0,
                                  color: Colors.red,
                                  child: Text(
                                    '\tLogin\t',
                                    style: GoogleFonts.lato(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20,
                                        color:Colors.white),
                                  ),
                                  onPressed: () => save(),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      //Expanded(child: SizedBox(),),
                    ],
                  ),
                ),
              ),
              SliverFillRemaining(
                  hasScrollBody: false,
                  child: Container(
                    padding: EdgeInsets.only(top: 30, bottom: 30),
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTap: () {
                        Fluttertoast.showToast(msg: 'Suffer the loss bruh!!!');
                      },
                      child: Text(
                        'Forgot password?',
                        style: GoogleFonts.lato(
                            fontSize: 12,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w500,
                            color: Colors.red),
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  changeVisibility() {
    isVisible = !isVisible;
    if (isVisible) {
      visibleIcon = Icons.visibility;
    } else {
      visibleIcon = Icons.visibility_off;
    }
    setState(() {});
  }

  save() {
    if (_passwordFormKey.currentState.validate()) {
      if (passwordValue == passwordController.text) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ListOfNotes()));
        Fluttertoast.showToast(msg: 'Welcome');
      } else {
        Fluttertoast.showToast(msg: 'Incorrect password');
        passwordController.clear();
      }
    }
  }
}
