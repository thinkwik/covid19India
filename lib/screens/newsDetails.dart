import 'package:covid19app/screens/webview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NewsDetails extends StatelessWidget {
  final String link;
  final String title;

  NewsDetails({this.link, this.title});

  @override
  Widget build(BuildContext context) {

    return WebViewScreen(
      link: link,
      title: title,
      backEnabled: true,
    );
  }
}
