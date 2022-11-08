import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uberlog/models/qso.dart';
import 'package:uberlog/screens/home/qso_tile.dart';

class LogbookList extends StatefulWidget {
  @override
  _LogbookListState createState() => _LogbookListState();
}

class _LogbookListState extends State<LogbookList> {
  TextEditingController _textController = TextEditingController();
  String filterText = "";

  onItemChanged(String value) {
    setState(() {
      filterText = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final qsos = Provider.of<List<QSO>>(context) ?? [];
    qsos.sort((a, b) => a.compareTo(b));
    final List<QSO> filterdQsos = qsos
        .where((qso) =>
            qso.data['CALL'].toLowerCase().contains(filterText.toLowerCase()))
        .toList();
    return Column(children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(12.0),
        child: TextField(
          controller: _textController,
          decoration: InputDecoration(
            hintText: 'Search Here...',
            suffixIcon: IconButton(
              onPressed: () {
                _textController.clear();
                setState(() {
                  filterText = '';
                });
              },
              icon: Icon(Icons.clear),
            ),
          ),
          onChanged: onItemChanged,
        ),
      ),
      Expanded(
        child: ListView.builder(
          itemCount: filterdQsos.length,
          itemBuilder: (context, index) {
            return QsoTile2(qso: filterdQsos[index]);
          },
        ),
      ),
    ]);
  }
}
