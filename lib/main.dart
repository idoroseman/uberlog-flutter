import 'package:flutter/material.dart';
import 'QSOView.dart';
import 'InputBox.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UBerLog',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 5,
        initialIndex: 0,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFF3F5AA6),
            title: Text("UBerLog"),
          ),
          bottomNavigationBar: menu(),
          body: TabBarView(
            children: [
              QSOView(),
              Container(child: Icon(Icons.directions_transit)),
              InputBox(),
              Container(child: Icon(Icons.directions_bike)),
              Container(child: Icon(Icons.directions_bike)),
            ],
          ),
        ),
      ),
    );
  }

  Widget menu() {
    return Container(
      color: Color(0xFF3F5AA6),
      child: TabBar(
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white70,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: EdgeInsets.all(5.0),
        indicatorColor: Colors.blue,
        tabs: [
          Tab(
            text: "Logbook",
            icon: Icon(Icons.list),
          ),
          Tab(
            text: "Map",
            icon: Icon(Icons.map),
          ),
          Tab(
            text: "Add",
            icon: Icon(Icons.add),
          ),
          Tab(
            text: "Info",
            icon: Icon(Icons.info),
          ),
          Tab(
            text: "Options",
            icon: Icon(Icons.settings),
          ),
        ],
      ),
    );
  }
}
