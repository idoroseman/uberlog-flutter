import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'qso.dart';

class QSOView extends StatelessWidget {
  final List<QSO> tripsList = [
    QSO("DK1MHW", DateTime.now(), "Germany", 10000, "SSB"),
    QSO("IK4OLQ", DateTime.now(), "Italy", 10000, "SSB"),
    QSO("R9LR", DateTime.now(), "Russia", 10000, "SSB"),
    QSO("J28PJ", DateTime.now(), "Djibouti", 10000, "SSB"),
    QSO("ZS6CNC", DateTime.now(), "South Africa", 10000, "SSB"),
    QSO("MM0TWX", DateTime.now(), "England", 10000, "SSB"),
    QSO("DF7DQ", DateTime.now(), "Germany", 10000, "SSB"),
    QSO("OE5GAN", DateTime.now(), "Austria", 14, "PSK"),
    QSO("IZ8IFL", DateTime.now(), "Italy", 14, "PSK"),
    QSO("SQ2HL", DateTime.now(), "Poland", 14, "PSK"),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new ListView.builder(
          itemCount: tripsList.length,
          itemBuilder: (BuildContext context, int index) =>
              buildQsoCard(context, index)),
    );
  }

  Widget flag(countryCode) {
    String flag = countryCode.toUpperCase().replaceAllMapped(RegExp(r'[A-Z]'),
        (match) => String.fromCharCode(match.group(0).codeUnitAt(0) + 127397));
    return Text(flag);
  }

  Widget buildQsoCard(BuildContext context, int index) {
    final qso = tripsList[index];

    return new Container(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  qso.callsign,
                  style: new TextStyle(fontSize: 22.0),
                ),
                Spacer(),
                Text(
                  DateFormat("yyyy-MM-dd HH:mm")
                      .format(qso.startDate)
                      .toString(),
                  style: new TextStyle(fontSize: 22.0),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 80.0),
              child: Row(
                children: <Widget>[
                  Text(qso.country),
                  flag("il"),
                  Spacer(),
                  Icon(Icons.satellite),
                  Text(qso.mode),
                  Text(" "),
                  Text(NumberFormat.compact().format(qso.freq * 1000000))
                ],
              ),
            ),
            Row(children: [
              Text(""),
              Spacer(),
            ]),
            Row(
              children: [
                Icon(Icons.person),
                Text("Hans"),
                Icon(Icons.location_on),
                Text("London"),
                Spacer(),
                Text("S"),
                Checkbox(
                  value: true,
                  onChanged: (value) => {},
                ),
                Text("R"),
                Checkbox(
                  value: true,
                  onChanged: (value) => {},
                )
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
