import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uberlog/models/qso.dart';
import 'package:uberlog/models/user.dart';
import 'package:uberlog/screens/home/input_box.dart';
import 'package:uberlog/services/auth.dart';
import 'package:uberlog/services/database.dart';
import 'package:uberlog/screens/home/logbook_list.dart';
import 'package:uberlog/screens/home/settings_form.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    void _showSettingsPanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
              child: SettingForm(),
            );
          });
    }

    final user = Provider.of<User>(context);

    return StreamProvider<List<QSO>>.value(
      value: DatabaseService(uid: user.uid).logbook,
      child: DefaultTabController(
        length: 3,
        initialIndex: 1,
        child: Scaffold(
          backgroundColor: Colors.green[50],
          appBar: AppBar(
            title: Text("UberLog"),
            backgroundColor: Colors.green[400],
            elevation: 0.0,
            actions: [
              FlatButton.icon(
                icon: Icon(Icons.person),
                label: Text("logout"),
                onPressed: () async {
                  await _auth.signOut();
                },
              ),
              //   FlatButton.icon(
              //     icon: Icon(Icons.settings),
              //     label: Text("Settings"),
              //     onPressed: () => _showSettingsPanel(),
              //   )
            ],
          ),
          bottomNavigationBar: menu(),
          body: TabBarView(children: [
            Container(child: InputBox()),
            Container(child: LogbookList()),
            Container(child: SettingForm()),
            // Container(child: Icon(Icons.directions_transit)),
            // Container(child: Icon(Icons.directions_transit)),
          ]),
        ),
      ),
    );
  }
}

Widget menu() {
  return Container(
    color: Colors.green[500],
    child: TabBar(
      labelColor: Colors.white,
      unselectedLabelColor: Colors.white70,
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorPadding: EdgeInsets.all(5.0),
      indicatorColor: Colors.blue,
      tabs: [
        Tab(
          text: "Add",
          icon: Icon(Icons.add),
        ),
        Tab(
          text: "Logbook",
          icon: Icon(Icons.list),
        ),
        // Tab(
        //   text: "Map",
        //   icon: Icon(Icons.map),
        // ),

        // Tab(
        //   text: "Info",
        //   icon: Icon(Icons.info),
        // ),
        Tab(
          text: "Options",
          icon: Icon(Icons.settings),
        ),
      ],
    ),
  );
}
