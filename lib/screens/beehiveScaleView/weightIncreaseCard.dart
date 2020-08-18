import 'package:flutter/material.dart';
import 'package:stockwaage_app/util/FirestoreThings.dart';

class WeightIncreaseCard extends StatefulWidget {
  final String collectionID;

  WeightIncreaseCard({@required this.collectionID});

  @override
  _WeightIncreaseCardState createState() => _WeightIncreaseCardState();
}

class _WeightIncreaseCardState extends State<WeightIncreaseCard> {
  int radioBtnIndex = 0;
  String userInput;

  String dropdownValue = 'Tage';

  double weightIncrease;

  @override
  void initState() {
    super.initState();
    ThingsFromFirestore.subscribe(getThingsFromFirestore);
  }

  void getThingsFromFirestore() async {
    if((userInput == null || userInput == '') && radioBtnIndex == 2) return;

    int _userInput;
    if(userInput != null) _userInput = int.parse(userInput);

    double weightIncrease = await ThingsFromFirestore.getWeightGain(widget.collectionID, radioBtnIndex, _userInput, dropdownValue);
    setState(() {
      this.weightIncrease = weightIncrease;
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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                MaterialButton(
                  child: Text(
                    'Tag',
                    style: TextStyle(color: Colors.white),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(200),
                  ),
                  color:
                      radioBtnIndex == 0 ? Color(0xff00751B) : Color(0xffAEAEAE),
                  onPressed: () => {
                    setState(() {
                      radioBtnIndex = 0;
                      getThingsFromFirestore();
                    })
                  },
                ),
                SizedBox(
                  width: 8,
                ),
                MaterialButton(
                  child: Text(
                    'Woche',
                    style: TextStyle(color: Colors.white),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(200),
                  ),
                  color:
                      radioBtnIndex == 1 ? Color(0xff00751B) : Color(0xffAEAEAE),
                  onPressed: () => {
                    setState(() {
                      radioBtnIndex = 1;
                      getThingsFromFirestore();
                    }),
                  },
                ),
                SizedBox(
                  width: 8,
                ),
                MaterialButton(
                  padding: EdgeInsets.all(5),
                  child: Container(
                    width: 50,
                    height: 20,
                    child: TextField(
                      textAlign: TextAlign.end,
                      keyboardType: TextInputType.number,
                      onEditingComplete: () => {
                        getThingsFromFirestore(),
                      },
                      onChanged: (String newValue) => {
                        setState(() {
                          userInput = newValue;
                        })
                      },
                      onTap: () => setState(() {
                        radioBtnIndex = 2;
                      }),
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(200),
                  ),
                  color:
                      radioBtnIndex == 2 ? Color(0xff00751B) : Color(0xffAEAEAE),
                  onPressed: () => {
                    setState(() {
                      radioBtnIndex = 2;
                    })
                  },
                ),
                SizedBox(
                  width: 8,
                ),
                DropdownButton<String>(
                    value: dropdownValue,
                    onChanged: (String newValue) {
                      setState(() {
                        dropdownValue = newValue;
                      });
                    },
                    items: <String>['Tage', 'Wochen', 'Monate']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList())
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10, top: 5),
            width: double.infinity,
            height: 1.5,
            color: Color(0xff00751B),
          ),
          Container(
            margin: EdgeInsets.only(left: 5),
            child: Text(
              'Gewichtszunahme',
              style: TextStyle(
                fontSize: 21,
                fontFamily: 'segoe ui',
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                color: Color(0xff483F3F),
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Value(
                value: weightIncrease == null ? '-' : weightIncrease.toStringAsFixed(2),
                unit: 'kg',
              ),
            ],
          )
        ],
      ),
    );
  }
}

class Value extends StatelessWidget {
  final String value;
  final String unit;

  Value({@required this.value, @required this.unit});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(
          value,
          style: TextStyle(
            fontFamily: 'century gothic',
            fontSize: 35,
            fontWeight: FontWeight.bold,
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
