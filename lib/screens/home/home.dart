import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stockwaage_app/screens/addBehivescale/powerBeehivescales.dart';
import 'package:stockwaage_app/screens/home/HomeDrawer.dart';
import 'package:stockwaage_app/screens/home/beehivescaleItem.dart';
import 'package:stockwaage_app/util/FirestoreThings.dart';

class Home {
  static List<BeehiveScaleItemInfo> beehiveScaleIIs =
      List<BeehiveScaleItemInfo>();

  static Future<void> getBeehiveScaleIIs(FirebaseUser user) async {
    beehiveScaleIIs = await ThingsFromFirestore.getBeehiveScalesForUser(user);
  }

  static Widget createBeehiveItem(BuildContext ctx, int i) {
    return BeehiveItem(
      name: beehiveScaleIIs[i].getDisplayName(),
      color: Color(beehiveScaleIIs[i].getColorValue()),
      ip: beehiveScaleIIs[i].getIP(),
      espName: beehiveScaleIIs[i].getEspName(),
    );
  }

  static Widget getHomePage(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 40,
            width: double.infinity,
          ),
          Container(
            margin: EdgeInsets.only(left: 15, bottom: 10),
            child: GestureDetector(
              child: Align(
                alignment: Alignment.topLeft,
                child: SvgPicture.asset('assets/icons/menu.svg'),
              ),
              onTap: () => {HomeDrawer.toggle()},
            ),
          ),
          Text(
            'Meine Stockwaagen',
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
            margin: EdgeInsets.only(left: 15, top: 30),
            child: Align(
              alignment: Alignment.topLeft,
              child: Container(
                width: 240,
                child: MaterialButton(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(200),
                  ),
                  color: Color(0xffAEAEAE),
                  child: Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(right: 5),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Stockwaage hinzufügen',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'segoe ui',
                            fontSize: 16),
                      ),
                    ],
                  ),
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PowerBeehiveScales())),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 40, right: 40),
              child: ListView.builder(
                itemCount: beehiveScaleIIs.length,
                itemBuilder: (BuildContext context, int index) =>
                    createBeehiveItem(context, index),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
