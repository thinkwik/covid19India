import 'package:covid19app/items/tableItems.dart';
import 'package:covid19app/model/districtData.dart';
import 'package:covid19app/model/stateDelta.dart';
import 'package:covid19app/model/tableData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension IndexedIterable<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T f(E e, int i)) {
    var i = 0;
    return this.map((e) => f(e, i++));
  }
}

class StateList extends StatelessWidget {
  final List<TableData> tableData;
  final List<DistrictData> districtDataList;
  final ValueNotifier<Widget> notifier;

  StateList({this.tableData, this.districtDataList, this.notifier});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        HeaderText(
          tableData: tableData,
          stateName: "",
          notifier: notifier,
          districtDataList: districtDataList,
          visibleDistrict: false,
        ),
        Column(
          children: tableData
              .mapIndexed((value, index) => TableRowsGenerator(
                    tableData: value,
                    index: index,
                    lastIndex: tableData.length,
                    stateDelta: value.stateDelta,
                    onSelect: () {
                      notifier.value = DistrictList(
                          tableData: tableData,
                          districtDataList: districtDataList,
                          notifier: notifier,
                          stateName: value.stateName);
                    },
                  ))
              .toList(),
        ),
      ],
    );
  }
}
// ignore: must_be_immutable
class DistrictList extends StatelessWidget {
  final List<TableData> tableData;
  final Function onSelect;
  final List<DistrictData> districtDataList;
  List<TableData> tableDataList = List();
  final ValueNotifier<Widget> notifier;
  final String stateName;

  DistrictList(
      {this.tableData,
      this.districtDataList,
      this.onSelect,
      this.notifier,
      this.stateName}) {
    List<DistrictData> finalData = districtDataList
        .where((element) =>
            element.stateName.toLowerCase() == stateName.toLowerCase())
        .toList();

    TableData myTableData = tableData
        .where((element) =>
            element.stateName.toLowerCase() == stateName.toLowerCase())
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
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        HeaderText(
          tableData: tableData,
          stateName: stateName,
          notifier: notifier,
          districtDataList: districtDataList,
          visibleDistrict: true,
        ),
        Column(
          children: tableDataList
              .mapIndexed((value, index) => DistrictTableRowsGenerator(
                    tableData: value,
                    index: index,
                    lastIndex: tableDataList.length,
                    stateDelta: value.stateDelta,
                  ))
              .toList(),
        ),
      ],
    );
  }
}

class WidgetParent extends AnimatedWidget {
  final List<TableData> tableData;
  final List<DistrictData> districtDataList;

  WidgetParent({this.tableData, this.districtDataList})
      : super(listenable: ValueNotifier<Widget>(null));

  ValueNotifier<Widget> get notifier => listenable as ValueNotifier<Widget>;

  Widget build(BuildContext context) {
    return new Center(
        child: notifier.value ??
            StateList(
              tableData: tableData,
              districtDataList: districtDataList,
              notifier: notifier,
            ));
  }
}

class HeaderText extends StatelessWidget {
  final String stateName;
  final bool visibleDistrict;
  final List<TableData> tableData;
  final List<DistrictData> districtDataList;

  final ValueNotifier<Widget> notifier;

  HeaderText(
      {this.tableData,
      this.districtDataList,
      this.stateName,
      this.notifier,
      this.visibleDistrict});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
      child: GestureDetector(
        onTap: () {
          if (visibleDistrict)
            notifier.value = StateList(
              tableData: tableData,
              districtDataList: districtDataList,
              notifier: notifier,
            );
        },
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Visibility(
                    visible: visibleDistrict,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 05, 0),
                      child: Container(
                        child: Icon(
                          Icons.arrow_back,
                          size: 24.0,
                        ),
                      ),
                    )),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                        visibleDistrict
                            ? "District Wise Cases"
                            : "State Wise Cases",
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.normal,
                            color: Colors.black)),
                    Visibility(
                      visible: visibleDistrict,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                        child: Text(stateName,
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
          ],
        ),
      ),
    );
  }
}

//class WidgetSwitcher extends StatefulWidget {
//  final notifier = true;
//  final List<TableData> tableData;
//  final List<DistrictData> districtDataList;
//
//
//  WidgetSwitcher({this.tableData, this.districtDataList});
//
//  @override
//  _WidgetSwitcherState createState() => _WidgetSwitcherState();
//}
//
//class _WidgetSwitcherState extends State<WidgetSwitcher> {
//  @override
//  Widget build(BuildContext context) {
//    return Center(
//      child: AnimatedSwitcher(
//          child: widget.notifier ? StateList(
//            tableData: widget.tableData,
//            districtDataList: widget.districtDataList,
//            notifier: widget.notifier,
//          ) : DistrictList(
//            tableData: widget.tableData,
//            districtDataList: widget.districtDataList,
//            notifier: widget.notifier,
//          )
//      ),
//    );
//  }
//}
