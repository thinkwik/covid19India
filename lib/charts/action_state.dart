import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mp_chart/mp/controller/line_chart_controller.dart';

abstract class ActionState<T extends StatefulWidget> extends State<T> {

}

abstract class LineActionState<T extends StatefulWidget>
    extends ActionState<T> {
  LineChartController controller;
}
