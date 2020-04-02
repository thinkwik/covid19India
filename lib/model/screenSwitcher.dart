import 'package:covid19app/model/districtData.dart';
import 'package:covid19app/model/tableData.dart';
import 'package:flutter/material.dart';

class ScreenBloc extends ChangeNotifier {
  int _screenName = 1;
  String _stateName = "";
  bool _visibleDistrict = false;
  List<DistrictData> _districtDataList = List();
  List<TableData> _filterTableData = List();
  List<TableData> _tableData = List();

  int get screen => _screenName;
  String get stateName => _stateName;
  bool get visibleDistrict => _visibleDistrict;
  List<DistrictData> get districtDataList => _districtDataList;
  List<TableData> get filterTableData => _filterTableData;
  List<TableData> get tableData => _tableData;

  void set(int screen) {
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
