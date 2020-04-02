import 'package:covid19app/charts/simpleLineChart.dart';
import 'package:covid19app/model/screenSwitcher.dart';
import 'package:covid19app/model/tableData.dart';
import 'package:covid19app/network/api.dart';
import 'package:covid19app/screens/widgets/homeScreenWidget.dart';
import 'package:covid19app/utils/commons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

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
  ScreenBloc screenBloc;

  TextStyle commonStyleHeader =
      TextStyle(fontSize: 14, fontWeight: FontWeight.w900);
  TextStyle commonStyle = TextStyle(fontSize: 24, fontWeight: FontWeight.w400);

  List<TableData> tableData = List();

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
        screenBloc.setFilterTableData(tableData);
        screenBloc.setTableData(tableData);
      });
      Network().getStateDetailedData().then((value) {
        screenBloc.setProcessedData(value);
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
    screenBloc = Provider.of<ScreenBloc>(context);

    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: HEX.primaryColor));

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0.0),
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
        child: Container(
          width: 480.0,
          color: HEX.primaryColor,
          child: Column(
            children: <Widget>[
              headerInfo(
                  _visible,
                  timePlaceholder,
                  total,
                  totalDelta,
                  active,
                  activeDelta,
                  recovered,
                  recoveredDelta,
                  death,
                  deathDelta,
                  screenBloc),
              Expanded(
                child: Container(
                    color: _visible
                        ? Colors.white
                        : HEX.primaryColor,
                    child: listView(_visible, screenBloc.filterTableData)),
//              child: Container(color: Colors.white,child: DateTimeComboLinePointChart.withSampleData()),
              )
            ],
          ),
        ),
      ),
    );
  }
}
