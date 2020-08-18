import 'package:flutter/material.dart';
import 'package:stockwaage_app/util/FirestoreThings.dart';

class LastValueCard extends StatefulWidget {
  final bool isOutside;
  final String collectionName;

  LastValueCard({this.isOutside = false, @required this.collectionName});

  @override
  _LastValueCardState createState() => _LastValueCardState();
}

class _LastValueCardState extends State<LastValueCard> {
  String temperature1 = '-';
  String temperature2 = '-';
  String humidity1 = '-';
  String humidity2 = '-';
  String weight = '-';

  @override
  void initState() {
    ThingsFromFirestore.subscribe(getThingsFromFirestore);
  }

  void getThingsFromFirestore() async {
    ValuePairs values = await ThingsFromFirestore.getLastValues(widget.collectionName);
    if(values == null) {
      return;
    }

    setState(() {
      temperature1 = values.temperature1.toString();
      temperature2 = values.temperature2.toString();
      humidity1 = values.humidity1.toString();
      humidity2 = values.humidity2.toString();
      weight = values.weight.toString();
    });
  }

  @override
  void dispose() {
    super.dispose();
    ThingsFromFirestore.unsubscribe(getThingsFromFirestore);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 30, right: 30),
      padding: EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 5),
            child: Text(
              widget.isOutside ? 'Außerhalb' : 'Im Stock',
              style: TextStyle(
                fontFamily: 'segoe ui',
                fontSize: 21,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                color: Color(0xff483F3F),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10),
            width: double.infinity,
            height: 1.5,
            color: Color(0xff00751B),
          ),
          !widget.isOutside
              ? SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ValuePlusUnit(
                        value: widget.isOutside ? temperature2 : temperature1,
                        unit: '°C',
                      ),
                      SizedBox(
                        width: 25,
                      ),
                      ValuePlusUnit(
                          value: widget.isOutside ? humidity2 : humidity1,
                          unit: '%'),
                      !widget.isOutside
                          ? SizedBox(
                              width: 25,
                            )
                          : Text(''),
                      !widget.isOutside
                          ? ValuePlusUnit(
                              value: weight,
                              unit: 'kg',
                            )
                          : Text(''),
                    ],
                  ),
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ValuePlusUnit(
                      value: widget.isOutside ? temperature2 : temperature1,
                      unit: '°C',
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    ValuePlusUnit(
                        value: widget.isOutside ? humidity2 : humidity1,
                        unit: '%'),
                    !widget.isOutside
                        ? SizedBox(
                            width: 25,
                          )
                        : Text(''),
                    !widget.isOutside
                        ? ValuePlusUnit(
                            value: weight,
                            unit: 'kg',
                          )
                        : Text(''),
                  ],
                ),
        ],
      ),
    );
  }
}

class ValuePlusUnit extends StatelessWidget {
  final String value;
  final String unit;

  ValuePlusUnit({@required this.value, @required this.unit});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(
          value,
          style: TextStyle(
            fontFamily: 'century gothic',
            fontWeight: FontWeight.bold,
            fontSize: 35,
            color: Color(0xff3A3A3A),
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 5),
          child: Text(
            unit,
            style: TextStyle(
              fontFamily: 'century gothic',
              fontSize: 20,
              color: Color(0xff7E7E7E),
            ),
          ),
        ),
      ],
    );
  }
}
