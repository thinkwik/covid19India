import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

final bool showLog = true;

void logv(String message) {
  if (showLog) print(message);
}

class HEX {
  static Color primaryColor = _colorFromHex("#00184C");

  static Color _colorFromHex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }
}
