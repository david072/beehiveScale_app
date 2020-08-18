import 'package:flutter/material.dart';
import 'package:stockwaage_app/screens/beehiveScaleView/beehiveScaleSettings.dart';
import 'package:stockwaage_app/screens/beehiveScaleView/chartCard.dart';
import 'package:stockwaage_app/screens/beehiveScaleView/lastValueCard.dart';
import 'package:stockwaage_app/screens/beehiveScaleView/minMaxCard.dart';
import 'package:stockwaage_app/screens/beehiveScaleView/weightIncreaseCard.dart';
import 'package:stockwaage_app/util/FirestoreThings.dart';

import 'package:http/http.dart' as http;

class BeehiveScaleView extends StatefulWidget {
  final String stockwaageID;
  final String name;
  final String ip;

  BeehiveScaleView({
    this.stockwaageID,
    this.name,
    this.ip
  }) {
    ThingsFromFirestore.init();
    ThingsFromFirestore.startLookingForValues();
  }

  @override
  _BeehiveScaleViewState createState() => _BeehiveScaleViewState();
}

class _BeehiveScaleViewState extends State<BeehiveScaleView> {
  bool serviceEnabled = false;

  Future<void> toggleService() async {
    var result;
    try {
      result = await http.get('http://' + widget.ip + '/service');
    }
    catch(e) {
      print(e);
    }

    String body = result.body;
    print(body);
    if(body == '1') {
      await http.get('http://' + widget.ip + '/serviceOn');

      setState(() {
        serviceEnabled = true;
      });
    }
    else if(body == '0') {
      await http.get('http://' + widget.ip + '/serviceOff');

      setState(() {
        serviceEnabled = false;
      });
    }
  }

  Future<void> resetScale() async {
    await http.get('http://' + widget.ip + '/waageTare');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 180,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(0xff980101),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                  onPressed: () => {
                    ThingsFromFirestore.cancelLookingForValues(),
                    Navigator.pop(context)
                  },
                ),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 20),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        IconButton(
                          tooltip: 'Waage auf 0 setzen',
                          icon: Icon(
                            Icons.refresh,
                            color: Color(0xffFFFFFF),
                          ),
                          onPressed: () => {
                            showDialog(barrierDismissible: false, context: context, builder: (ctx) => AlertDialog(
                              title: Text('Waage zurücksetzen'),
                              content: Text('Möchtest du die Waage der Stockwaage wirklich auf 0 setzen (Tara)?'),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text('Tu es!'),
                                  onPressed: () {
                                    resetScale();
                                    Navigator.pop(context);
                                  },
                                ),
                                FlatButton(
                                  child: Text('Nein, bitte nicht!'),
                                  onPressed: () => Navigator.pop(context),
                                )
                              ],
                            ))
                          },
                        ),
                        IconButton(
                          tooltip: 'Daten senden An / Aus',
                          icon: Icon(
                            Icons.power_settings_new,
                            color: serviceEnabled ? Color(0xff00751B) : Color(0xffFFFFFF),
                          ),
                          onPressed: () => {
                            toggleService()
                          },
                        ),
                        IconButton(
                          tooltip: 'Einstellungen',
                          icon: Icon(
                            Icons.settings,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => BeehiveScaleSettings(ip: widget.ip,))),
                        ),
                      ],
                    )
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 30, top: 100),
                child: Text(
                  widget.name,
                  style: TextStyle(
                    fontFamily: 'bahnschrift',
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    color: Color(0xffD6D6D6),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 140, left: 30),
                width: 88,
                height: 2,
                color: Color(0xff656565),
              ),
            ],
          ),
          SizedBox(
            height: 50,
          ),
          Expanded(
            child: ListWithPadding(
              widgets: <Widget>[
                LastValueCard(
                  collectionName: widget.stockwaageID,
                ),
                LastValueCard(
                  isOutside: true,
                  collectionName: widget.stockwaageID,
                ),
                ChartCard(collectionName: widget.stockwaageID,),
                MinMaxCard(
                  collectionName: widget.stockwaageID,
                ),
                WeightIncreaseCard(
                  collectionID: widget.stockwaageID,
                ),
              ],
              padding: 22,
            ),
          ),
        ],
      ),
    );
  }
}

class ListWithPadding extends StatelessWidget {
  final List<Widget> widgets;
  final double padding;

  ListWithPadding({@required this.widgets, @required this.padding});

  List<Widget> createWidgetList() {
    List<Widget> result = new List<Widget>();
    for (Widget widget in widgets) {
      result.add(widget);
      result.add(new SizedBox(
        height: 20,
      ));
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: createWidgetList(),
    );
  }
}
