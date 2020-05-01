import 'package:covid19app/model/HelplineNumberModel.dart';
import 'package:covid19app/network/api.dart';
import 'package:covid19app/utils/commons.dart';
import 'package:easy_web_view/easy_web_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_phone_state/flutter_phone_state.dart';
import 'package:url_launcher/url_launcher.dart';

import 'newsDetails.dart';

class MoreWidget extends StatefulWidget {
  @override
  _MoreWidgetState createState() => _MoreWidgetState();
}

void _launchURL() async {
  const url = 'mailto:developers@thinkwik.com';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class _MoreWidgetState extends State<MoreWidget> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        width: 480,
        child: ListView(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EmergencyNumberWidget(),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Stack(
                  children: <Widget>[
                    Image.asset(
                      "assets/ic_helpline.png",
                      width: double.infinity,
                    ),
                    Positioned(
                      top: 45,
                      left: 15,
                      child: Text(
                        "Get 24x7 Helpline\nNumbers",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Positioned(
                      top: 120,
                      left: 15,
                      child: Text(
                        "State wise helpline\nnumbers >>",
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AboutUS(),
                        ),
                      );
                    },
                    child: Material(
                      color: Colors.transparent,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.grey[300]),
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Material(
                                color: Colors.blue[100],
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(color: Colors.blue[100]),
                                    borderRadius: BorderRadius.circular(25)),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Icon(
                                    Icons.info_outline,
                                    color: Colors.blueAccent,
                                    size: 20,
                                  ),
                                )),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: Text("About Us",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14)),
                            ),
                            Icon(Icons.keyboard_arrow_right),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewsDetails(
                            link:
                                "https://covid19.thinkwik.com/privacy-policy.html",
                            title: "Privacy Policy",
                          ),
                        ),
                      );
                    },
                    child: Material(
                      color: Colors.transparent,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.grey[300]),
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Material(
                                color: Colors.blue[100],
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(color: Colors.blue[100]),
                                    borderRadius: BorderRadius.circular(25)),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Icon(
                                    Icons.poll,
                                    color: Colors.blueAccent,
                                    size: 20,
                                  ),
                                )),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: Text("Privacy Policy",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14)),
                            ),
                            Icon(Icons.keyboard_arrow_right),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  GestureDetector(
                    onTap: () {
                      _launchURL();
                    },
                    child: Material(
                      color: Colors.transparent,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.grey[300]),
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Material(
                                color: Colors.blue[100],
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(color: Colors.blue[100]),
                                    borderRadius: BorderRadius.circular(25)),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Icon(
                                    Icons.email,
                                    color: Colors.blueAccent,
                                    size: 20,
                                  ),
                                )),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: Text("Feedback",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14)),
                            ),
                            Icon(Icons.keyboard_arrow_right),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class EmergencyNumberWidget extends StatefulWidget {
  @override
  _EmergencyNumberWidgetState createState() => _EmergencyNumberWidgetState();
}

class _EmergencyNumberWidgetState extends State<EmergencyNumberWidget>
    with WidgetsBindingObserver {
  List<HelplineNumberModel> list = List();

  void getAllData() {
    logv(" Helpline ===== CAlling API");
    Network().getHelplineNumber().then((value) {
      setState(() {
        list.clear();
        list.addAll(value);
      });
    });
  }

  @override
  void didChangeAppLifecycleState(final AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      getAllData();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    getAllData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void makeCall(String _phoneNumber) {
      FlutterPhoneState.startPhoneCall(_phoneNumber);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Helpline Numbers",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: <Widget>[
          Center(
              child: Container(
            color: Colors.white,
            child: ListView.builder(
                itemCount: this.list.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Material(
                      color: Colors.transparent,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.grey[300]),
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(this.list[index].loc,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 14)),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Text(this.list[index].number,
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black,
                                          fontSize: 12)),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                makeCall(this.list[index].number);
                              },
                              child: Expanded(
                                child: Material(
                                    color: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Colors.blueAccent),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(12, 6, 12, 6),
                                        child: Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.phone,
                                              size: 14,
                                              color: Colors.blueAccent,
                                            ),
                                            SizedBox(
                                              width: 4.0,
                                            ),
                                            Text(
                                              "Call",
                                              style: TextStyle(
                                                  color: Colors.blueAccent,
                                                  fontSize: 12),
                                            )
                                          ],
                                        ))),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          )),
          Center(
              child: Visibility(
                  visible: this.list.length == 0,
                  child: CircularProgressIndicator())),
        ],
      ),
    );
  }
}

class AboutUS extends StatefulWidget {
  @override
  _AboutUSState createState() => _AboutUSState();
}

class _AboutUSState extends State<AboutUS> {
  String aboutUs = "";
  void getAllData() {
    logv(" About US ===== CAlling API");
    Network().getAboutUsContent().then((value) {
      setState(() {
        aboutUs = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getAllData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "About Us",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
        body: Stack(
          children: <Widget>[
            Center(child: CircularProgressIndicator()),
            Center(
              child: Visibility(
                visible: aboutUs.isNotEmpty,
                child: EasyWebView(
                  src: aboutUs,
                  isHtml: false, // Use Html syntax
                  isMarkdown: true, // Use markdown syntax
                  convertToWidets: false, // Try to convert to flutter widgets
                ),
              ),
            )
          ],
        ));
  }
}
