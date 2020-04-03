import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/flutter.dart';
import 'package:covid19app/model/screenSwitcher.dart';
import 'package:covid19app/utils/commons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DateTimeComboLinePointChart extends StatelessWidget {
  List<charts.Series<TimeSeriesData, DateTime>> _createChartData(
      ChartData chartData) {
    return [
      charts.Series<TimeSeriesData, DateTime>(
        id: 'Confirmed',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (TimeSeriesData data, _) => data.time,
        measureFn: (TimeSeriesData data, _) => data.count,
        data: chartData.confirmedData,
      ),
      charts.Series<TimeSeriesData, DateTime>(
        id: 'Recovered',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (TimeSeriesData data, _) => data.time,
        measureFn: (TimeSeriesData data, _) => data.count,
        data: chartData.recoveredData,
      ),
      charts.Series<TimeSeriesData, DateTime>(
        id: 'Death',
        colorFn: (_, __) => charts.MaterialPalette.gray.shadeDefault,
        domainFn: (TimeSeriesData data, _) => data.time,
        measureFn: (TimeSeriesData data, _) => data.count,
        data: chartData.deathData,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    ChartBloc chartBloc = Provider.of<ChartBloc>(context);
    ChartUpdateBloc chartUpdateBloc = Provider.of<ChartUpdateBloc>(context);
    logv("Data = ${chartBloc.chartData}");

    return charts.TimeSeriesChart(
      _createChartData(chartBloc.chartData),
      animate: true,
//      defaultRenderer: new charts.LineRendererConfig(),
//      animationDuration: Duration(milliseconds: 500),
      behaviors: [],
      selectionModels: [
        SelectionModelConfig(changedListener: (SelectionModel model) {
          if (model.hasDatumSelection) {
            chartUpdateBloc.setIndex(model.selectedDatum[0].index);
          }
        })
      ],
      customSeriesRenderers: [
        new charts.PointRendererConfig(
            // ID used to link series to this renderer.
            customRendererId: 'customPoint')
      ],
      dateTimeFactory: const charts.LocalDateTimeFactory(),
    );
  }
}

class ChartData {
  List<TimeSeriesData> confirmedData = List();
  List<TimeSeriesData> recoveredData = List();
  List<TimeSeriesData> deathData = List();

  ChartData({this.confirmedData, this.recoveredData, this.deathData});
}

class TimeSeriesData {
  final DateTime time;
  final int count;

  TimeSeriesData({this.time, this.count});
}
