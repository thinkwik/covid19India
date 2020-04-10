import 'package:easy_web_view/easy_web_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WebViewScreen extends StatefulWidget {
  final String link;
  final String title;
  final bool backEnabled;

  WebViewScreen({this.link, this.title, this.backEnabled});

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.backEnabled)
      return EasyWebView(
        src: widget.link,
        isHtml: false, // Use Html syntax
        isMarkdown: false, // Use markdown syntax
        convertToWidets: false, // Try to convert to flutter widgets
      );
    else {
      SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(statusBarColor: Colors.white));

      return Scaffold(
          appBar: AppBar(
            title: Text(
              widget.title,
              style: TextStyle(color: Colors.black),
            ),
            iconTheme: IconThemeData(color: Colors.black),
            centerTitle: true,
            backgroundColor: Colors.white,
          ),
          body: EasyWebView(
            src: widget.link,
            isHtml: false, // Use Html syntax
            isMarkdown: false, // Use markdown syntax
            convertToWidets: false, // Try to convert to flutter widgets
          ));
    }
  }
}
