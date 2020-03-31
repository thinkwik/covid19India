import 'package:covid19app/items/statesItem.dart';
import 'package:covid19app/items/tableItems.dart';
import 'package:covid19app/model/districtData.dart';
import 'package:covid19app/model/stateDelta.dart';
import 'package:covid19app/model/tableData.dart';
import 'package:covid19app/network/api.dart';
import 'package:covid19app/utils/commons.dart';
import 'package:covid19app/utils/str.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

extension IndexedIterable<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T f(E e, int i)) {
    var i = 0;
    return this.map((e) => f(e, i++));
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  int total = 0;
  int active = 0;
  int recovered = 0;
  int death = 0;

  int totalDelta = 0;
  int activeDelta = 0;
  int recoveredDelta = 0;
  int deathDelta = 0;

  String lastUpdateTime = "";
  String timePlaceholder = "";
  String filterState = "";

  bool _visible = false;
  bool _visibleDistrict = false;

  TextStyle commonStyleHeader =
      TextStyle(fontSize: 14, fontWeight: FontWeight.w900);
  TextStyle commonStyle = TextStyle(fontSize: 24, fontWeight: FontWeight.w400);

  List<TableData> tableData = List();

  List<DistrictData> districtDataList = List();
  List<TableData> tableDataList = List();

  void getDistrictData(String filterFor) {
    Network().getStateDetailedData().then((value) {
      tableDataList.clear();

      List<DistrictData> finalData = districtDataList
          .where((element) =>
              element.stateName.toLowerCase() == filterFor.toLowerCase())
          .toList();

      TableData myTableData = tableData
          .where((element) =>
              element.stateName.toLowerCase() == filterFor.toLowerCase())
          .first;

      StateDelta delta =
          StateDelta(active: 0, confirmed: 0, deaths: 0, recovered: 0);

      finalData.forEach((element) {
        element.dDataList.forEach((element) {
          tableDataList.add(TableData(
              stateName: element.districtName,
              confirmed: element.confirmed,
              active: "0",
              recovered: "0",
              deceases: "0",
              stateDelta: delta));
        });
      });
      tableDataList.add(TableData(
          stateName: "Total",
          confirmed: myTableData.confirmed,
          active: "0",
          recovered: "0",
          deceases: "0",
          stateDelta: delta));

      setState(() {
        districtDataList = value;
        _visibleDistrict = true;
        filterState = filterFor;
      });
    });
  }

  void getAllData() {
    setState(() {
      timePlaceholder = "Refreshing new data";
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

        timePlaceholder = "$lastUpdateTime";
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
//    SystemChrome.setSystemUIOverlayStyle(
//        SystemUiOverlayStyle(statusBarColor: HEX.primaryColor));

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(1.0),
        child: AppBar(
          elevation: 0,
          backgroundColor: HEX.primaryColor,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getAllData();
        },
        child: Icon(Icons.refresh),
        backgroundColor: HEX.primaryColor,
        splashColor: Colors.white,
      ),
      body: Center(
        child: SafeArea(
          child: Container(
            width: 480.0,
            color: HEX.primaryColor,
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 0,
                            child: Container(
                              padding: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
                              child: Row(
                                children: <Widget>[
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(3.0),
                                      child: Image.asset(
                                        'icons/flags/png/in.png',
                                        package: 'country_icons',
                                        width: 24.0,
                                      )),
                                  SizedBox(
                                    width: 8.0,
                                  ),
                                  Text("India",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.white)),
                                  SizedBox(
                                    width: 3.0,
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Colors.transparent,
                                    size: 20.0,
                                  )
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: SizedBox(
                              height: 10.0,
                            ),
                          ),
                          Expanded(
                            flex: 0,
                            child: Container(
                              padding: EdgeInsets.all(6.0),
                              alignment: Alignment.centerRight,
                              child: Row(
                                children: <Widget>[
                                  Material(
                                    color: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(color: Colors.white),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Icon(
                                        Icons.list,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20.0,
                                  ),
                                  Material(
                                    color: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Icon(
                                        Icons.map,
                                        color: Colors.grey,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20.0,
                                  ),
                                  Material(
                                    color: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Icon(
                                        Icons.graphic_eq,
                                        color: Colors.grey,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Row(
                        children: <Widget>[
                          Text(STR.LAST_UPDATED,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white)),
                          Text(timePlaceholder,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ],
                      ),
                      SizedBox(
                        height: 24.0,
                      ),
                      AnimatedOpacity(
                        opacity: _visible ? 1.0 : 0.0,
                        duration: Duration(milliseconds: 200),
                        child: Row(
                          children: <Widget>[
                            StatsItem(
                                myImage: "ic_confirmed",
                                title: STR.CONFIRMED,
                                increased: totalDelta,
                                total: total),
                            StatsItem(
                                myImage: "ic_active",
                                title: STR.ACTIVE,
                                increased: activeDelta,
                                total: active),
                            StatsItem(
                                myImage: "ic_recovered",
                                title: STR.RECOVERED,
                                increased: recoveredDelta,
                                total: recovered),
                            StatsItem(
                                myImage: "ic_rip",
                                title: STR.DECEASED,
                                increased: deathDelta,
                                total: death),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 24.0,
                ),
                AnimatedOpacity(
                  opacity: _visible ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 200),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                          bottomLeft: Radius.circular(25),
                          bottomRight: Radius.circular(25)),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 116.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Visibility(
                                  visible: _visibleDistrict,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _visibleDistrict = false;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 05, 0),
                                      child: Container(
                                        child: Icon(
                                          Icons.arrow_back,
                                          size: 24.0,
                                        ),
                                      ),
                                    ),
                                  )),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                      _visibleDistrict
                                          ? "District Wise Cases"
                                          : "State Wise Cases",
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black)),
                                  Visibility(
                                    visible: _visibleDistrict,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 4, 0, 0),
                                      child: Text(filterState,
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blueAccent)),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Visibility(
                            visible: !_visibleDistrict,
                            child: Column(
                              children: tableData
                                  .mapIndexed(
                                      (value, index) => TableRowsGenerator(
                                            tableData: value,
                                            index: index,
                                            lastIndex: tableData.length,
                                            stateDelta: value.stateDelta,
                                            onSelect: () {
                                              getDistrictData(value.stateName);
                                            },
                                          ))
                                  .toList(),
                            ),
                          ),
                          Visibility(
                            visible: _visibleDistrict,
                            child: Column(
                              children: tableDataList
                                  .mapIndexed((value, index) =>
                                      DistrictTableRowsGenerator(
                                        tableData: value,
                                        index: index,
                                        lastIndex: tableDataList.length,
                                        stateDelta: value.stateDelta,
                                      ))
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
