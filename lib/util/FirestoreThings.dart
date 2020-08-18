import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThingsFromFirestore {
  static final firestoreInstance = Firestore.instance;
  static Timer timer;

  static List<NamedList> values = new List(3);
  static List<String> IDs = ['Stockwaage_1', 'Stockwaage_2', 'Stockwaage_3'];
  static List<Function> subscribedFunctions = new List<Function>();

  static void init() {
    values[0] = new NamedList(collectionName: "Stockwaage"); // IDS[0]
    values[1] = new NamedList(collectionName: IDs[1]);
    values[2] = new NamedList(collectionName: IDs[2]);
  }

  static void subscribe(Function func) {
    subscribedFunctions.add(func);
    func();
  }

  static void unsubscribe(Function func) {
    if (subscribedFunctions.contains(func)) {
      subscribedFunctions.remove(func);
    } else {
      throw Exception(
          '[Beehivescale-App -> Firebase/Firestore] Tried to remove never subscribed function!');
    }
  }

  static void startLookingForValues() {
    timer = Timer.periodic(Duration(minutes: 5), (timer) {
      for (Function func in subscribedFunctions) {
        func();
      }
    });
  }

  static void cancelLookingForValues() {
    timer.cancel();
  }

  static Future<ValuePairs> getLastValues(String collectionID) async {
    List<ValuePairs> result = new List<ValuePairs>();
    QuerySnapshot snapshot = await firestoreInstance
        .collection(collectionID)
        .orderBy('timestamp', descending: true)
        .limit(1)
        .getDocuments();
    snapshot.documents.forEach((element) {
      ValuePairs valuePairs = valuePairsFromDocumentSnapshot(element);
      result.add(valuePairs);
    });

    return result[0];
  }

  static Future<List<ChartValue>> getChartValuesSortedByTimestamp(
      String collectionID, int order, int tMin) async {
    List<ChartValue> result = List<ChartValue>();
    QuerySnapshot snapshot = await firestoreInstance
        .collection(collectionID)
        .where('timestamp', isGreaterThan: tMin)
        .orderBy('timestamp')
        .getDocuments();

    snapshot.documents.forEach((element) {
      ChartValue cv = ChartValue(
          value: double.parse(element.data['weight']),
          timestamp: element.data['timestamp']);
      result.add(cv);
    });

    return result;
  }

  static Future<List<ValuePairs>> getMinMaxValues(
      String collectionID, int order) async {
    int x;
    if (order == 0) {
      x = DateTime.now()
          .subtract(Duration(days: 1))
          .toUtc()
          .millisecondsSinceEpoch;
    } else if (order == 1) {
      x = DateTime.now()
          .subtract(Duration(hours: 1))
          .toUtc()
          .millisecondsSinceEpoch;
    } else if (order == 2) {
      x = DateTime.now()
          .subtract(Duration(days: 30))
          .toUtc()
          .millisecondsSinceEpoch;
    }

    QuerySnapshot snapshot = await firestoreInstance
        .collection(collectionID)
        .where('timestamp', isGreaterThan: x)
        .getDocuments();

    return determineMinMaxValues(snapshot);
  }

  static Future<double> getWeightGain(String collectionID, int order,
      int userInput, String dropdownValue) async {
    int x;
    if (order == 0) {
      x = DateTime.now()
          .subtract(Duration(days: 1))
          .toUtc()
          .millisecondsSinceEpoch;
    } else if (order == 1) {
      x = DateTime.now()
          .subtract(Duration(days: 7))
          .toUtc()
          .millisecondsSinceEpoch;
    } else if (order == 2) {
      if (dropdownValue == 'Tage') {
        x = DateTime.now()
            .subtract(Duration(days: userInput))
            .toUtc()
            .millisecondsSinceEpoch;
      } else if (dropdownValue == 'Wochen') {
        x = DateTime.now()
            .subtract(Duration(days: userInput * 7))
            .toUtc()
            .millisecondsSinceEpoch;
      } else if (dropdownValue == 'Monate') {
        x = DateTime.now()
            .subtract(Duration(days: userInput * 30))
            .toUtc()
            .millisecondsSinceEpoch;
      }
    }

    QuerySnapshot snapshot = await firestoreInstance
        .collection(collectionID)
        .where('timestamp', isGreaterThan: x)
        .getDocuments();
    List<ValuePairs> minPlusMax = determineMinMaxValues(snapshot);

    if (minPlusMax[1].getWeight() == null)
      return null;
    else if (minPlusMax[0].getWeight() == null) return null;

    double result = minPlusMax[1].getWeight() - minPlusMax[0].getWeight();
    return result;
  }

  static List<ValuePairs> determineMinMaxValues(QuerySnapshot snapshot) {
    ValuePairs minValues = new ValuePairs();
    ValuePairs maxValues = new ValuePairs();

    snapshot.documents.forEach((element) {
      minValues.setTemperature1(getSmallerValue(
          double.parse(element.data['temperature1']),
          minValues.getTemperature1() == null
              ? 1000
              : minValues.getTemperature1()));
      minValues.setTemperature2(getSmallerValue(
          double.parse(element.data['temperature2']),
          minValues.getTemperature2() == null
              ? 1000
              : minValues.getTemperature2()));
      minValues.setHumidity1(getSmallerValue(
          double.parse(element.data['humidity1']),
          minValues.getHumidity1() == null ? 1000 : minValues.getHumidity1()));
      minValues.setHumidity2(getSmallerValue(
          double.parse(element.data['humidity2']),
          minValues.getHumidity2() == null ? 1000 : minValues.getHumidity2()));
      minValues.setWeight(getSmallerValue(double.parse(element.data['weight']),
          minValues.getWeight() == null ? 1000 : minValues.getWeight()));

      maxValues.setTemperature1(getBiggerValue(
          double.parse(element.data['temperature1']),
          maxValues.getTemperature1() == null
              ? -1000
              : maxValues.getTemperature1()));
      maxValues.setTemperature2(getBiggerValue(
          double.parse(element.data['temperature2']),
          maxValues.getTemperature2() == null
              ? -1000
              : maxValues.getTemperature2()));
      maxValues.setHumidity1(getBiggerValue(
          double.parse(element.data['humidity1']),
          maxValues.getHumidity1() == null ? -1000 : maxValues.getHumidity1()));
      maxValues.setHumidity2(getBiggerValue(
          double.parse(element.data['humidity2']),
          maxValues.getHumidity2() == null ? -1000 : maxValues.getHumidity2()));
      maxValues.setWeight(getBiggerValue(double.parse(element.data['weight']),
          maxValues.getWeight() == null ? -1000 : maxValues.getWeight()));
    });

    return [minValues, maxValues];
  }

  static double getSmallerValue(double v1, double v2) => v1 < v2 ? v1 : v2;
  static double getBiggerValue(double v1, double v2) => v1 > v2 ? v1 : v2;

  static ValuePairs valuePairsFromDocumentSnapshot(DocumentSnapshot dSnapshot) {
    double temp1 = double.parse(dSnapshot.data['temperature1']);
    double temp2 = double.parse(dSnapshot.data['temperature2']);
    double hum1 = double.parse(dSnapshot.data['humidity1']);
    double hum2 = double.parse(dSnapshot.data['humidity2']);
    double weight = double.parse(dSnapshot.data['weight']);

    ValuePairs result = new ValuePairs(
        temperature1: temp1,
        temperature2: temp2,
        humidity1: hum1,
        humidity2: hum2,
        weight: weight);
    return result;
  }

  static Future<void> saveBeehiveScale(String displayName, String ip,
      String color, FirebaseUser user, String espName) async {
    Map<String, dynamic> map = {
      "displayName": displayName,
      "IP": ip,
      "color": color,
      "userUID": user.uid,
      "espName": espName
    };
    await firestoreInstance.collection("Stockwaagen").add(map);
  }

  static Future<List<BeehiveScaleItemInfo>> getBeehiveScalesForUser(
      FirebaseUser user) async {
    QuerySnapshot snapshot = await firestoreInstance
        .collection("Stockwaagen")
        .where('userUID', isEqualTo: user.uid)
        .getDocuments();

    List<BeehiveScaleItemInfo> beehiveScaleII =
        new List<BeehiveScaleItemInfo>();
    snapshot.documents.forEach((element) {
      BeehiveScaleItemInfo bsii = new BeehiveScaleItemInfo(
          displayName: element.data['displayName'],
          colorValue: int.parse(element.data['color']),
          ip: element.data['IP'],
          espName: element.data['espName']);
      beehiveScaleII.add(bsii);
    });

    return beehiveScaleII;
  }

  static Future<void> saveBeehiveScaleChanges(
      String newDisplayName, String newColor, String ip, String userUID) async {

    if(newDisplayName == '' && newColor == '') return;

    QuerySnapshot snapshot = await firestoreInstance
        .collection('Stockwaagen')
        .where('userUID', isEqualTo: userUID)
        .getDocuments();
        snapshot.documents.forEach((element) {
          if (element.data['IP'] == ip) {
        firestoreInstance
            .collection('Stockwaagen')
            .document(element.documentID)
            .updateData({
          'displayName': newDisplayName != '' ? newDisplayName : element.data['displayName'],
          'color': newColor != '' ? newColor : element.data['color'],
        });
      }
    });
  }

  static Future<void> deleteBeehiveScale(String ip, String userUID) async {
    QuerySnapshot snapshot = await firestoreInstance
        .collection('Stockwaagen')
        .where('userUID', isEqualTo: userUID)
        .getDocuments();
    snapshot.documents.forEach((element) {
      if (element.data['IP'] == ip) {
        firestoreInstance
            .collection('Stockwaagen')
            .document(element.documentID)
            .delete();
      }
    });
  }
}

