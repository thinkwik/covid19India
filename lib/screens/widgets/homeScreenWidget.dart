import 'package:covid19app/items/statesItem.dart';
import 'package:covid19app/model/screenSwitcher.dart';
import 'package:covid19app/model/tableData.dart';
import 'package:covid19app/screens/widgets/listHeaderWidget.dart';
import 'package:covid19app/screens/widgets/populateDataList.dart';
import 'package:covid19app/utils/str.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HeaderInfo extends StatefulWidget {
  final bool visible;
  final String timePlaceholder;
  final int total;
  final int totalDelta;
  final int active;
  final int activeDelta;
  final int recovered;
  final int recoveredDelta;
  final int death;
  final int deathDelta;

  final List<bool> _selections = [false, false, false];

  HeaderInfo(
      this.visible,
      this.timePlaceholder,
      this.total,
      this.totalDelta,
      this.active,
      this.activeDelta,
      this.recovered,
      this.recoveredDelta,
      this.death,
      this.deathDelta);

  @override
  _HeaderInfoState createState() => _HeaderInfoState();
}

class _HeaderInfoState extends State<HeaderInfo> {
  @override
  Widget build(BuildContext context) {
    TabBloc tabBloc = Provider.of<TabBloc>(context);
    ScreenBloc screenBloc = Provider.of<ScreenBloc>(context);
    widget._selections[tabBloc.tab] = true;

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
                      child: ToggleButtons(
                        selectedColor: Colors.white,
                        color: Colors.grey,
                        fillColor: Colors.transparent,
                        renderBorder: false,
                        children: <Widget>[
                          Material(
                            color: Colors.transparent,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: selectedColorScheme(
                                        widget._selections[0])),
                                borderRadius: BorderRadius.circular(5)),
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Icon(
                                Icons.list,
                                color:
                                    selectedColorScheme(widget._selections[0]),
                                size: 20,
                              ),
                            ),
                          ),
                          Material(
                            color: Colors.transparent,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: selectedColorScheme(
                                        widget._selections[1])),
                                borderRadius: BorderRadius.circular(5)),
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Icon(
                                Icons.map,
                                color:
                                    selectedColorScheme(widget._selections[1]),
                                size: 20,
                              ),
                            ),
                          ),
                          Material(
                            elevation: 0,
                            color: Colors.transparent,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: selectedColorScheme(
                                        widget._selections[2])),
                                borderRadius: BorderRadius.circular(5)),
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Icon(
                                Icons.show_chart,
                                color:
                                    selectedColorScheme(widget._selections[2]),
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                        onPressed: (int index) {
                          setState(() {
                            for (int indexBtn = 0;
                                indexBtn < widget._selections.length;
                                indexBtn++) {
                              if (indexBtn == index) {
                                widget._selections[indexBtn] =
                                    !widget._selections[indexBtn];
                              } else {
                                widget._selections[indexBtn] = false;
                              }
                            }
                            tabBloc.setTab(index);
                          });
                        },
                        isSelected: widget._selections,
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
                  Text(widget.timePlaceholder,
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
                opacity: widget.visible ? 1.0 : 0.0,
                duration: Duration(milliseconds: 200),
                child: Row(
                  children: <Widget>[
                    StatsItem(
                        myImage: "ic_confirmed",
                        title: STR.CONFIRMED,
                        increased: widget.totalDelta,
                        total: widget.total),
                    StatsItem(
                        myImage: "ic_active",
                        title: STR.ACTIVE,
                        increased: widget.activeDelta,
                        total: widget.active),
                    StatsItem(
                        myImage: "ic_recovered",
                        title: STR.RECOVERED,
                        increased: widget.recoveredDelta,
                        total: widget.recovered),
                    StatsItem(
                        myImage: "ic_rip",
                        title: STR.DECEASED,
                        increased: widget.deathDelta,
                        total: widget.death),
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
          opacity: widget.visible ? 1.0 : 0.0,
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
}

Color selectedColorScheme(bool selection) {
  return selection ? Colors.white : Colors.grey;
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
