import 'dart:core';

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
    initialRoute: "/",
    routes: {
      "/": (context) => MyApp(),
      "/details": (context) => StateWiseDetail()
    },
  ));
}
