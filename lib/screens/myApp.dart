import 'dart:core';
import 'dart:ui';

import 'package:covid19app/items/statesItem.dart';
import 'package:covid19app/items/tableItems.dart';
import 'package:covid19app/model/tableData.dart';
import 'package:covid19app/network/api.dart';
import 'package:covid19app/utils/str.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

extension IndexedIterable<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T f(E e, int i)) {
    var i = 0;
    return this.map((e) => f(e, i++));
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  int total = 0;
  int active = 0;
  int recovered = 0;
  int death = 0;

  int totalDelta = 0;
  int activeDelta = 0;
  int recoveredDelta = 0;
  int deathDelta = 0;

  String lastUpdateTime = "";
  String appBarTitle = "";
  bool _visible = false;

  TextStyle commonStyleHeader =
      TextStyle(fontSize: 14, fontWeight: FontWeight.w900);
  TextStyle commonStyle = TextStyle(fontSize: 24, fontWeight: FontWeight.w400);

  List<TableData> tableData = List();

  void getAllData() {
    setState(() {
      appBarTitle = "Refreshing new data";
      _visible = false;
    });

    Network().getAllData().then((value) {
      setState(() {
        total = value.confirmed;
        active = value.active;
        recovered = value.recovered;
        death = value.deceased;

        totalDelta = value.confirmedDelta;
        recoveredDelta = value.recoveredDelta;
        deathDelta = value.deceasedDelta;
        activeDelta = totalDelta - recoveredDelta - deathDelta;
        lastUpdateTime = value.lastupdatedtime;

        appBarTitle = "${STR.LAST_UPDATED} $lastUpdateTime";
      });
    });

    Network().getStateDataList().then((value) {
      setState(() {
        tableData.clear();
        value.forEach((element) {
          tableData.add(TableData(
              stateName: element.state,
              confirmed: element.confirmed,
              active: element.active,
              recovered: element.recovered,
              deceases: element.deaths,
              stateDelta: element.delta));
        });

        TableData total = tableData[0];
        tableData.removeAt(0);
        tableData.add(total);
        _visible = true;
      });
    });
  }

  @override
  void didChangeAppLifecycleState(final AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      getAllData();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    getAllData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getAllData();
        },
        child: Icon(Icons.refresh),
        backgroundColor: Colors.grey[800],
        splashColor: Colors.white,
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            width: 480,
            child: ListView(
              children: <Widget>[
                Visibility(
                  visible: false,
                  child: SizedBox(
                    width: double.infinity,
                    child: Container(
                      color: Colors.amber[100],
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Center(
                          child: Text(
                            "Banner",
                            style: TextStyle(
                                fontSize: 14.0, color: Colors.amber[600]),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(appBarTitle,
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            letterSpacing: 1.0,
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[500])),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(STR.APP_HEADER,
                        style: TextStyle(
                            letterSpacing: 1.0,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800])),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(STR.APP_TAGLINE,
                        style: TextStyle(
                            letterSpacing: 1.0,
                            fontSize: 10.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600])),
                    SizedBox(
                      height: 10.0,
                    ),
                  ],
                ),
//                AnimatedOpacity(
//                  opacity: _visible ? 1.0 : 0.0,
//                  duration: Duration(milliseconds: 200),
//                  child: Padding(
//                    padding: const EdgeInsets.all(8.0),
//                    child: Row(
//                      children: <Widget>[
//                        StatsItem(
//                            myColor: Colors.red,
//                            title: STR.CONFIRMED,
//                            increased: totalDelta,
//                            total: total),
//                        StatsItem(
//                            myColor: Colors.blue[600],
//                            title: STR.ACTIVE,
//                            increased: activeDelta,
//                            total: active),
//                        StatsItem(
//                            myColor: Colors.green,
//                            title: STR.RECOVERED,
//                            increased: recoveredDelta,
//                            total: recovered),
//                        StatsItem(
//                            myColor: Colors.grey[500],
//                            title: STR.DECEASED,
//                            increased: deathDelta,
//                            total: death),
//                      ],
//                    ),
//                  ),
//                ),
                SizedBox(
                  height: 10,
                ),
//                AnimatedOpacity(
//                  opacity: _visible ? 1.0 : 0.0,
//                  duration: Duration(milliseconds: 200),
//                  child: Row(
//                    children: <Widget>[
//                      TableItems(
//                        bgColor: Colors.grey[300],
//                        title: STR.tableStatesUT,
//                        myFontSize: 13.0,
//                        myFontWeight: FontWeight.bold,
//                        flexSize: 2,
//                        delta: 0,
//                        isStateName: true,
//                        onSelect: () {},
//                      ),
//                      TableItems(
//                        bgColor: Colors.grey[300],
//                        title: STR.tableConfirmed,
//                        myFontSize: 12.0,
//                        myFontWeight: FontWeight.bold,
//                        flexSize: 1,
//                        delta: 0,
//                        isStateName: false,
//                        onSelect: () {},
//                      ),
//                      TableItems(
//                        bgColor: Colors.grey[300],
//                        title: STR.tableActive,
//                        myFontSize: 12.0,
//                        myFontWeight: FontWeight.bold,
//                        flexSize: 1,
//                        delta: 0,
//                        isStateName: false,
//                        onSelect: () {},
//                      ),
//                      TableItems(
//                        bgColor: Colors.grey[300],
//                        title: STR.tableRecovered,
//                        myFontSize: 12.0,
//                        myFontWeight: FontWeight.bold,
//                        flexSize: 1,
//                        delta: 0,
//                        isStateName: false,
//                        onSelect: () {},
//                      ),
//                      TableItems(
//                        bgColor: Colors.grey[300],
//                        title: STR.tableDeceased,
//                        myFontSize: 12.0,
//                        myFontWeight: FontWeight.bold,
//                        flexSize: 1,
//                        delta: 0,
//                        isStateName: false,
//                        onSelect: () {},
//                      ),
//                    ],
//                  ),
//                ),
                AnimatedOpacity(
                  opacity: _visible ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 200),
                  child: Column(
                    children: tableData
                        .mapIndexed((value, index) => TableRowsGenerator(
                            tableData: value,
                            index: index,
                            lastIndex: tableData.length,
                            stateDelta: value.stateDelta))
                        .toList(),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 100,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
