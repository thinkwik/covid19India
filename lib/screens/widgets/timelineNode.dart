import 'package:flutter/material.dart';

enum TimelineNodeType { Left, Right }
enum TimelineNodeLineType { None, Full, TopHalf, BottomHalf }

class TimelineNodeStyle {
  TimelineNodeType type;
  TimelineNodeLineType lineType;
  Color lineColor;
  double lineWidth;
  double preferredWidth;

  TimelineNodeStyle(
      {this.type = TimelineNodeType.Left,
        this.lineType = TimelineNodeLineType.None,
        this.lineColor = Colors.grey,
        this.lineWidth = 2,
        this.preferredWidth = 50});
}

class TimelineNode extends StatefulWidget {
  final TimelineNodeStyle style;
  final Widget indicator;
  final Widget child;

  TimelineNode({Key key, this.style, this.indicator, this.child})
      : super(key: key);

  _TimelineNodeState createState() => _TimelineNodeState();
}

class _TimelineNodeState extends State<TimelineNode> {
  Widget layout() {
    Widget nodeLine = Container(
      width: this.widget.style.preferredWidth,
      height: double.infinity,
      child: Stack(
        alignment: this.widget.style.lineType == TimelineNodeLineType.Full ? Alignment.topCenter : Alignment.center ,
        children: <Widget>[
          SizedBox.expand(
            child: CustomPaint(
              painter: TimelineNodeLinePainter(style: this.widget.style),
            ),
          ),
          this.widget.indicator
        ],
      ),
    );
    Widget nodeContent = Expanded(child: this.widget.child);
    List<Widget> nodeRowChildren = [];
    switch (this.widget.style.type) {
      case TimelineNodeType.Left:
        nodeRowChildren.add(nodeLine);
        nodeRowChildren.add(nodeContent);
        break;
      case TimelineNodeType.Right:
        nodeRowChildren.add(nodeContent);
        nodeRowChildren.add(nodeLine);
        break;
    }
    return IntrinsicHeight(
      child: Row(
        children: nodeRowChildren,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return layout();
  }
}

class TimelineNodeLinePainter extends CustomPainter {
  TimelineNodeStyle style;

  TimelineNodeLinePainter({this.style});

  @override
  void paint(Canvas canvas, Size size) {
    Paint linePaint = Paint();
    linePaint.color = this.style.lineColor;
    linePaint.strokeWidth = this.style.lineWidth;
    switch (this.style.lineType) {
      case TimelineNodeLineType.None:
        break;
      case TimelineNodeLineType.Full:
        canvas.drawLine(Offset(size.width / 2, 0),
            Offset(size.width / 2, size.height), linePaint);
        break;
      case TimelineNodeLineType.TopHalf:
        canvas.drawLine(Offset(size.width / 2, 0),
            Offset(size.width / 2, size.height / 2), linePaint);
        break;
      case TimelineNodeLineType.BottomHalf:
        canvas.drawLine(Offset(size.width / 2, size.height / 2),
            Offset(size.width / 2, size.height), linePaint);
        break;
    }
  }

  @override
  bool shouldRepaint(TimelineNodeLinePainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(TimelineNodeLinePainter oldDelegate) => false;
}
