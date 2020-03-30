import 'package:covid19app/screens/myApp.dart';
import 'package:flutter/material.dart';

class NavigationScreen extends StatefulWidget {
  @override
  NavigationScreenState createState() => NavigationScreenState();
}

class NavigationScreenState extends State<NavigationScreen>
    with SingleTickerProviderStateMixin {
  TabController controller;

  void _onPressed(int index) => setState(() => jumpTo(index));

  List<Widget> _fragments = new List<Widget>();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _fragments = [MyApp()];
    controller = TabController(length: 1, vsync: this);
    controller.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    setState(() {
      _currentIndex = controller.index;
    });
  }

  @override
  void dispose() {
    // Dispose of the Tab Controller
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
      body: _fragments[_currentIndex],
      resizeToAvoidBottomPadding: true,
      bottomNavigationBar: Material(
        // set the color of the bottom navigation bar
        color: Colors.white,
        elevation: 0,
        clipBehavior: Clip.antiAlias,
        // set the tab bar as the child of bottom navigation bar
        child: Visibility(
          visible: false,
          child: TabBar(
            indicatorWeight: 2,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: <Tab>[
              Tab(
                // set icon to the tab
                icon: Icon(
                  Icons.home,
                  color: Colors.blue,
                ),
              ),
            ],
            // setup the controller
            controller: controller,
          ),
        ),
      ),
    ));
  }

  jumpTo(int position) {
    controller.index = position;
  }
}
