import 'package:flutter/material.dart';
import 'package:stockwaage_app/util/FirestoreThings.dart';

class MinMaxCard extends StatefulWidget {
  final String collectionName;

  MinMaxCard({this.collectionName});

  @override
  _MinMaxCardState createState() => _MinMaxCardState();
}

class _MinMaxCardState extends State<MinMaxCard> {
  int radioBtnIndex = 0;

  ValuePairs minValues = new ValuePairs();
  ValuePairs maxValues = new ValuePairs();

  @override
  void initState() {
    super.initState();
    ThingsFromFirestore.subscribe(getThingsFromFirestore);
  }

  void getThingsFromFirestore() async {
    List<ValuePairs> minMaxValues = await ThingsFromFirestore.getMinMaxValues(widget.collectionName, radioBtnIndex);

    setState(() {
      minValues = minMaxValues[0];
      maxValues = minMaxValues[1];
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
                    'Stunde',
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
                    })
                  },
                ),
                SizedBox(
                  width: 8,
                ),
                MaterialButton(
                  padding: EdgeInsets.all(5),
                  child: Text(
                    'Monat',
                    style: TextStyle(color: Colors.white),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(200),
                  ),
                  color:
                      radioBtnIndex == 2 ? Color(0xff00751B) : Color(0xffAEAEAE),
                  onPressed: () => {
                    setState(() {
                      radioBtnIndex = 2;
                      getThingsFromFirestore();
                    })
                  },
                ),
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
              'Im Stock',
              style: TextStyle(
                fontSize: 21,
                fontFamily: 'segoe ui',
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                color: Color(0xff483F3F),
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                MinMaxValue(value: minValues.getTemperature1() == null ? '-' : minValues.getTemperature1().toString(), unit: '°C'),
                SizedBox(width: 25,),
                MinMaxValue(value: maxValues.getTemperature1() == null ? '-' : maxValues.getTemperature1().toString(), unit: '°C', isMax: true,),
              ],
            ),
          ),
          SizedBox(height: 10,),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                MinMaxValue(value: minValues.getHumidity1() == null ? '-' : minValues.getHumidity1().toString(), unit: '%',),
                SizedBox(width: 25,),
                MinMaxValue(value: maxValues.getHumidity1() == null ? '-' : maxValues.getHumidity1().toString(), unit: '%', isMax: true,),
              ],
            ),
          ),
          SizedBox(height: 10,),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                MinMaxValue(value: minValues.getWeight() == null? '-' : minValues.getWeight().toString(), unit: 'kg',),
                SizedBox(width: 25,),
                MinMaxValue(value: maxValues.getWeight() == null ? '-' : maxValues.getWeight().toString(), unit: 'kg', isMax: true,),
              ],
            ),
          ),
          SizedBox(height: 25,),
          Container(
            margin: EdgeInsets.only(left: 5),
            child: Text(
              'Außerhalb',
              style: TextStyle(
                fontSize: 21,
                fontFamily: 'segoe ui',
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                color: Color(0xff483F3F),
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                MinMaxValue(value: minValues.getTemperature2() == null ? '-' : minValues.getTemperature2().toString(), unit: '°C'),
                SizedBox(width: 25,),
                MinMaxValue(value: maxValues.getTemperature2() == null ? '-' : maxValues.getTemperature2().toString(), unit: '°C', isMax: true,),
              ],
            ),
          ),
          SizedBox(height: 10,),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                MinMaxValue(value: minValues.getHumidity2() == null ? '-' : minValues.getHumidity2().toString(), unit: '%',),
                SizedBox(width: 25,),
                MinMaxValue(value: maxValues.getHumidity2() == null ? '-' : maxValues.getHumidity2().toString(), unit: '%', isMax: true,),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class MinMaxValue extends StatelessWidget {
  final bool isMax;
  final String value;
  final String unit;

  MinMaxValue({this.isMax = false, @required this.value, @required this.unit});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(bottom: 5),
          child: Text(
            !isMax ? 'Min' : 'Max',
            style: TextStyle(
              fontFamily: 'century gothic',
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xff5A5A5A),
            ),
          ),
        ),
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
