import 'dart:math';

import 'package:flutter/material.dart';
import 'package:uberlog/screens/home/home.dart';
import 'package:uberlog/screens/authenticate/authenticate.dart';
import 'package:provider/provider.dart';
import 'package:uberlog/models/user.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    if (user == null)
      return Authenticate();
    else
      return Home();
  }
}
