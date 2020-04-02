import 'package:covid19app/items/statesItem.dart';
import 'package:covid19app/model/screenSwitcher.dart';
import 'package:covid19app/model/tableData.dart';
import 'package:covid19app/screens/widgets/listHeaderWidget.dart';
import 'package:covid19app/screens/widgets/populateDataList.dart';
import 'package:covid19app/utils/str.dart';
import 'package:flutter/material.dart';

Widget headerInfo(
    bool _visible,
    String timePlaceholder,
    int total,
    int totalDelta,
    int active,
    int activeDelta,
    int recovered,
    int recoveredDelta,
    int death,
    int deathDelta,
    ScreenBloc screenBloc) {
  return Column(
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
                          elevation: 0,
                          color: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Icon(
                              Icons.show_chart,
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
            SizedBox(
              height: 24.0,
            ),
          ],
        ),
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
                bottomLeft: Radius.zero,
                bottomRight: Radius.zero),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 12.0),
            child: ListHeaderWidget(
              stateName: screenBloc.stateName,
              visibleDistrict: screenBloc.visibleDistrict,
            ),
          ),
        ),
      )
    ],
  );
}

Widget listView(
  bool _visible,
  List<TableData> tableData,
) {
  return ListView(
    children: <Widget>[
      AnimatedOpacity(
        opacity: _visible ? 1.0 : 0.0,
        duration: Duration(milliseconds: 200),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 116.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 10.0,
              ),
              WidgetSwitcher(
                tableData: tableData,
              )
            ],
          ),
        ),
      ),
    ],
  );
}
