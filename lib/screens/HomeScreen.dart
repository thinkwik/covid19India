import 'package:covid19app/charts/lineChartCubic.dart';
import 'package:covid19app/model/screenSwitcher.dart';
import 'package:covid19app/model/tableData.dart';
import 'package:covid19app/network/api.dart';
import 'package:covid19app/screens/webview.dart';
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

        Network().getStateDataList(value.statewiseAll).then((value) {
          setState(() {
            tableData.clear();
            value.forEach((element) {
              tableData.add(TableData(
                  stateName: element.state,
                  confirmed: element.confirmed,
                  active: (int.parse(element.confirmed) - int.parse(element.recovered) - int.parse(element.deaths)).toString(),
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

//        logv("Main data loaded ==${value.casesTimeSeries}");
        Network().getChartData(value).then((chartValue) {
          chartBloc.setChartData(chartValue);
        });
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
      body: Container(
        color: HEX.primaryColor,
        child: Center(
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
                  ? AnimatedOpacity(
                      opacity: widget.visible ? 1.0 : 0.0,
                      duration: Duration(milliseconds: 200),
                      child: Container(
                          height: 500,
                          child: LineChartMultiple(widget.chartBloc.chartData)),
                    )
                  : WebViewScreen(
                      link: "https://jineshsoni.github.io/covid19India-Heatmap/",
                      title: "",
                      backEnabled: false)),
    );
  }
}