class BeehiveScaleItemInfo {
  final String displayName;
  final int colorValue;
  final String ip;
  final String espName;

  BeehiveScaleItemInfo(
      {this.displayName, this.colorValue, this.ip, this.espName});

  String getDisplayName() => displayName;
  int getColorValue() => colorValue;
  String getIP() => ip;
  String getEspName() => espName;
}

class ChartValue {
  final double value;
  final int timestamp;

  ChartValue({this.value, this.timestamp});

  double getValue() => value;
  int getTimestamp() => timestamp;
}

class NamedList {
  List<ValuePairs> values = new List<ValuePairs>();
  String collectionName;

  NamedList({this.values, this.collectionName});

  List<ValuePairs> getValues() => values;
  String getCollectionName() => collectionName;

  void setValues(List<ValuePairs> newValues) => values = newValues;
  void setCollectionName(String newColName) => collectionName = newColName;
}

class ValuePairs {
  double temperature1;
  double temperature2;
  double humidity1;
  double humidity2;
  double weight;
  String datePlusTime;

  ValuePairs({
    this.temperature1,
    this.humidity1,
    this.temperature2,
    this.humidity2,
    this.weight,
    this.datePlusTime,
  });

  double getTemperature1() => temperature1;
  double getTemperature2() => temperature2;
  double getHumidity1() => humidity1;
  double getHumidity2() => humidity2;
  double getWeight() => weight;
  String getDatePlusTime() => datePlusTime;

  void setTemperature1(double newTemp) => temperature1 = newTemp;
  void setTemperature2(double newTemp) => temperature2 = newTemp;
  void setHumidity1(double newHum) => humidity1 = newHum;
  void setHumidity2(double newHum) => humidity2 = newHum;
  void setWeight(double newWeight) => weight = newWeight;
  void setDatePlusTime(String newDpT) => datePlusTime = newDpT;
}
