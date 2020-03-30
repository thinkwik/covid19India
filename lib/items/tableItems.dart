import 'package:covid19app/model/stateDelta.dart';
import 'package:covid19app/model/tableData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class TableItems extends StatelessWidget {
  final Color bgColor;
  final String title;
  final double myFontSize;
  final FontWeight myFontWeight;
  final int flexSize;
  final int delta;
  final bool isStateName;
  Function onSelect;

  TableItems(
      {this.bgColor,
      this.title,
      this.myFontSize,
      this.myFontWeight,
      this.flexSize,
      this.delta,
      this.isStateName,
      this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flexSize,
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: GestureDetector(
          onTap: onSelect,
          child: Container(
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: RichText(
                textAlign: (isStateName) ? TextAlign.start : TextAlign.end,
                text: TextSpan(children: <TextSpan>[
                  TextSpan(
                    text: (delta > 0 && myFontWeight != FontWeight.bold)
                        ? "+$delta  "
                        : "",
                    style: TextStyle(
                        fontSize: myFontSize - 2,
                        fontWeight: myFontWeight,
                        color: Colors.red),
                  ),
                  TextSpan(
                    text: title,
                    style: TextStyle(
                        letterSpacing: 1.0,
                        fontSize: myFontSize,
                        fontWeight: myFontWeight,
                        color: Colors.black),
                  ),
                ]),
              ),
            ),
          ),
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

  TableRowsGenerator(
      {this.tableData, this.index, this.lastIndex, this.stateDelta}) {
//    logv("index == $index || last == $lastIndex");
    myColor = (index % 2) == 0 ? Colors.grey[50] : Colors.grey[200];
    if ((lastIndex - 1) == index) {
      genFontWeight = FontWeight.bold;
      myColor = Colors.grey[300];
    }
//    else tableData.stateName = tableData.stateName + ">";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TableItems(
                bgColor: myColor,
                title: tableData.stateName+">",
                myFontSize: genFontSize,
                myFontWeight: genFontWeight,
                flexSize: 2,
                delta: 0,
                isStateName: true,
                onSelect: () {
                  Navigator.pushNamed(context, "/details", arguments: {
                    "name": tableData.stateName,
                    "tableData": tableData,
                  });
                },
              ),
              TableItems(
                bgColor: myColor,
                title: tableData.confirmed,
                myFontSize: genFontSize,
                myFontWeight: genFontWeight,
                flexSize: 1,
                delta: stateDelta.confirmed,
                isStateName: false,
                onSelect: () {},
              ),
              TableItems(
                bgColor: myColor,
                title: tableData.active,
                myFontSize: genFontSize,
                myFontWeight: genFontWeight,
                flexSize: 1,
                delta: stateDelta.active,
                isStateName: false,
                onSelect: () {},
              ),
              TableItems(
                bgColor: myColor,
                title: tableData.recovered,
                myFontSize: genFontSize,
                myFontWeight: genFontWeight,
                flexSize: 1,
                delta: stateDelta.recovered,
                isStateName: false,
                onSelect: () {},
              ),
              TableItems(
                bgColor: myColor,
                title: tableData.deceases,
                myFontSize: genFontSize,
                myFontWeight: genFontWeight,
                flexSize: 1,
                delta: stateDelta.deaths,
                isStateName: false,
                onSelect: () {},
              ),
            ],
          ),
        ),
      ],
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
//    logv("index == $index || last == $lastIndex");
    myColor = (index % 2) == 0 ? Colors.grey[50] : Colors.grey[200];
    if ((lastIndex - 1) == index) {
      genFontWeight = FontWeight.bold;
      myColor = Colors.grey[300];
    }
//    else tableData.stateName = tableData.stateName + ">";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TableItems(
                bgColor: myColor,
                title: tableData.stateName,
                myFontSize: genFontSize,
                myFontWeight: genFontWeight,
                flexSize: 2,
                delta: 0,
                isStateName: true,
                onSelect: () {},
              ),
              TableItems(
                bgColor: myColor,
                title: tableData.confirmed,
                myFontSize: genFontSize,
                myFontWeight: genFontWeight,
                flexSize: 2,
                delta: stateDelta.confirmed,
                isStateName: false,
                onSelect: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}
