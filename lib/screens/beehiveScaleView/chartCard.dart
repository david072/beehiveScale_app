import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:stockwaage_app/util/FirestoreThings.dart';

import 'dart:math' as math;

class ChartCard extends StatefulWidget {
  final String collectionName;

  ChartCard({this.collectionName});

  @override
  _ChartCardState createState() => _ChartCardState();
}

class _ChartCardState extends State<ChartCard> {
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  bool showAvg = false;
  int radioBtnsIndex = 0;

  List<double> weightsMinMax = new List<double>();
  List<ChartValue> weightsSortedByTimestamp = new List<ChartValue>();

  int tMin;
  int tMax;

  @override
  void initState() {
    super.initState();

    tMin = DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, DateTime.now().hour + 1)
        .subtract(Duration(days: 1))
        .toUtc()
        .millisecondsSinceEpoch;
    tMax = DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, DateTime.now().hour + 1)
        .toUtc()
        .millisecondsSinceEpoch;

    ThingsFromFirestore.subscribe(getFirestoreData);
  }

  @override
  void dispose() {
    super.dispose();
    ThingsFromFirestore.unsubscribe(getFirestoreData);
  }

  Future<void> getFirestoreData() async {
    List<ChartValue> _weightsSortedByTimestamp =
        await ThingsFromFirestore.getChartValuesSortedByTimestamp(
            widget.collectionName, radioBtnsIndex, tMin);

    double valueMin = 10000;
    double valueMax = -10000;
    for (ChartValue cv in _weightsSortedByTimestamp) {
      if (cv.getValue() < valueMin) valueMin = cv.getValue();
      if (cv.getValue() > valueMax) valueMax = cv.getValue();
    }

    weightsMinMax.add(valueMin);
    weightsMinMax.add(valueMax);

    setState(() {
      weightsSortedByTimestamp = _weightsSortedByTimestamp != null
          ? _weightsSortedByTimestamp
          : weightsSortedByTimestamp;
    });
  }

  double getXSize() {
    double result;
    if (radioBtnsIndex == 0)
      result = 24;
    else if (radioBtnsIndex == 1)
      result = 7;
    else if (radioBtnsIndex == 2) result = 30;

    return result;
  }

  double getYSize() {
    return 3;
  }

  String bottomTitles(double value) {
    if (radioBtnsIndex == 0) {
      int startHour =
          (DateTime.fromMillisecondsSinceEpoch(tMin).hour + value.toInt()) % 3;
      if (startHour == 0) {
        return ((DateTime.fromMillisecondsSinceEpoch(tMin).hour + value) % 24)
            .toInt()
            .toString();
      } else {
        return '';
      }
    } else if (radioBtnsIndex == 1) {
      // DateTime now = DateTime.now().subtract(Duration(days: 6 - value.toInt()));
      DateTime now = DateTime.fromMillisecondsSinceEpoch(tMin)
          .add(Duration(days: value.toInt()));
      switch (now.weekday) {
        case 1:
          return 'Mo';
        case 2:
          return 'Di';
        case 3:
          return 'Mi';
        case 4:
          return 'Do';
        case 5:
          return 'Fr';
        case 6:
          return 'Sa';
        case 7:
          return 'So';
      }
    } else if (radioBtnsIndex == 2) {
      /*DateTime now =
          DateTime.now().subtract(Duration(days: 29 - value.toInt()));*/
      DateTime now = DateTime.fromMillisecondsSinceEpoch(tMin)
          .add(Duration(days: value.toInt()));

      if (now.weekday == 1) {
        return 'Mo\n' + now.day.toString() + '.';
      } else {
        return '';
      }
    }

    return '';
  }

  String sideTitles(double value) {
    if (weightsMinMax.isEmpty) return '';

    if (value == 0) {
      return weightsMinMax[0].toStringAsFixed(1);
    } else if (value == 1) {
      return (weightsMinMax[0] +
              (weightsMinMax[weightsMinMax.length - 1] - weightsMinMax[0]) / 2)
          .toStringAsFixed(1);
    } else if (value == 2) {
      return weightsMinMax[weightsMinMax.length - 1].toStringAsFixed(1);
    } else {
      return '';
    }
  }

  List<FlSpot> getSpots() {
    if (weightsSortedByTimestamp.isEmpty || weightsMinMax.isEmpty) {
      return [
        FlSpot(0, 3.44),
        FlSpot(2.6, 3.44),
        FlSpot(4.9, 3.44),
        FlSpot(6.8, 3.44),
        FlSpot(8, 3.44),
        FlSpot(9.5, 3.44),
        FlSpot(11, 3.44),
      ];
    }

    List<FlSpot> result = new List<FlSpot>();
    for (ChartValue cv in weightsSortedByTimestamp) {
      FlSpot flSpot = FlSpot(
          ((cv.getTimestamp() - tMin) / (tMax - tMin)) * getXSize(),
          ((cv.getValue() - weightsMinMax[0]) /
              (weightsMinMax[weightsMinMax.length - 1] -
                  weightsMinMax[0])) *
              getYSize());

      result.add(flSpot);
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 30, right: 30),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1.70,
            child: Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(18),
                  ),
                  color: Color(0xff232d37)),
              child: Padding(
                padding: const EdgeInsets.only(
                    right: 18.0, left: 12.0, top: 24, bottom: 12),
                child: LineChart(
                  showAvg ? avgData() : mainData(),
                ),
              ),
            ),
          ),
          Row(
            children: <Widget>[
              /*SizedBox(
                width: 60,
                height: 34,
                child: FlatButton(
                  onPressed: () {
                    setState(() {
                      showAvg = !showAvg;
                    });
                  },
                  child: Text(
                    'avg',
                    style: TextStyle(
                        fontSize: 12,
                        color: showAvg
                            ? Colors.white.withOpacity(0.5)
                            : Colors.white),
                  ),
                ),
              ),*/
              SizedBox(
                width: 60,
                height: 34,
                child: FlatButton(
                  onPressed: () {
                    setState(() {
                      radioBtnsIndex = 0;
                    });
                    tMin = DateTime(DateTime.now().year, DateTime.now().month,
                            DateTime.now().day, DateTime.now().hour + 1)
                        .subtract(Duration(days: 1))
                        .toUtc()
                        .millisecondsSinceEpoch;
                    tMax = DateTime(DateTime.now().year, DateTime.now().month,
                            DateTime.now().day, DateTime.now().hour + 1)
                        .toUtc()
                        .millisecondsSinceEpoch;
                    getFirestoreData();
                  },
                  child: Text(
                    'Tag',
                    style: TextStyle(
                        fontSize: 12,
                        color: radioBtnsIndex == 0
                            ? Color(0xff00751B)
                            : Colors.white),
                  ),
                ),
              ),
              SizedBox(
                width: 70,
                height: 34,
                child: FlatButton(
                  onPressed: () {
                    setState(() {
                      radioBtnsIndex = 1;
                    });
                    tMin = DateTime(DateTime.now().year, DateTime.now().month,
                            DateTime.now().day, 24)
                        .subtract(Duration(days: 7))
                        .toUtc()
                        .millisecondsSinceEpoch;
                    tMax = DateTime(DateTime.now().year, DateTime.now().month,
                            DateTime.now().day, 24)
                        .toUtc()
                        .millisecondsSinceEpoch;
                    getFirestoreData();
                  },
                  child: Text(
                    'Woche',
                    style: TextStyle(
                        fontSize: 12,
                        color: radioBtnsIndex == 1
                            ? Color(0xff00751B)
                            : Colors.white),
                  ),
                ),
              ),
              SizedBox(
                width: 70,
                height: 34,
                child: FlatButton(
                  onPressed: () {
                    setState(() {
                      radioBtnsIndex = 2;
                    });
                    tMin = DateTime(DateTime.now().year, DateTime.now().month,
                            DateTime.now().day, 24)
                        .subtract(Duration(days: 30))
                        .toUtc()
                        .millisecondsSinceEpoch;
                    tMax = DateTime(DateTime.now().year, DateTime.now().month,
                            DateTime.now().day, 24)
                        .toUtc()
                        .millisecondsSinceEpoch;
                    getFirestoreData();
                  },
                  child: Text(
                    'Monat',
                    style: TextStyle(
                        fontSize: 12,
                        color: radioBtnsIndex == 2
                            ? Color(0xff00751B)
                            : Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          textStyle: const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 13),
          getTitles: (value) {
            return bottomTitles(value);
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          getTitles: (value) {
            return sideTitles(value);
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: getXSize(),
      minY: 0,
      maxY: getYSize(),
      lineBarsData: [
        LineChartBarData(
          spots: getSpots(),
          isCurved: true,
          colors: gradientColors,
          barWidth: 1,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors:
                gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }

  LineChartData avgData() {
    return LineChartData(
      lineTouchData: LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          textStyle: const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 16),
          getTitles: (value) {
            switch (value.toInt()) {
              case 2:
                return 'MAR';
              case 5:
                return 'JUN';
              case 8:
                return 'SEP';
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '10k';
              case 3:
                return '30k';
              case 5:
                return '50k';
            }
            return '';
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, 3.44),
            FlSpot(2.6, 3.44),
            FlSpot(4.9, 3.44),
            FlSpot(6.8, 3.44),
            FlSpot(8, 3.44),
            FlSpot(9.5, 3.44),
            FlSpot(11, 3.44),
          ],
          isCurved: true,
          colors: [
            ColorTween(begin: gradientColors[0], end: gradientColors[1])
                .lerp(0.2),
            ColorTween(begin: gradientColors[0], end: gradientColors[1])
                .lerp(0.2),
          ],
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(show: true, colors: [
            ColorTween(begin: gradientColors[0], end: gradientColors[1])
                .lerp(0.2)
                .withOpacity(0.1),
            ColorTween(begin: gradientColors[0], end: gradientColors[1])
                .lerp(0.2)
                .withOpacity(0.1),
          ]),
        ),
      ],
    );
  }
}
