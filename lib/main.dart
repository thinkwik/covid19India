import 'dart:core';

import 'package:covid19app/model/screenSwitcher.dart';
import 'package:covid19app/screens/HomeScreen.dart';
import 'package:covid19app/screens/stateDetails.dart';
import 'package:covid19app/utils/str.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MaterialApp(
    title: STR.appName,
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    initialRoute: "/",
    routes: {
      "/": (context) => MultiProvider(providers: [
            ChangeNotifierProvider<ScreenBloc>(create: (_) => ScreenBloc()),
            ChangeNotifierProvider<ChartBloc>(create: (_) => ChartBloc()),
            ChangeNotifierProvider<ChartUpdateBloc>(create: (_) => ChartUpdateBloc()),
          ], child: HomeScreen()),
      "/home": (context) => HomeScreen(),
      "/details": (context) => StateWiseDetail()
    },
  ));
}
