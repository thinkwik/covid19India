import 'package:easy_web_view/easy_web_view.dart';
import 'package:flutter/material.dart';

class WebViewScreen extends StatefulWidget {
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
    return EasyWebView(
      src: "https://jineshsoni.github.io/covid19India-Heatmap/",
      isHtml: false, // Use Html syntax
      isMarkdown: false, // Use markdown syntax
      convertToWidets: false, // Try to convert to flutter widgets
    );
  }
}
