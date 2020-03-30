import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StatsItem extends StatelessWidget {
  final String myImage;
  final String title;
  final int increased;
  final int total;

  StatsItem({this.myImage, this.title, this.increased, this.total});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
          RichText(
//            textAlign: (isStateName) ? TextAlign.start : TextAlign.end,
            text: TextSpan(children: [
              WidgetSpan(
                child: SvgPicture.asset("assets/$myImage.svg", width: 15.0,),
              ),
              WidgetSpan(
                child: SizedBox(
                  width: 5.0,
                )
              ),
              TextSpan(
                text: title,
                style: TextStyle(
                    color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
              ),

            ]),
          ),
          SizedBox(
            height: 12,
          ),
          RichText(
//            textAlign: (isStateName) ? TextAlign.start : TextAlign.end,
            text: TextSpan(children: [
              TextSpan(
                text: "$total",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              WidgetSpan(
                child: SizedBox(
                  width: 5,
                )
              ),
              TextSpan(
                text: (increased>0) ? "+$increased" : "",
                style: TextStyle(
                    letterSpacing: 1.0,
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    color: Colors.white),
              ),
            ]),
          ),

        ],
      ),
    );
  }
}
