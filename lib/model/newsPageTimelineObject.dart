import 'package:covid19app/screens/widgets/timelineNode.dart';

class NewsPageTimelineObject {
  final TimelineNodeStyle style;
  final String message;
  final String time;
  final String image;
  final String overridelink;
  final String smalldesc;

  NewsPageTimelineObject({this.style, this.message, this.time, this.image, this.overridelink, this.smalldesc});
}