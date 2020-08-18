import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:stockwaage_app/screens/home/HomeDrawer.dart';
import 'package:stockwaage_app/util/FirestoreThings.dart';
import 'package:http/http.dart' as http;

class BeehiveScaleSettings extends StatefulWidget {
  final String ip;

  BeehiveScaleSettings({this.ip});

  @override
  _BeehiveScaleSettingsState createState() => _BeehiveScaleSettingsState();
}

class _BeehiveScaleSettingsState extends State<BeehiveScaleSettings> {
  Color pickerColor = Color(0xff);
  Color textColor = Color(0xff959595).withOpacity(0.8);
  Color color;
  FirebaseUser user;

  String displayName = '';
  String ssid = '';
  String password = '';

  GlobalKey formKey1 = new GlobalKey<FormState>();
  GlobalKey formKey2 = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    initialColor();
    setTextColor();
    getUser();
  }

  void initialColor() {
    Random rand = Random();
    int length = 6;
    String chars = '0123456789ABCDEF';
    String hex = '0xff';
    while (length-- > 0) hex += chars[(rand.nextInt(16)) | 0];

    color = Color(int.parse(hex));
    pickerColor = color;
  }

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  void onFinished() {
    setState(() => color = pickerColor);
    setTextColor();
    Navigator.of(context).pop();
  }

  double brightness(Color color) {
    int red = color.red;
    int green = color.green;
    int blue = color.blue;

    return sqrt(
        red * red * 0.241 + green * green * 0.691 + blue * blue * 0.068);
  }

  void setTextColor() {
    double b = brightness(color);
    if (b > 130) {
      setState(() => textColor = Color(0xff000000).withOpacity(0.8));
    } else if (b <= 130) {
      setState(() => textColor = Color(0xffFFFFFF).withOpacity(0.8));
    }
  }

  Future<void> getUser() async {
    user = await FirebaseAuth.instance.currentUser();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  color: Colors.black,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),
            Container(
              margin: EdgeInsets.only(left: 15, right: 15, top: 10),
              child: Wrap(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: 5),
                    child: Icon(
                      Icons.info_outline,
                      color: Colors.deepOrangeAccent,
                    ),
                  ),
                  Text(
                    'Du musst dich mit der Stockwaage ',
                    style: TextStyle(
                      color: Colors.deepOrangeAccent,
                      fontSize: 18,
                      fontFamily: 'segoe ui',
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 30),
                    child: Text(
                      'verbunden haben, oder im gleichen WLAN wie sie sein, um WLAN-Daten zu ändern!',
                      style: TextStyle(
                        color: Colors.deepOrangeAccent,
                        fontSize: 18,
                        fontFamily: 'segoe ui',
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Form(
              key: formKey1,
              child: Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                width: double.infinity,
                child: TextFormField(
                  onChanged: (String newDisplayName) => setState(() {
                    displayName = newDisplayName;
                  }),
                  decoration: InputDecoration(
                    hintText: 'Stockwaagen Name',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xff008F26),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(200),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xff008F26),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(200),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20, top: 5),
              child: Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Text(
                      'Farbe:',
                      style: TextStyle(
                        fontFamily: 'century gothic',
                        fontSize: 22,
                      ),
                    ),
                  ),
                  Expanded(
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(400),
                      ),
                      color: color,
                      child: Text(
                        'Color-Picker öffnen',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xff959595).withOpacity(0.8),
                        ),
                      ),
                      onPressed: () => showDialog(
                        context: context,
                        child: AlertDialog(
                          title: Text('Wähle eine Farbe aus!'),
                          content: SingleChildScrollView(
                            child: ColorPicker(
                              pickerColor: pickerColor,
                              onColorChanged: changeColor,
                            ),
                          ),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('Fertig!'),
                              onPressed: () => {
                                onFinished(),
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Form(
              key: formKey2,
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    width: double.infinity,
                    child: TextFormField(
                      onChanged: (String newSSID) => setState(() {
                        ssid = newSSID;
                      }),
                      decoration: InputDecoration(
                        hintText: 'WLAN - Name',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xff008F26),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(200),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xff008F26),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(200),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                    width: double.infinity,
                    child: TextFormField(
                      onChanged: (String newPassword) => setState(() {
                        password = newPassword;
                      }),
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'WLAN - Passwort',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xff008F26),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(200),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xff008F26),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(200),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 200,
              margin: EdgeInsets.only(left: 20, bottom: 15, right: 20),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: Row(
                          children: <Widget>[
                            MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(200),
                                  side: BorderSide(
                                      color: Color(0xff008F26), width: 2.5)),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(right: 5),
                                    child: Icon(
                                      Icons.arrow_back_ios,
                                      color: Colors.blueAccent,
                                      size: 20,
                                    ),
                                  ),
                                  Text(
                                    'Löschen',
                                    style: TextStyle(
                                      fontFamily: 'bahnschrift',
                                      fontSize: 20,
                                      color: Color(0xff707070),
                                    ),
                                  ),
                                ],
                              ),
                              onPressed: () {
                                ExternalClass.deleteBeehiveScale(widget.ip, user);
                                Navigator.push(context, MaterialPageRoute(builder: (ctx) => HomeDrawer(user: user,)));
                              },
                            ),
                            SizedBox(
                              width: size.width - 45 * 7.8,
                            ),
                            MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(200),
                                  side: BorderSide(
                                      color: Color(0xff008F26), width: 2.5)),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    'Speichern',
                                    style: TextStyle(
                                      fontFamily: 'bahnschrift',
                                      fontSize: 20,
                                      color: Color(0xff707070),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(right: 5),
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.blueAccent,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                              onPressed: () async {
                                bool isValid = ExternalClass.isValid(formKey1, formKey2);
                                ExternalClass.save(formKey1, formKey2, color, displayName, ssid, password, widget.ip, user);

                                if(isValid) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (ctx) =>
                                              HomeDrawer(user: user)));
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ExternalClass {

  static bool isValid(GlobalKey<FormState> formKey1, GlobalKey<FormState> formKey2) {
    FormState formState1 = formKey1.currentState;
    FormState formState2 = formKey2.currentState;
    return formState1.validate() && formState2.validate();
  }

  static Future<void> save(
      GlobalKey<FormState> formKey1,
      GlobalKey<FormState> formKey2,
      Color color,
      String displayName,
      String ssid,
      String password,
      String ip,
      FirebaseUser user) async {

    if (isValid(formKey1, formKey2)) {
      if(ssid != '') {
        await http.get('http://' + ip + '/Wlan-Data.php?ssid=' + ssid);
      }
      if(password != '') {
        await http.get('http://' + ip + '/Wlan-Data.php?password=' + password);
      }

      ThingsFromFirestore.saveBeehiveScaleChanges(
          displayName, color.value.toString(), ip, user.uid);
    }
  }

  static Future<void> deleteBeehiveScale(String ip, FirebaseUser user) async {
    await http.get('http://' + ip + '/deleteWlanData');
    ThingsFromFirestore.deleteBeehiveScale(ip, user.uid);
  }

}
