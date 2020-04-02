import 'package:flutter/foundation.dart';
import 'dart:async';

class Debouncer {
  final int milliseconds = 500;
  VoidCallback action;
  Timer _timer;

  run(VoidCallback action) {
    if (_timer != null) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}