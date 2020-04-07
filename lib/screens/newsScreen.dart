import 'package:covid19app/model/newsPageTimelineObject.dart';
import 'package:covid19app/network/api.dart';
import 'package:covid19app/screens/widgets/timelineNode.dart';
import 'package:covid19app/utils/commons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:transparent_image/transparent_image.dart';

class NewsWidget extends StatefulWidget {
  @override
  _NewsWidgetState createState() => _NewsWidgetState();
}

class _NewsWidgetState extends State<NewsWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "News",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Container(color: Colors.white, child: NewsPage()),
    );
  }
}

class NewsPage extends StatefulWidget {
  NewsPage({Key key}) : super(key: key);

  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  List<NewsPageTimelineObject> list = List();

  void getAllData() {
    logv(" NEWS ===== CAlling API");
    Network().getNews().then((value) {
      setState(() {
        value.forEach((element) {
          list.add(NewsPageTimelineObject(
              style: TimelineNodeStyle(
                  lineType: TimelineNodeLineType.Full,
                  lineColor: Colors.grey[300]),
              message: element.title,
              time: element.pubDate,
              image: ""));
        });
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
    return ListView.builder(
      itemCount: this.list.length,
      itemBuilder: (context, index) {
        return TimelineNode(
          style: this.list[index].style,
          indicator: SizedBox(
            width: 15,
            height: 15,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                color: Colors.grey[300],
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ClipRRect(
                  clipBehavior: Clip.antiAlias,
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    width: 82,
                    height: 70,
                    color: Colors.grey[300],
                    child: Center(
                      child: FadeInImage.memoryNetwork(
                        fit: BoxFit.cover,
                        width: 82,
                        height: 70,
                        alignment: Alignment.center,
                        placeholder: kTransparentImage,
                        image: this.list[index].image,
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
                  child: Column(
                    children: <Widget>[
                      Text(
                        this.list[index].message,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.access_time,
                            size: 20,
                            color: Colors.grey[800],
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: Text(
                              this.list[index].time,
                              style: TextStyle(fontSize: 12),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )),
              ],
            ),
          ),
        );
      },
    );
  }
}
