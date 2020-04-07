import 'package:covid19app/model/screenSwitcher.dart';
import 'package:covid19app/screens/HomeScreen.dart';
import 'package:covid19app/screens/blankScreen.dart';
import 'package:covid19app/screens/newsScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavigationScreen extends StatefulWidget {
  @override
  NavigationScreenState createState() => NavigationScreenState();
}

class NavigationScreenState extends State<NavigationScreen>
    with SingleTickerProviderStateMixin {
  TabController controller;

  void _onPressed(int index) => setState(() => jumpTo(index));

  List<Widget> _fragments = List<Widget>();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _fragments = [
      MultiProvider(providers: [
        ChangeNotifierProvider<ScreenBloc>(create: (_) => ScreenBloc()),
        ChangeNotifierProvider<ChartBloc>(create: (_) => ChartBloc()),
      ], child: HomeScreen()),
      NewsWidget()
    ];
    controller = TabController(length: 2, vsync: this);
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
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _fragments,
      ),
//      body: _fragments[_currentIndex],
      resizeToAvoidBottomPadding: true,
      bottomNavigationBar: Material(
        // set the color of the bottom navigation bar
        color: Colors.white,
        elevation: 0,
        clipBehavior: Clip.antiAlias,
        // set the tab bar as the child of bottom navigation bar
        child: Visibility(
          visible: true,
          child: TabBar(
            indicatorWeight: 2,
            indicatorSize: TabBarIndicatorSize.label,
            labelColor: Colors.blue[800],
            unselectedLabelColor: Colors.grey[300],
            indicatorColor: Colors.transparent,
            tabs: <Tab>[
              Tab(
                text: "Home",
                // set icon to the tab
                icon: Icon(
                  Icons.home,
                ),
              ),
              Tab(
                text: "News",
                // set icon to the tab
                icon: Icon(
                  Icons.network_wifi,
                ),
              ),
            ],
            // setup the controller
            controller: controller,
          ),
        ),
      ),
    );
  }

  jumpTo(int position) {
    controller.index = position;
  }
}
