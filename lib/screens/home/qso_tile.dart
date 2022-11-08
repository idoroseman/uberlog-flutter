import 'package:flutter/material.dart';
import 'package:uberlog/models/qso.dart';
import 'package:intl/intl.dart';

class QsoTile extends StatelessWidget {
  final QSO qso;
  QsoTile({this.qso});

  @override
  Widget Flag(countryCode) {
    String flag = countryCode.toUpperCase().replaceAllMapped(RegExp(r'[A-Z]'),
        (match) => String.fromCharCode(match.group(0).codeUnitAt(0) + 127397));
    return Text(flag, style: TextStyle(fontSize: 22.0));
  }

  Widget build(BuildContext context) {
    bool hasLocation = qso.data['QTH'] != "" || qso.data['GRID'] != '';
    String imgSrc = '';
    if (qso.data['image_eqslcc_'] != null)
      imgSrc = qso.data['image_eqslcc_'];
    else if (qso.data['image_qrzcom_'] != null)
      imgSrc = qso.data['image_qrzcom_'];

    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
          margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imgSrc != ''
                    ? NetworkImage(imgSrc)
                    : AssetImage("assets/bg_340x270.jpg"),
                fit: BoxFit.fitWidth,
                alignment: Alignment.topCenter,
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(qso.data['CALL'],
                        style: TextStyle(
                          fontSize: 22.0,
                          backgroundColor: Colors.grey.withOpacity(0.5),
                        )),
                    Spacer(),
                    Text(qso.data["QSO_DATE"],
                        // DateFormat("yyyy-MM-dd HH:mm")
                        //     .format(qso.data['timestamp_'])
                        //     .toString(),
                        style: TextStyle(
                            fontSize: 22.0,
                            backgroundColor: Colors.grey.withOpacity(0.5))),
                    Text(" "),
                    Text(qso.data['TIME_ON'],
                        style: TextStyle(
                            fontSize: 22.0,
                            backgroundColor: Colors.grey.withOpacity(0.5))),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 80.0),
                  child: Row(children: [
                    Text(qso.data['COUNTRY'] ?? ''),
                    Flag(qso.data['flag_'] ?? ""),
                    Spacer(),
                    if (qso.data['PROP_MODE'] == 'SAT') Icon(Icons.satellite),
                    Text(qso.data['MODE'] ?? ""),
                    Text(" "),
                    // Text(NumberFormat.compact().format(qso.freq * 1000000))
                  ]),
                ),
                Row(children: [
                  Text(""),
                  Spacer(),
                ]),
                Row(
                  children: [
                    if (qso.data['NAME'] != "") Icon(Icons.person),
                    if (qso.data['NAME'] != "") Text(qso.data['NAME']),
                    if (hasLocation) Icon(Icons.location_on),
                    if (hasLocation)
                      Text(qso.data['QTH'] == ""
                              ? qso.data['GRID'] ?? ''
                              : qso.data["QTH"]) ??
                          '',
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
              ],
            ),
          )),
    );
  }
}

class QsoTile2 extends StatelessWidget {
  final QSO qso;
  QsoTile2({this.qso});

  @override
  Widget Flag(countryCode) {
    String flag = countryCode.toUpperCase().replaceAllMapped(RegExp(r'[A-Z]'),
        (match) => String.fromCharCode(match.group(0).codeUnitAt(0) + 127397));
    return Text(flag, style: TextStyle(fontSize: 22.0));
  }

  @override
  Widget build(BuildContext context) {
    bool hasLocation = qso.data['QTH'] != "" || qso.data['GRID'] != '';
    bool has_eqsl_qsl =
        (qso.data['QSL_RCVD'] == "Y") && (qso.data['QSL_RCVD_VIA'] == "E");
    bool has_lotw_qsl = qso.data.containsKey('APP_LOTW_MODEGROUP');
    bool has_qrzcom_qsl = qso.data['APP_QRZLOG_STATUS'] == "C";
    bool has_clublog_qsl = qso.data['APP_CLUBLOG_STATUS'] == "C";
    bool has_qsl_rcvd = has_eqsl_qsl || has_lotw_qsl || has_qrzcom_qsl;
    bool has_qsl_sent = qso.data['QSL_SENT'] == "Y";

    String imgSrc = '';
    if (qso.data['eqslcc_image_url_'] != null)
      imgSrc = qso.data['eqslcc_image_url_'];
    else if (qso.data['qrzcom_image_url_'] != null)
      imgSrc = qso.data['qrzcom_image_url_'];

    return Padding(
      padding: EdgeInsets.only(top: 0.0),
      child: Card(
        child: ListTile(
          leading: Image(
            image: imgSrc != ''
                ? NetworkImage(imgSrc)
                : AssetImage("assets/bg_340x270.jpg"),
            fit: BoxFit.fill,
          ),
          title: Row(
            children: [
              Text(qso.data['CALL']),
              Spacer(),
              Text(
                qso.data["QSO_DATE"],
                // DateFormat("yyyy-MM-dd HH:mm")
                //     .format(qso.data['timestamp_'])
                //     .toString(),
              ),
              Text(" "),
              Text(qso.data['TIME_ON']),
            ],
          ),
          subtitle: Column(
            children: [
              Row(children: [
                Flag(qso.data['flag_'] ?? ""),
                Text(qso.data['COUNTRY'] ?? ""),
                if (hasLocation) Icon(Icons.location_on),
                if (hasLocation)
                  Text(qso.data['QTH'] == null
                          ? qso.data['GRID'] ?? ''
                          : qso.data["QTH"]) ??
                      '',
                if (qso.data['NAME'] != null) Icon(Icons.person),
                if (qso.data['NAME'] != null) Text(qso.data['NAME']),
              ]),
              Row(
                children: [
                  if (qso.data['PROP_MODE'] == 'SAT') Icon(Icons.satellite),
                  Text(qso.data['MODE'] ?? ''),
                  Text(" "),
                  Text(qso.data['FREQ'].toString() ?? ''),
                  Spacer(),
                  Text("S"),
                  Checkbox(
                    value: has_qsl_sent,
                    onChanged: (value) => {},
                  ),
                  Text("R"),
                  Checkbox(
                    value: has_qsl_rcvd,
                    onChanged: (value) => {},
                  )
                ],
              ),
            ],
          ),
          // trailing: Icon(Icons.more_vert),
          isThreeLine: true,
        ),
      ),
    );
  }
}
