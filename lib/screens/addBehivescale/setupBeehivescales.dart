import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_ip/get_ip.dart';
import 'package:http/http.dart' as http;
import 'package:stockwaage_app/screens/addBehivescale/beehivesSetupItem.dart';
import 'package:stockwaage_app/screens/home/HomeDrawer.dart';
import 'package:stockwaage_app/util/FirestoreThings.dart';
import 'package:stockwaage_app/util/customEnumeration.dart';

class SetupBeehivescales extends StatefulWidget {
  @override
  _SetupBeehivescalesState createState() => _SetupBeehivescalesState();
}

class _SetupBeehivescalesState extends State<SetupBeehivescales> {
  String ssid = '';
  String password = '';

  bool pressed = false;
  FirebaseUser user;

  final GlobalKey formKey = new GlobalKey<FormState>();

  BeehiveScaleSetupItem item;

  @override
  void initState() {
    super.initState();
    getUser();
    item = new BeehiveScaleSetupItem(
      index: 1,
    );
  }

  Future<void> getUser() async {
    user = await FirebaseAuth.instance.currentUser();
  }

  Future<void> setPressed() async {
    bool b = await ExternalClass.send(ssid, password, formKey);
    if (b) {
      setState(() {
        pressed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 40,
              width: double.infinity,
            ),
            Text(
              'Stockwaage hinzufügen',
              style: TextStyle(
                fontFamily: 'bahnschrift',
                fontWeight: FontWeight.bold,
                fontSize: 32,
                color: Color(0xff707070),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              width: 88,
              height: 2,
              color: Color(0xff3B3B3B),
            ),
            Container(
              margin: EdgeInsets.only(top: 50),
              padding: EdgeInsets.all(10),
              width: size.width - 80,
              decoration: BoxDecoration(
                  color: Color(0xffAEAEAE),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 3),
                      blurRadius: 7,
                      spreadRadius: 5,
                      color: Colors.grey.withOpacity(0.5),
                    )
                  ]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Text(
                      'Schritt 3:',
                      style: TextStyle(
                        fontFamily: 'segoe ui semibold',
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      'Die Stockwaagen\neinrichten',
                      style: TextStyle(
                        fontFamily: 'segoe ui',
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Color(0xff707070),
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 30, right: 30),
                    child: TextFormField(
                      onChanged: (String newSSID) => setState(() {
                        ssid = newSSID;
                      }),
                      validator: (input) {
                        if (input.isEmpty) {
                          return 'Bitte gib den Namen deines WLANs an.';
                        }

                        return null;
                      },
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
                    margin: EdgeInsets.only(
                        left: 30, right: 30, top: 10, bottom: 30),
                    child: TextFormField(
                      onChanged: (String newPassword) => setState(() {
                        password = newPassword;
                      }),
                      validator: (input) {
                        if (input.isEmpty) {
                          return 'Bitte gib das Passwort deines WLANs an.';
                        }

                        return null;
                      },
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
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 30, right: 30),
              child: item.getWidget(),
            ),
            pressed
                ? Container(
                    margin: EdgeInsets.only(left: 30, right: 30),
                    child: CustomEnumerationItem(
                      text:
                          'Bitte verbinde dich jetzt wieder mit dem normalen Wlan.',
                    ),
                  )
                : Text(''),
            Container(
              height: 150,
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
                                    'Abbrechen',
                                    style: TextStyle(
                                      fontFamily: 'bahnschrift',
                                      fontSize: 20,
                                      color: Color(0xff707070),
                                    ),
                                  ),
                                ],
                              ),
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeDrawer(
                                            user: user,
                                          ))),
                            ),
                            SizedBox(
                              width: size.width - 40 * 7.8,
                            ),
                            MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(200),
                                  side: BorderSide(
                                      color: Color(0xff008F26), width: 2.5)),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    !pressed ? 'Weiter' : 'Okay',
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
                              onPressed: () => !pressed
                                  ? {
                                      setPressed(),
                                    }
                                  : ExternalClass.continueToHome(context,
                                      item.getName(), item.getColorAsInt()),
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
  static String bhSIP = '';
  static String espName = '';

  static Future<bool> send(
      String ssid, String password, GlobalKey<FormState> formKey) async {
    final formState = formKey.currentState;
    if (formState.validate()) {
      String ownIP = await GetIp.ipAddress;
      List<String> ipParts = ownIP.split('.');
      String beehiveScaleIP =
          ipParts[0] + '.' + ipParts[1] + '.' + ipParts[2] + '.1';
      bhSIP = beehiveScaleIP;
      await http.get('http://' +
          beehiveScaleIP +
          '/Wlan-Data.php?ssid=' +
          ssid +
          '&password=' +
          password);
      var res = await http.get('http://' + beehiveScaleIP + '/GetEspName');
      espName = res.body;

      return true;
    }

    return false;
  }

  static Future<void> continueToHome(
      BuildContext ctx, String displayName, String color) async {
    print(bhSIP);
    //http.Response response = await getWlanData();
    print('Get wlan data request...');
    getWlanData().then((response) {
      print('Request success');
      if (response == null) {
        print('Response was null!');
        return;
      }

      print(response.body);
      String ip = response.body;

      print('Sending beehivescale data');
      FirebaseUser user;
      FirebaseAuth.instance.currentUser().then((value) {
        print('Got user');
        user = value;

        ThingsFromFirestore.saveBeehiveScale(
            displayName, ip, color, user, espName);
        print('Done');

        Navigator.push(
          ctx,
          MaterialPageRoute(
            builder: (context) => HomeDrawer(
              user: user,
            ),
          ),
        );
      });
    });
  }

  static Future<http.Response> getWlanData() async {
    var response;
    int counter = 0;
    while (counter <= 5) {
      response = await http.get('http://' + bhSIP + '/getWlanStatus');
      if (response != null) break;

      counter = counter + 1;
      print(counter);
      await Future.delayed(const Duration(milliseconds: 500));
    }

    if (counter >= 5) return null;
    return response;
  }
}
