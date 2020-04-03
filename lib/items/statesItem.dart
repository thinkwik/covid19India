import 'package:flutter/material.dart';

class StatsItem extends StatelessWidget {
  final String myImage;
  final String title;
  final int increased;
  final int total;

  StatsItem({this.myImage, this.title, this.increased, this.total});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Image.asset(
                  "assets/$myImage.png",
                  width: 15.0,
                ),
                SizedBox(
                  width: 5.0,
                ),
                Text(
                  title,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              children: <Widget>[
                Text(
                  "$total",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  (increased > 0) ? "+$increased" : "",
                  style: TextStyle(
                      letterSpacing: 1.0,
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: Colors.white),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class GraphDataItem extends StatelessWidget {
  final String myImage;
  final String title;
  final Color myColor;
  final int total;

  GraphDataItem({this.myImage, this.title, this.myColor, this.total});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Image.asset(
                  "assets/$myImage.png",
                  width: 15.0,
                ),
                SizedBox(
                  width: 5.0,
                ),
                Text(
                  title,
                  style: TextStyle(
                      color: myColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              children: <Widget>[
                Text(
                  "$total",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600]),
                ),
                SizedBox(
                  width: 5,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
