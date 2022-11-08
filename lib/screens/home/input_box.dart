import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uberlog/models/user.dart';
import 'package:uberlog/services/database.dart';

class InputBox extends StatefulWidget {
  @override
  _InputBoxState createState() => _InputBoxState();
}

class _InputBoxState extends State<InputBox> {
  final _formKey = GlobalKey<FormState>();
  final _textInputController = TextEditingController();

  final RegExp callsignRegExp = new RegExp(
      r"([a-zA-Z0-9]{1,2}\/)?[a-zA-Z0-9]{1,2}\d{1,4}[a-zA-Z]{1,4}(\/[a-zA-Z0-9]{1,2})?");

  String _callsign;
  String _name;
  String _qth;
  String _grid;
  String _his;
  String _mine;
  String _freq;
  String _comment;
  String _date;
  String _time;

  @override
  void initState() {
    super.initState();
    _textInputController.addListener(_printLatestValue);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    _textInputController.dispose();
    super.dispose();
  }

  _printLatestValue() {
    int reportCount = 0;
    LineSplitter ls = new LineSplitter();
    List<String> lines = ls.convert(_textInputController.text);
    for (var i = 0; i < lines.length; i++) {
      if (isCallsign(lines[i]))
        setState(() {
          _callsign = lines[i].toUpperCase().trim();
        });
      else if (isSignalReport(lines[i])) {
        if (reportCount == 0)
          setState(() {
            _his = lines[i].trim();
          });
        else
          setState(() {
            _mine = lines[i].trim();
          });
        reportCount++;
      } else if (isGrid(lines[i]))
        setState(() {
          _grid = lines[i].trim();
        });
      else if (isDate(lines[i]) || isTime(lines[i])) {
      } else if (isFreq(lines[i]))
        setState(() {
          _freq = lines[i];
        });
      else if (lines[i].toLowerCase().startsWith("n "))
        setState(() {
          _name = lines[i].substring(2).trim();
        });
      else if (lines[i].toLowerCase().startsWith("q "))
        setState(() {
          _qth = lines[i].substring(2).trim();
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${_callsign ?? "callsign"}',
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
          Text('Report His ${_his ?? "..."} Mine ${_mine ?? "..."}'),
          Text('Name ${_name ?? "..."}'),
          Text('QTH ${_qth ?? "..."}'),
          Text('Qountry ...'),
          Text(''),
          Divider(
            color: Colors.black,
            height: 20,
            thickness: 1,
            indent: 0,
            endIndent: 0,
          ),
          TextField(
              keyboardType: TextInputType.multiline,
              minLines: 5, // Normal textInputField will be displayed
              maxLines: 7, // when user presses enter it will adapt to it
              controller: _textInputController),
          Row(children: [
            RaisedButton(
                color: Colors.pink[400],
                child: Text("Update", style: TextStyle(color: Colors.white)),
                onPressed: () async {
                  await DatabaseService(uid: user.uid)
                      .createQso(Map<String, dynamic>.from({
                    'CALL': _callsign,
                    'NAME': _name,
                    'QTH': _qth,
                    'GRID': _grid,
                    'RST_SENT': _his,
                    'RST_RCVD': _mine,
                    'FREQ': _freq,
                    'COMMENT': _comment,
                    'QSO_DATE': _date ??
                        new DateFormat('yyyyMMdd').format(new DateTime.now()),
                    'TIME_ON': _time ??
                        new DateFormat('HHmm').format(new DateTime.now())
                  }));
                  _textInputController.clear();
                  FocusScope.of(context).unfocus();
                }),
            RaisedButton(
                color: Colors.grey[400],
                child: Text("Clear", style: TextStyle(color: Colors.white)),
                onPressed: () {
                  _textInputController.clear();
                  setState(() {
                    _callsign = null;
                    _name = null;
                    _qth = null;
                    _grid = null;
                    _his = null;
                    _mine = null;
                    _freq = null;
                  });
                  FocusScope.of(context).unfocus();
                }),
          ])
        ],
      ),
    );
  }

  bool isCallsign(String lin) {
    return callsignRegExp.hasMatch(lin);
  }

  bool isSignalReport(String lin) {
    RegExp regExp1 = new RegExp(r"^\s*[1-5][1-9][1-9]?(\+\d0)?$");
    RegExp regExp2 = new RegExp(r"^\s*[\-\+]\d{1,2}$");
    return regExp1.hasMatch(lin) || regExp2.hasMatch(lin);
  }

  bool isGrid(String lin) {
    RegExp regExp = new RegExp(r"^[a-zA-Z]{2}\d{2}([a-zA-Z]{2})?$");
    return regExp.hasMatch(lin);
  }

  bool isDate(String lin) {
    RegExp regExp = new RegExp(r"\d{1,2}\/\d{1,2}\/\d{2,4}");
    return regExp.hasMatch(lin);
  }

  bool isTime(String lin) {
    RegExp regExp = new RegExp(r"\d{1,2}\:\d\d");
    return regExp.hasMatch(lin);
  }

  bool isFreq(String lin) {
    RegExp regExp = new RegExp(r"\d{1,2}\.\d{2,3}");
    return regExp.hasMatch(lin);
  }
}
