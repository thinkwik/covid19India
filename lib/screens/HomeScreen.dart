import 'package:covid19app/charts/simpleLineChart.dart';
import 'package:covid19app/items/statesItem.dart';
import 'package:covid19app/model/screenSwitcher.dart';
import 'package:covid19app/model/tableData.dart';
import 'package:covid19app/network/api.dart';
import 'package:covid19app/screens/widgets/homeScreenWidget.dart';
import 'package:covid19app/utils/commons.dart';
import 'package:covid19app/utils/str.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
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
  TabBloc tabBloc;
  ChartBloc chartBloc;

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

//        logv("Main data loaded ==${value.casesTimeSeries}");
        Network().getChartData(value).then((chartValue) {
          chartBloc.setChartData(chartValue);
        });
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
    });

    Network().getStateDetailedData().then((value) {
      screenBloc.setProcessedData(value);
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
    chartBloc = Provider.of<ChartBloc>(context);

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
        child: ChangeNotifierProvider(
          create: (context) => TabBloc(),
          child: Container(
            width: 480.0,
            color: HEX.primaryColor,
            child: Column(
              children: <Widget>[
                HeaderInfo(_visible, timePlaceholder, total, totalDelta, active,
                    activeDelta, recovered, recoveredDelta, death, deathDelta),
                Expanded(
                  child: Container(
                    color: _visible ? Colors.white : HEX.primaryColor,
                    child: MainScreenSwitcher(_visible, screenBloc, chartBloc),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MainScreenSwitcher extends StatefulWidget {
  final bool visible;
  final ScreenBloc screenBloc;
  final ChartBloc chartBloc;

  MainScreenSwitcher(this.visible, this.screenBloc, this.chartBloc);

  @override
  _MainScreenSwitcherState createState() => _MainScreenSwitcherState();
}

class _MainScreenSwitcherState extends State<MainScreenSwitcher> {
  @override
  Widget build(BuildContext context) {
    TabBloc tabBloc = Provider.of<TabBloc>(context);

    logv("tabBloc.tab == ${tabBloc.tab}");

    return Container(
      width: double.infinity,
      child: AnimatedSwitcher(
          duration: Duration(milliseconds: 200),
          child: tabBloc.tab == 0
              ? listView(widget.visible, widget.screenBloc.filterTableData)
              : tabBloc.tab == 2
                  ? Column(
                      children: <Widget>[
                        Container(
                            height: 350, child: DateTimeComboLinePointChart()),
                        ChartDatCard()
                      ],
                    )
                  : Text("Coming soon")),
    );
  }
}

class ChartDatCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ChartUpdateBloc chartUpdateBloc = Provider.of<ChartUpdateBloc>(context);
    ChartBloc chartBloc = Provider.of<ChartBloc>(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "${DateFormat('dd MMM, dd').format(chartBloc.chartData.confirmedData[chartUpdateBloc.index].time)}",
                style: TextStyle(
                    color: Colors.grey[800],
                    letterSpacing: 1.0,
                    fontSize: 18.0),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  GraphDataItem(
                      myImage: "ic_confirmed",
                      title: STR.CONFIRMED,
                      myColor: Colors.red,
                      total: chartBloc.chartData.confirmedData[chartUpdateBloc.index].count),
                  GraphDataItem(
                      myImage: "ic_active",
                      title: STR.ACTIVE,
                      myColor: Colors.green,
                      total: chartBloc.chartData.recoveredData[chartUpdateBloc.index].count),
//                  GraphDataItem(
//                      myImage: "ic_recovered",
//                      title: STR.RECOVERED,
//                      myColor: Colors.pinkAccent,
//                      total: 90),
                  GraphDataItem(
                      myImage: "ic_rip",
                      title: STR.DECEASED,
                      myColor: Colors.grey,
                      total: chartBloc.chartData.deathData[chartUpdateBloc.index].count),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
