import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:uberlog/screens/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:uberlog/services/auth.dart';
import 'package:uberlog/models/user.dart';
// based on:
// https://www.youtube.com/watch?v=EXp0gq9kGxI&feature=emb_logo
// https://www.youtube.com/watch?v=sfA3NWDBPZ4&list=PL4cUxeGkcC9j--TKIdkb3ISfRbJeJYQwC&index=1
// https://flutteragency.com/solve-no-firebase-app-has-been-created/

Future<void> main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something Went Wrong');
        }
        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return StreamProvider<User>.value(
            value: AuthService().user,
            child: MaterialApp(
                home: FutureBuilder(
                    future: _fbApp,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        print(
                            'you have an error ! ${snapshot.error.toString()}');
                        return Text("somthing went wrong");
                      } else if (snapshot.hasData) {
                        return Wrapper();
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    })),
          );
        }
        // Otherwise, show something whilst waiting for initialization to complete
        return Text(
          "Loading",
          textDirection: TextDirection.ltr,
        );
      },
    );
  }
}
