import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_web/flutter_native_web.dart';

class WebViewScreen extends StatefulWidget {
  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  WebController webController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    FlutterNativeWeb flutterWebView = new FlutterNativeWeb(
      onWebCreated: onWebCreated,
      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
        Factory<OneSequenceGestureRecognizer>(
              () => TapGestureRecognizer(),
        ),
      ].toSet(),
    );

    return  Container(
      child: flutterWebView,
    );
  }

  void onWebCreated(webController) {
    this.webController = webController;
    this.webController.loadUrl("https://jineshsoni.github.io/covid19India-Heatmap/");
    this.webController.onPageStarted.listen((url) =>
        print("Loading $url")
    );
    this.webController.onPageFinished.listen((url) =>
        print("Finished loading $url")
    );
  }
}
