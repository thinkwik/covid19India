
class ChartDataModel {
  List<TimeSeriesData> confirmedData = List();
  List<TimeSeriesData> recoveredData = List();
  List<TimeSeriesData> deathData = List();

  ChartDataModel({this.confirmedData, this.recoveredData, this.deathData});
}

class TimeSeriesData {
  final DateTime time;
  final int count;

  TimeSeriesData({this.time, this.count});
}
