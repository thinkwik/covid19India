import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class DateTimeComboLinePointChart extends StatelessWidget {
  List<charts.Series> seriesList;
  bool animate;

  DateTimeComboLinePointChart(this.seriesList, {this.animate});

  /// Creates a [TimeSeriesChart] with sample data and no transition.
  factory DateTimeComboLinePointChart.withSampleData() {
    return new DateTimeComboLinePointChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return charts.TimeSeriesChart(
      seriesList,
      animate: animate,
      defaultRenderer: new charts.LineRendererConfig(),
      customSeriesRenderers: [
        new charts.PointRendererConfig(
          // ID used to link series to this renderer.
            customRendererId: 'customPoint')
      ],
      dateTimeFactory: const charts.LocalDateTimeFactory(),
    );
  }

  static List<charts.Series<TimeSeriesData, DateTime>> _createSampleData() {
    final confirmedData = [
      TimeSeriesData(DateTime(2017, 9, 19), 5),
    ];

    final recoveredData = [
      TimeSeriesData(DateTime(2017, 9, 19), 10),
    ];

    final deathData = [
      TimeSeriesData(DateTime(2017, 9, 19), 10),
    ];



    return [
      charts.Series<TimeSeriesData, DateTime>(
        id: 'Confirmed',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (TimeSeriesData data, _) => data.time,
        measureFn: (TimeSeriesData data, _) => data.count,
        data: confirmedData,
      ),
      charts.Series<TimeSeriesData, DateTime>(
        id: 'Recovered',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (TimeSeriesData data, _) => data.time,
        measureFn: (TimeSeriesData data, _) => data.count,
        data: recoveredData,
      ),
      charts.Series<TimeSeriesData, DateTime>(
        id: 'Death',
        colorFn: (_, __) => charts.MaterialPalette.gray.shadeDefault,
        domainFn: (TimeSeriesData data, _) => data.time,
          measureFn: (TimeSeriesData data, _) => data.count,
        data: deathData,
      ),
    ];
  }
}

class TimeSeriesData {
  final DateTime time;
  final int count;

  TimeSeriesData(this.time, this.count);
}