import 'package:covid19app/charts/simpleLineChart.dart';
import 'package:covid19app/model/districtData.dart';
import 'package:covid19app/model/tableData.dart';
import 'package:flutter/material.dart';

class ScreenBloc extends ChangeNotifier {
  int _tabIndex = 1;
  int _screenName = 1;
  String _stateName = "";
  bool _visibleDistrict = false;
  List<DistrictData> _districtDataList = List();
  List<TableData> _filterTableData = List();
  List<TableData> _tableData = List();

  int get tab => _tabIndex;

  int get screen => _screenName;

  String get stateName => _stateName;

  bool get visibleDistrict => _visibleDistrict;

  List<DistrictData> get districtDataList => _districtDataList;

  List<TableData> get filterTableData => _filterTableData;

  List<TableData> get tableData => _tableData;

  void setTab(int tab) {
    _tabIndex = tab;
    notifyListeners();
  }

  void setScreen(int screen) {
    _screenName = screen;
    notifyListeners();
  }

  void setStateName(String name) {
    _stateName = name;
    notifyListeners();
  }

  void setForDistrict(int screen, String name, bool visibleDistrict) {
    _screenName = screen;
    _visibleDistrict = visibleDistrict;
    _stateName = name;
    notifyListeners();
  }

  void setProcessedData(List<DistrictData> districtDataList) {
    _districtDataList = districtDataList;
    notifyListeners();
  }

  void setFilterTableData(List<TableData> filterTableData) {
    _filterTableData = filterTableData;
    notifyListeners();
  }

  void setTableData(List<TableData> tableData) {
    _tableData = tableData;
    notifyListeners();
  }
}

class TabBloc extends ChangeNotifier {
  int _tabIndex = 0;

  int get tab => _tabIndex;

  void setTab(int tab) {
    _tabIndex = tab;
    notifyListeners();
  }
}

class ChartUpdateBloc extends ChangeNotifier {
  int _index = 0;

  int get index => _index;

  void setIndex(int i) {
    _index = i;
    notifyListeners();
  }
}

class ChartBloc extends ChangeNotifier {
  ChartData _chartData;

  ChartData get chartData => _chartData;

  void setChartData(ChartData chartData) {
    _chartData = ChartData(
        recoveredData: chartData.recoveredData,
        deathData: chartData.deathData,
        confirmedData: chartData.confirmedData);
    notifyListeners();
  }
}
