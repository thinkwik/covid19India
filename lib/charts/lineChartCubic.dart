import 'package:covid19app/charts/simpleLineChart.dart';
import 'package:covid19app/utils/str.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:mp_chart/mp/chart/line_chart.dart';
import 'package:mp_chart/mp/controller/line_chart_controller.dart';
import 'package:mp_chart/mp/core/common_interfaces.dart';
import 'package:mp_chart/mp/core/data/line_data.dart';
import 'package:mp_chart/mp/core/data_interfaces/i_line_data_set.dart';
import 'package:mp_chart/mp/core/data_set/line_data_set.dart';
import 'package:mp_chart/mp/core/description.dart';
import 'package:mp_chart/mp/core/entry/entry.dart';
import 'package:mp_chart/mp/core/enums/x_axis_position.dart';
import 'package:mp_chart/mp/core/highlight/highlight.dart';
import 'package:mp_chart/mp/core/value_formatter/value_formatter.dart';

import 'action_state.dart';

class LineChartMultiple extends StatefulWidget {
  final ChartDataModel chartDataModel;

  LineChartMultiple(this.chartDataModel);

  @override
  State<StatefulWidget> createState() {
    return LineChartMultipleState();
  }
}

class LineChartMultipleState extends LineActionState<LineChartMultiple>
    implements OnChartValueSelectedListener {
  List<Color> colors = List()
    ..add(Colors.red)
    ..add(Colors.green)
    ..add(Colors.grey);

  int date = 0;
  String confirmed = "0";
  String recovered = "0";
  String dead = "0";
  bool visible = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: LineChart(controller),
        ),
        Positioned(
            top: 50,
            left: 50,
            child: Visibility(
              visible: visible,
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        intl.DateFormat("dd MMM")
                            .format(DateTime.fromMillisecondsSinceEpoch(date)),
                        style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      Text(
                        confirmed,
                        style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                      Text(
                        recovered,
                        style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
                      ),
                      Text(
                        dead,
                        style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      )
                    ],
                  ),
                ),
              ),
            )
            ),
      ],
    );
  }

  @override
  void onNothingSelected() {
    setState(() {
      visible = false;
    });
  }

  @override
  void onValueSelected(Entry e, Highlight h) {
    setState(() {
      date = e.x.toInt();
      visible = true;
      confirmed = widget.chartDataModel.confirmedData
          .where((element) => element.time.millisecondsSinceEpoch == date)
          .toList()
          .first
          .count
          .toString();
      recovered = widget.chartDataModel.recoveredData
          .where((element) => element.time.millisecondsSinceEpoch == date)
          .toList()
          .first
          .count
          .toString();
      dead = widget.chartDataModel.deathData
          .where((element) => element.time.millisecondsSinceEpoch == date)
          .toList()
          .first
          .count
          .toString();
    });
  }

  @override
  void initState() {
    _initController();
    _initLineData(widget.chartDataModel);
    super.initState();
  }

  void _initController() {
    var desc = Description()..enabled = false;
    controller = LineChartController(
        axisLeftSettingFunction: (axisLeft, controller) {
          axisLeft
            ..enabled = (true)
            ..drawAxisLine = (false)
            ..gridLineWidth = 0.5
            ..gridColor = Colors.grey[400]
            ..drawGridLinesBehindData = true
            ..drawGridLines = (true);
        },
        axisRightSettingFunction: (axisRight, controller) {
          axisRight
            ..enabled = (false)
            ..drawAxisLine = (false)
            ..drawGridLines = (false);
        },
        xAxisSettingFunction: (xAxis, controller) {
          xAxis
            ..position = (XAxisPosition.BOTTOM_INSIDE)
            ..drawAxisLine = (false)
            ..setValueFormatter(XFormat())
            ..drawGridLines = (false);
        },
        drawGridBackground: false,
        backgroundColor: Colors.transparent,
        dragXEnabled: false,
        dragYEnabled: false,
        scaleXEnabled: false,
        scaleYEnabled: false,
        pinchZoomEnabled: false,
        selectionListener: this,
        drawMarkers: true,
        noDataText: "Loading chart data",
        drawBorders: false,
        description: desc);
  }

  void _initLineData(ChartDataModel chartDataModel) async {
    List<ILineDataSet> dataSets = List();
    String title;
    for (int z = 0; z < 3; z++) {
      List<Entry> values = List();

      if (z == 0) {
        title = STR.CONFIRMED;
        chartDataModel.confirmedData.forEach((element) {
          double y = element.time.millisecondsSinceEpoch.toDouble();
          values.add(Entry(x: y, y: element.count.toDouble())); // add one entry
        });
      }

      if (z == 1) {
        title = STR.RECOVERED;
        chartDataModel.recoveredData.forEach((element) {
          double y = element.time.millisecondsSinceEpoch.toDouble();
          values.add(Entry(x: y, y: element.count.toDouble())); // add one entry
        });
      }

      if (z == 2) {
        title = STR.DECEASED;
        chartDataModel.deathData.forEach((element) {
          double y = element.time.millisecondsSinceEpoch.toDouble();
          values.add(Entry(x: y, y: element.count.toDouble())); // add one entry
        });
      }

      LineDataSet set1 = new LineDataSet(values, title);
      set1.setDrawFilled(false);
      set1.setDrawCircles(false);
      set1.setDrawValues(false);
      set1.setDrawHorizontalHighlightIndicator(false);

      Color color = colors[z];
      set1.setColor1(color);
      set1.setCircleColor(color);
      dataSets.add(set1);
    }

    controller.data = LineData.fromList(dataSets);

    setState(() {});
  }
}

class XFormat extends ValueFormatter {
  final intl.DateFormat mFormat = intl.DateFormat("dd MMM");

  @override
  String getFormattedValue1(double value) {
    return mFormat.format(DateTime.fromMillisecondsSinceEpoch(value.toInt()));
  }
}
