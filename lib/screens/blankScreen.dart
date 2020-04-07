
import 'package:flutter/material.dart';

class BlankScreen extends StatefulWidget {
  @override
  _BlankScreenState createState() => _BlankScreenState();
}

class _BlankScreenState extends State<BlankScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          "Hello world"
        ),
      ),
    );
  }
}
