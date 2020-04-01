import 'package:flutter/material.dart';

class ScreenBloc extends ChangeNotifier {
  int _screenName = 1;
  String _stateName = "";
  int get screen => _screenName;
  String get stateName => _stateName;

  void set(int screen) {
    _screenName = screen;
    notifyListeners();
  }

  void setStateName(String name) {
    _stateName = name;
    notifyListeners();
  }

  void setForDistrict(int screen, String name) {
    _screenName = screen;
    _stateName = name;
    notifyListeners();
  }
}
