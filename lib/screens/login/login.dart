import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stockwaage_app/screens/home/HomeDrawer.dart';
import 'package:stockwaage_app/screens/login/registration.dart';
import 'package:stockwaage_app/screens/login/auth.dart';

class Login extends StatefulWidget {
  final bool shouldCheckAlreadyLoggedIn;

  Login({this.shouldCheckAlreadyLoggedIn = false});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey formKey = GlobalKey<FormState>();
  bool checked = false;

  String email = '';
  String password = '';

  void checkAlreadyLoggedInUser(BuildContext ctx) async {
    FirebaseUser user = await FirebaseAuth.instance.onAuthStateChanged.firstWhere((u) => u != null);
    Navigator.push(ctx, MaterialPageRoute(builder: (ctx) => HomeDrawer(user: user,)));
  }

  Future<void> login() async {
    FirebaseUser user = await Authentication().signIn(formKey, email, password);
    if(user != null) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeDrawer(user: user)));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    if(!checked && widget.shouldCheckAlreadyLoggedIn) {
      setState(() {
        checked = true;
      });
      checkAlreadyLoggedInUser(context);
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 10, left: 70, right: 70),
              child: Image.asset(
                'assets/images/bees.png',
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Stockwaage',
                            style: TextStyle(
                              fontFamily: 'bahnschrift',
                              fontWeight: FontWeight.bold,
                              fontSize: 38,
                              color: Color(0xff707070),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            width: 88,
                            height: 2,
                            color: Color(0xff3B3B3B),
                          ),
                          Text(
                            'Login',
                            style: TextStyle(
                              fontFamily: 'segoe ui light',
                              fontSize: 28,
                              color: Color(0xff707070),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 8, bottom: 40),
                            width: 88,
                            height: 2,
                            color: Color(0xff3B3B3B),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 40, right: 40),
                            child: Form(
                              key: formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(200),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 5,
                                            blurRadius: 6,
                                            offset: Offset(0, 3),
                                          )
                                        ]),
                                    child: TextFormField(
                                      onChanged: (String newEmail) => setState(() {
                                        email = newEmail;
                                      }),
                                      validator: (input) {
                                        if (input.isEmpty) {
                                          return 'Bitte gib eine E-Mail an';
                                        }
                                        else if(!input.contains('@')) {
                                          return 'Die E-Mail muss ein "@" enthalten.';
                                        }

                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        hintText: 'E-Mail',
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0xff008F26),
                                            width: 2,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(200),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0xff008F26),
                                            width: 2,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(200),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.only(top: 20, bottom: 50),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(200),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 5,
                                            blurRadius: 6,
                                            offset: Offset(0, 3),
                                          )
                                        ]),
                                    child: TextFormField(
                                      onChanged: (String newPassword) => setState(() {
                                        password = newPassword;
                                      }),
                                      validator: (input) {
                                        if (input.isEmpty) {
                                          return 'Bitte gib ein Passwort an';
                                        }
                                        else if(input.length < 8) {
                                          return 'Das Password muss mindestens 8 Zeichen lang sein.';
                                        }

                                        return null;
                                      },
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        hintText: 'Passwort',
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0xff008F26),
                                            width: 2,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(200),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0xff008F26),
                                            width: 2,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(200),
                                        ),
                                      ),
                                    ),
                                  ),
                                  MaterialButton(
                                    minWidth: double.infinity,
                                    height: 50,
                                    color: Color(0xff4925A7),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text('Login'.toUpperCase(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'segoe ui semibold')),
                                    onPressed: () => {
                                      login(),
                                    },
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
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 40, left: 40),
              child: Row(
                children: <Widget>[
                  Text(
                    'Du hast keinen Account? ',
                    style: TextStyle(
                      fontFamily: 'century gothic',
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  GestureDetector(
                    child: Text('Registrieren!',
                        style: TextStyle(
                          fontFamily: 'century gothic',
                          fontSize: 15,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff00851B),
                        )),
                    onTap: () => { Navigator.of(context).push(MaterialPageRoute(builder: (context) => Registration())) },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
