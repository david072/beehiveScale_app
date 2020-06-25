import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stockwaage_app/screens/login/auth.dart';

import '../home.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final GlobalKey formKey = GlobalKey<FormState>();

  String name = '';
  String email = '';
  String password = '';

  Future<void> register() async {
    FirebaseUser user = await Authentication().register(formKey, name, email, password);
    if(user != null) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 10, left: 70, right: 70),
                  child: Image.asset(
                    'assets/images/bees.png',
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.blueAccent,
                    ),
                    onPressed: () => { Navigator.pop(context), },
                  ),
                )
              ],
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
                            'Registrieren',
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
                                    margin:
                                        EdgeInsets.only(top: 20, bottom: 20),
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
                                      onChanged: (String newName) => setState(() {
                                        name = newName;
                                      }),
                                      validator: (input) {
                                        if (input.isEmpty) {
                                          return 'Bitte gib deinen Namen an';
                                        }

                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        hintText: 'Name',
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
                                    child: Text('Registrieren'.toUpperCase(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'segoe ui semibold')),
                                    onPressed: () => {
                                      register(),
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
          ],
        ),
      ),
    );
  }
}
