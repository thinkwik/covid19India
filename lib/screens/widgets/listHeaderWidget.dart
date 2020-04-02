import 'package:covid19app/model/screenSwitcher.dart';
import 'package:covid19app/screens/widgets/debouncer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListHeaderWidget extends StatefulWidget {
  final String stateName;
  final bool visibleDistrict;

  ListHeaderWidget({this.stateName, this.visibleDistrict});

  @override
  _ListHeaderWidgetState createState() => _ListHeaderWidgetState();
}

class _ListHeaderWidgetState extends State<ListHeaderWidget> {
  bool searchEnabled = false;

  @override
  Widget build(BuildContext context) {
    final ScreenBloc screenBloc = Provider.of<ScreenBloc>(context);
    final _debouncer = Debouncer();

    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
      child: GestureDetector(
        onTap: () {
          screenBloc.setForDistrict(1, "", false);
        },
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 0,
                  child: Visibility(
                      visible: widget.visibleDistrict,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 05, 0),
                        child: Container(
                          child: Icon(
                            Icons.arrow_back,
                            size: 24.0,
                          ),
                        ),
                      )),
                ),
                Visibility(
                  visible: !searchEnabled || widget.visibleDistrict,
                  child: Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                            widget.visibleDistrict
                                ? "District Wise Cases"
                                : "State Wise Cases",
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.normal,
                                color: Colors.black)),
                        Visibility(
                          visible: widget.visibleDistrict,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                            child: Text(widget.stateName,
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueAccent)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: searchEnabled && !widget.visibleDistrict,
                  child: Expanded(
                    flex: 1,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                          child: Icon(
                            Icons.search,
                            size: 24.0,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: 35,
                            child: TextField(
                              onChanged: (value) {
                                _debouncer.run(() {
                                  if (value.length > 0)
                                    screenBloc.setFilterTableData(screenBloc
                                        .tableData
                                        .where((element) => element.stateName
                                            .toLowerCase()
                                            .contains(value.toLowerCase()))
                                        .toList());
                                  else
                                    screenBloc.setFilterTableData(
                                        screenBloc.tableData);
                                });
                              },
                              decoration: new InputDecoration(
                                  hintText: 'Search',
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  )),
                              maxLines: 1,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              searchEnabled = false;
                              screenBloc
                                  .setFilterTableData(screenBloc.tableData);
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                            child: Icon(
                              Icons.close,
                              size: 24.0,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: !searchEnabled && !widget.visibleDistrict,
                  child: Expanded(
                    flex: 0,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          searchEnabled = true;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(05, 0, 05, 0),
                        child: Container(
                          child: Icon(
                            Icons.search,
                            size: 24.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: !searchEnabled && !widget.visibleDistrict,
                  child: Expanded(
                    flex: 0,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(05, 0, 05, 0),
                      child: Container(
                        child: Icon(
                          Icons.import_export,
                          size: 24.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
