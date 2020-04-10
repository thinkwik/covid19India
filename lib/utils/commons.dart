import 'package:flutter/material.dart';

final bool showLog = true;

void logv(String message) {
  if (showLog) print(message);
}

class HEX {
  static Color primaryColor = _colorFromHex("#00184C");
  static Color symptomColor = _colorFromHex("#F5F9FF");

  static Color _colorFromHex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }
}
