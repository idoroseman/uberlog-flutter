import 'package:flutter/material.dart';

// see https://medium.com/@yashodgayashan/flutter-dropdown-button-widget-469794c886d0

class InputBox extends StatelessWidget {
  final _textInputController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _name = "4X6UB";
  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              '$_name',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            Text('Report His ... Mine ...'),
            Text('Name ...'),
            Text('QTH ...'),
            Text('Qountry ...'),
            Text(''),
            const Divider(
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
          ],
        ));
  }
}
