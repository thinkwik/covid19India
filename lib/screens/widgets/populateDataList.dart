import 'package:covid19app/items/tableItems.dart';
import 'package:covid19app/model/districtData.dart';
import 'package:covid19app/model/screenSwitcher.dart';
import 'package:covid19app/model/tableData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

extension IndexedIterable<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T f(E e, int i)) {
    var i = 0;
    return this.map((e) => f(e, i++));
  }
}

class StateList extends StatelessWidget {
  final List<TableData> tableData;

  StateList({this.tableData});

  @override
  Widget build(BuildContext context) {
    final ScreenBloc screenBloc = Provider.of<ScreenBloc>(context);

    return Column(
      key: UniqueKey(),
      children: <Widget>[
        Column(
          children: tableData
              .mapIndexed((value, index) => TableRowsGenerator(
                    tableData: value,
                    index: index,
                    lastIndex: tableData.length,
                    stateDelta: value.stateDelta,
                    onSelect: () {
                      screenBloc.setForDistrict(2, value.stateName, true);
                    },
                  ))
              .toList(),
        ),
      ],
    );
  }
}

class DistrictList extends StatelessWidget {
  final List<DistrictData> districtDataList;
  List<DData> dDataList = List();
  final String stateName;

  DistrictList({this.districtDataList, this.stateName}) {
    List<DistrictData> tempList = districtDataList
        .where((element) =>
            element.stateName.toLowerCase() == stateName.toLowerCase())
        .toList();

    int total = 0;
    if (tempList.length > 0) {
      dDataList = tempList.first.dDataList;
      dDataList.forEach((element) {
        total += int.parse(element.confirmed);
      });
    }
    dDataList.add(DData(confirmed: total.toString(), districtName: "Total"));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      key: UniqueKey(),
      children: <Widget>[
        Column(
          children: dDataList
              .mapIndexed((value, index) => DistrictTableRowsGenerator(
                    dDate: value,
                    index: index,
                    lastIndex: dDataList.length,
                  ))
              .toList(),
        ),
      ],
    );
  }
}

class WidgetSwitcher extends StatefulWidget {
  final List<TableData> tableData;

  WidgetSwitcher({this.tableData});

  @override
  _WidgetSwitcherState createState() => _WidgetSwitcherState();
}

class _WidgetSwitcherState extends State<WidgetSwitcher> {
  @override
  Widget build(BuildContext context) {
    final ScreenBloc screenBloc = Provider.of<ScreenBloc>(context);

    return Center(
      child: AnimatedSwitcher(
          duration: Duration(milliseconds: 200),
          child: screenBloc.screen == 1
              ? StateList(
                  tableData: widget.tableData,
                )
              : DistrictList(
                  districtDataList: screenBloc.districtDataList,
                  stateName: screenBloc.stateName,
                )),
    );
  }
}
