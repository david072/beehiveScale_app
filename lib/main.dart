import 'package:flutter/material.dart';
import 'package:stockwaage_app/screens/login/login.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData.light(),
    home: Login(),
  ));
}