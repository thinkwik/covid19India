import 'dart:core';
import 'dart:ui';

import 'package:covid19app/items/statesItem.dart';
import 'package:covid19app/items/tableItems.dart';
import 'package:covid19app/model/districtData.dart';
import 'package:covid19app/model/stateDelta.dart';
import 'package:covid19app/model/tableData.dart';
import 'package:covid19app/network/api.dart';
import 'package:covid19app/utils/commons.dart';
import 'package:covid19app/utils/str.dart';
import 'package:flutter/material.dart';

extension IndexedIterable<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T f(E e, int i)) {
    var i = 0;
    return this.map((e) => f(e, i++));
  }
}

class StateWiseDetail extends StatefulWidget {
  @override
  _StateWiseDetailState createState() => _StateWiseDetailState();
}

class _StateWiseDetailState extends State<StateWiseDetail>
    with WidgetsBindingObserver {
  String filterFor = "";
  List<DistrictData> districtDataList = List();
  bool _visible = true;
  List<TableData> tableDataList = List();

  void getAllData() {
    Network().getStateDetailedData().then((value) {
      setState(() {
        districtDataList = value;
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
    final Map<String, Object> rcvdData =
        ModalRoute.of(context).settings.arguments;
    filterFor = rcvdData['name'];
    TableData tableData = rcvdData['tableData'];
    tableDataList.clear();

    List<DistrictData> finalData = districtDataList
        .where((element) =>
            element.stateName.toLowerCase() == filterFor.toLowerCase())
        .toList();

    StateDelta delta = StateDelta(
        active: 0,
        confirmed: 0,
        deaths: 0,
        recovered: 0
    );

    finalData.forEach((element) {
      element.dDataList.forEach((element) {
        tableDataList.add(TableData(
          stateName: element.districtName,
          confirmed: element.confirmed,
          active: "0",
          recovered: "0",
          deceases: "0",
          stateDelta: delta
        ));
      });
    });
    tableDataList.add(TableData(
        stateName: "Total",
        confirmed: tableData.confirmed,
        active: "0",
        recovered: "0",
        deceases: "0",
        stateDelta: delta
    ));

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text(filterFor,
        style: TextStyle(
          color: Colors.black
        ),),
        backgroundColor: Colors.grey[50],
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          width: 480,
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
//              AnimatedOpacity(
//                opacity: _visible ? 1.0 : 0.0,
//                duration: Duration(milliseconds: 200),
//                child: Padding(
//                  padding: const EdgeInsets.all(8.0),
//                  child: Row(
//                    children: <Widget>[
//                      StatsItem(
//                          myColor: Colors.red,
//                          title: STR.CONFIRMED,
//                          increased: tableData.stateDelta.confirmed,
//                          total: int.parse(tableData.confirmed)),
//                      StatsItem(
//                          myColor: Colors.blue[600],
//                          title: STR.ACTIVE,
//                          increased: tableData.stateDelta.active,
//                          total: int.parse(tableData.active)),
//                      StatsItem(
//                          myColor: Colors.green,
//                          title: STR.RECOVERED,
//                          increased: tableData.stateDelta.recovered,
//                          total: int.parse(tableData.recovered)),
//                      StatsItem(
//                          myColor: Colors.grey[500],
//                          title: STR.DECEASED,
//                          increased: tableData.stateDelta.deaths,
//                          total: int.parse(tableData.deceases)),
//                    ],
//                  ),
//                ),
//              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Container(
                  child: Column(
                    children: <Widget>[
                      AnimatedOpacity(
                        opacity: _visible ? 1.0 : 0.0,
                        duration: Duration(milliseconds: 200),
                        child: Row(
                          children: <Widget>[
                            TableItems(
                              bgColor: Colors.grey[300],
                              title: STR.tableDistrict,
                              myFontSize: 13.0,
                              myFontWeight: FontWeight.bold,
                              flexSize: 1,
                              delta: 0,
                              isStateName: true,
                              onSelect:() {},
                            ),
                            TableItems(
                              bgColor: Colors.grey[300],
                              title: STR.CONFIRMED,
                              myFontSize: 12.0,
                              myFontWeight: FontWeight.bold,
                              flexSize: 1,
                              delta: 0,
                              isStateName: false,
                              onSelect:() {},
                            ),
                          ],
                        ),
                      ),
                      AnimatedOpacity(
                        opacity: _visible ? 1.0 : 0.0,
                        duration: Duration(milliseconds: 200),
                        child: Column(
                          children: tableDataList
                              .mapIndexed((value, index) => DistrictTableRowsGenerator(
                              tableData: value,
                              index: index,
                              lastIndex: tableDataList.length,
                              stateDelta: value.stateDelta))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(
                height: 100,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
