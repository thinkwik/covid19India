import 'package:covid19app/model/stateDelta.dart';
import 'package:covid19app/model/tableData.dart';
import 'package:covid19app/utils/str.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class TableItems extends StatelessWidget {
  final Color bgColor;
  final String title;
  final String data;
  final double myFontSize;
  final FontWeight myFontWeight;
  final int delta;
  final int myFlex;
  final bool isStateName;

  TableItems({
    this.bgColor,
    this.title,
    this.data,
    this.myFontSize,
    this.myFontWeight,
    this.delta,
    this.myFlex,
    this.isStateName,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: myFlex,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                  fontSize: myFontSize,
                  fontWeight: myFontWeight,
                  color: bgColor),
            ),
            Visibility(
              visible: (data.length > 0),
              child: SizedBox(
                height: 5.0,
              ),
            ),
            Visibility(
                visible: (data.length > 0),
                child: Row(
                  children: <Widget>[
                    Text(
                      data,
                      style: TextStyle(
                          letterSpacing: 1.0,
                          fontSize: myFontSize,
                          fontWeight: myFontWeight,
                          color: Colors.black),
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      (delta > 0 && myFontWeight != FontWeight.bold)
                          ? "  +$delta  "
                          : "",
                      style: TextStyle(
                          fontSize: myFontSize - 2,
                          fontWeight: myFontWeight,
                          color: Colors.red),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}

class TableDistrictItems extends StatelessWidget {
  final Color bgColor;
  final String title;
  final String data;
  final double myFontSize;
  final FontWeight myFontWeight;
  final int delta;
  final int myFlex;
  final bool isStateName;

  TableDistrictItems({
    this.bgColor,
    this.title,
    this.data,
    this.myFontSize,
    this.myFontWeight,
    this.delta,
    this.myFlex,
    this.isStateName,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: myFlex,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                  fontSize: myFontSize,
                  fontWeight: myFontWeight,
                  color: bgColor),
            ),
            Visibility(
              visible: (data.length > 0),
              child: SizedBox(
                height: 5.0,
              ),
            ),
            Visibility(
                visible: (data.length > 0),
                child: Row(
                  children: <Widget>[
                    Text(
                      data,
                      style: TextStyle(
                          letterSpacing: 1.0,
                          fontSize: myFontSize,
                          fontWeight: myFontWeight,
                          color: Colors.black),
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      (delta > 0 && myFontWeight != FontWeight.bold)
                          ? "  +$delta  "
                          : "",
                      style: TextStyle(
                          fontSize: myFontSize - 2,
                          fontWeight: myFontWeight,
                          color: Colors.red),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}

class TableRowsGenerator extends StatelessWidget {
  final TableData tableData;
  double genFontSize = 12.0;
  int index;
  Color myColor = Colors.grey[200];
  FontWeight genFontWeight = FontWeight.w500;
  int lastIndex;
  StateDelta stateDelta;
  Function onSelect;

  TableRowsGenerator(
      {this.tableData,
      this.index,
      this.lastIndex,
      this.stateDelta,
      this.onSelect}) {
    myColor = (index % 2) == 0 ? Colors.grey[50] : Colors.grey[200];
    if ((lastIndex - 1) == index) {
      genFontWeight = FontWeight.bold;
      myColor = Colors.grey[300];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 4.0),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, "/details", arguments: {
            "name": tableData.stateName,
            "tableData": tableData,
          });
        },
        child: Material(
          color: Colors.white,
          shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(children: <Widget>[
                  TableItems(
                    bgColor: Colors.black,
                    title: tableData.stateName,
                    data: "",
                    myFontSize: genFontSize + 2,
                    myFontWeight: FontWeight.bold,
                    delta: 0,
                    myFlex: 1,
                    isStateName: true,
                  ),
                  Icon(
                    Icons.keyboard_arrow_right,
                    size: 20.0,
                  )
                ]),
                Row(
                  children: <Widget>[
                    TableItems(
                      myFlex: 1,
                      bgColor: Colors.red,
                      title: STR.CONFIRMED,
                      data: tableData.confirmed,
                      myFontSize: genFontSize,
                      myFontWeight: genFontWeight,
                      delta: stateDelta.confirmed,
                      isStateName: false,
                    ),
                    TableItems(
                      myFlex: 1,
                      bgColor: Colors.green,
                      title: STR.ACTIVE,
                      data: tableData.active,
                      myFontSize: genFontSize,
                      myFontWeight: genFontWeight,
                      delta: stateDelta.active,
                      isStateName: false,
                    ),
                    TableItems(
                      myFlex: 1,
                      bgColor: Colors.pinkAccent,
                      title: STR.RECOVERED,
                      data: tableData.recovered,
                      myFontSize: genFontSize,
                      myFontWeight: genFontWeight,
                      delta: stateDelta.recovered,
                      isStateName: false,
                    ),
                    TableItems(
                      myFlex: 1,
                      bgColor: Colors.grey,
                      title: STR.DECEASED,
                      data: tableData.deceases,
                      myFontSize: genFontSize,
                      myFontWeight: genFontWeight,
                      delta: stateDelta.deaths,
                      isStateName: false,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DistrictTableRowsGenerator extends StatelessWidget {
  final TableData tableData;
  double genFontSize = 12.0;
  int index;
  Color myColor = Colors.grey[200];
  FontWeight genFontWeight = FontWeight.w500;
  int lastIndex;
  StateDelta stateDelta;

  DistrictTableRowsGenerator(
      {this.tableData, this.index, this.lastIndex, this.stateDelta}) {
    myColor = (index % 2) == 0 ? Colors.grey[50] : Colors.grey[200];
    if ((lastIndex - 1) == index) {
      genFontWeight = FontWeight.bold;
      myColor = Colors.grey[300];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 4.0),
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(children: <Widget>[
                TableDistrictItems(
                  bgColor: Colors.black,
                  title: tableData.stateName,
                  data: "",
                  myFontSize: genFontSize + 2,
                  myFontWeight: FontWeight.bold,
                  delta: 0,
                  myFlex: 3,
                  isStateName: true,
                ),
                TableDistrictItems(
                  myFlex: 2,
                  bgColor: Colors.red,
                  title: "${STR.CONFIRMED}: ",
                  data: tableData.confirmed,
                  myFontSize: genFontSize + 2,
                  myFontWeight: genFontWeight,
                  delta: stateDelta.confirmed,
                  isStateName: false,
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
