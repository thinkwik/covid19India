import 'dart:core';

import 'package:covid19app/screens/HomeScreen.dart';
import 'package:covid19app/screens/bottomNavigation.dart';
import 'package:covid19app/screens/myApp.dart';
import 'package:covid19app/screens/stateDetails.dart';
import 'package:covid19app/utils/str.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: STR.appName,
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    initialRoute: "/home",
    routes: {
      "/": (context) => NavigationScreen(),
      "/home": (context) => HomeScreen(),
      "/details": (context) => StateWiseDetail()
    },
  ));
}
