import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stockwaage_app/screens/home/HomeDrawer.dart';
import 'package:stockwaage_app/screens/login/login.dart';

HomeDrawer hd = new HomeDrawer();

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData.light(),
    home: Login(shouldCheckAlreadyLoggedIn: true,),
  ));
}