import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uberlog/models/user.dart';
import 'package:uberlog/shared/constants.dart';
import 'package:uberlog/services/database.dart';
import 'package:uberlog/shared/loading.dart';

class SettingForm extends StatefulWidget {
  @override
  _SettingFormState createState() => _SettingFormState();
}

class _SettingFormState extends State<SettingForm> {
  final _formKey = GlobalKey<FormState>();

  String _currentName;
  int _currentLogbook = 0;
  String _currentTitle;
  String _currentCallsign;
  String _currentGrid;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
            return Form(
              key: _formKey,
              child: Column(
                children: [
                  // name
                  Text("Update your settings",
                      style: TextStyle(fontSize: 18.0)),
                  TextFormField(
                    initialValue: userData.name,
                    decoration: textInputDecoration.copyWith(labelText: 'name'),
                    validator: (val) =>
                        val.isEmpty ? "please enter a name" : null,
                    onChanged: (val) => setState(() => _currentName = val),
                  ),
                  SizedBox(height: 20.0),
                  // logbook
                  DropdownButtonFormField(
                    value: _currentLogbook.toString(),
                    decoration:
                        textInputDecoration.copyWith(labelText: 'logbook'),
                    items: userData.logbooks.keys.toList().map((item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(userData.logbooks[item]['title'] == ''
                            ? 'Unnamed'
                            : userData.logbooks[item]['title']),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => _currentLogbook = val),
                  ),
                  SizedBox(height: 10.0),
                  // title
                  TextFormField(
                    initialValue: userData.logbooks[_currentLogbook.toString()]
                        ['title'],
                    decoration:
                        textInputDecoration.copyWith(labelText: 'description'),
                    validator: (val) =>
                        val.isEmpty ? "please enter logbook description" : null,
                    onChanged: (val) => setState(() => _currentTitle = val),
                  ),
                  SizedBox(height: 10.0),

                  // callsign
                  TextFormField(
                    initialValue: userData.logbooks[_currentLogbook.toString()]
                        ['callsign'],
                    decoration:
                        textInputDecoration.copyWith(labelText: 'callsign'),
                    validator: (val) =>
                        val.isEmpty ? "please enter your callsign" : null,
                    onChanged: (val) => setState(() => _currentCallsign = val),
                  ),
                  SizedBox(height: 20.0),
                  // grid locator
                  TextFormField(
                    initialValue: userData.logbooks[_currentLogbook.toString()]
                        ['grid'],
                    decoration: textInputDecoration.copyWith(labelText: 'grid'),
                    validator: (val) =>
                        val.isEmpty ? "please your grid locator" : null,
                    onChanged: (val) => setState(() => _currentGrid = val),
                  ),
                  SizedBox(height: 20.0),
                  RaisedButton(
                    color: Colors.pink[400],
                    child:
                        Text("Update", style: TextStyle(color: Colors.white)),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        await DatabaseService(uid: user.uid).updateUserData(
                            _currentName ?? userData.name,
                            _currentLogbook,
                            _currentTitle ??
                                userData.logbooks[_currentLogbook.toString()]
                                    ['title'],
                            _currentCallsign ??
                                userData.logbooks[_currentLogbook.toString()]
                                    ['callsign'],
                            _currentGrid ??
                                userData.logbooks[_currentLogbook.toString()]
                                    ['grid'],
                            true);
                        // Navigator.pop(context);
                      }
                    },
                  )
                ],
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}
