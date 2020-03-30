import 'package:flutter/material.dart';

class StatsItem extends StatelessWidget {
  final Color myColor;
  final String title;
  final int increased;
  final int total;

  StatsItem({this.myColor, this.title, this.increased, this.total});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
                color: myColor, fontSize: 12, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            (increased>0) ? "[+$increased]" : "",
            style: TextStyle(
                color: myColor, fontSize: 12, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "$total",
            style: TextStyle(
                color: myColor, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
