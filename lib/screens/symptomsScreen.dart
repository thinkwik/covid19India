import 'package:covid19app/utils/commons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class SymptomsWidget extends StatefulWidget {
  @override
  _SymptomsWidgetState createState() => _SymptomsWidgetState();
}

class _SymptomsWidgetState extends State<SymptomsWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Covid19",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        child: Center(
            child: Container(
          width: 480,
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(30, 30, 30, 0),
                    decoration: BoxDecoration(
                      color: HEX.symptomColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(0),
                          topRight: Radius.circular(50),
                          bottomLeft: Radius.circular(0),
                          bottomRight: Radius.circular(50)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(120, 25, 20, 25),
                      child: Text(
                        "HEADACHE",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                    ),
                  ),
                  Image.asset(
                    "assets/ic_symptoms_1.png",
                    width: 135,
                    height: 135,
                  ),
                ],
              ),
              SizedBox(height: 5),
              Stack(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(30, 23, 30, 0),
                    decoration: BoxDecoration(
                      color: HEX.symptomColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(0),
                          topRight: Radius.circular(50),
                          bottomLeft: Radius.circular(0),
                          bottomRight: Radius.circular(50)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(120, 25, 20, 25),
                      child: Text(
                        "COUGH AND SNEEZE",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                    child: Image.asset(
                      "assets/ic_symptoms_2.png",
                      width: 110,
                      height: 110,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Stack(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(30, 23, 30, 0),
                    decoration: BoxDecoration(
                      color: HEX.symptomColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(0),
                          topRight: Radius.circular(50),
                          bottomLeft: Radius.circular(0),
                          bottomRight: Radius.circular(50)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(120, 25, 20, 25),
                      child: Text(
                        "HIGH FEVER",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                    child: Image.asset(
                      "assets/ic_symptoms_3.png",
                      width: 110,
                      height: 110,
                    ),
                  ),
                ],
              ),
              Stack(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(30, 35, 30, 0),
                    decoration: BoxDecoration(
                      color: HEX.symptomColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(0),
                          topRight: Radius.circular(50),
                          bottomLeft: Radius.circular(0),
                          bottomRight: Radius.circular(50)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(120, 25, 20, 25),
                      child: Text(
                        "SORE THROAT",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                    ),
                  ),
                  Image.asset(
                    "assets/ic_symptoms_4.png",
                    width: 150,
                    height: 150,
                  ),
                ],
              )
            ],
          ),
        )),
      ),
    );
  }
}
