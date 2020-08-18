import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stockwaage_app/screens/addBehivescale/connectToBeehivescale.dart';
import 'package:stockwaage_app/screens/home/HomeDrawer.dart';
import 'package:stockwaage_app/util/customEnumeration.dart';

class PowerBeehiveScales extends StatelessWidget {
  FirebaseUser user;

  PowerBeehiveScales() {
    getUser();
  }

  Future<void> getUser() async {
    user = await FirebaseAuth.instance.currentUser();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
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
                    'Schritt 1:',
                    style: TextStyle(
                      fontFamily: 'segoe ui semibold',
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
                Flexible(
                  child: Text(
                    'Strom anschließen',
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
          Container(
            margin: EdgeInsets.only(top: 40),
            width: size.width - 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Bei mehreren Stockwaagen:',
                  style: TextStyle(
                    fontFamily: 'segoe ui semibold',
                    fontSize: 20,
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
                  padding: EdgeInsets.only(left: 30, top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CustomEnumerationItem(text: 'Zuerst eine Stockwaage mit dem Strom verbinden',),
                      CustomEnumerationItem(text: 'Nach kurzer Zeit die anderen Stockwaagen mit dem Strom verbinden', withPadding: true,),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
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
                                        builder: (context) => HomeDrawer(user: user,))),
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
                                      'Weiter',
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
                                onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ConnectToBeehivescale())),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          )
        ],
      ),
    );
  }
}
