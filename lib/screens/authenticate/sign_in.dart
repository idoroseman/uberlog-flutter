import 'package:flutter/material.dart';
import 'package:uberlog/services/auth.dart';
import 'package:uberlog/shared/constants.dart';
import 'package:uberlog/shared/loading.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.green[100],
            appBar: AppBar(
              backgroundColor: Colors.green[400],
              elevation: 0.0,
              title: Text("Sign in to UberLog"),
              actions: [
                FlatButton.icon(
                  icon: Icon(Icons.person),
                  label: Text("Register"),
                  onPressed: () {
                    widget.toggleView();
                  },
                )
              ],
            ),
            body: Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                child: Form(
                  key: _formKey,
                  child: Column(children: <Widget>[
                    SizedBox(height: 20.0),
                    TextFormField(
                      decoration:
                          textInputDecoration.copyWith(hintText: 'Email'),
                      validator: (val) => val.isEmpty ? "Enter an email" : null,
                      onChanged: (value) {
                        setState(() {
                          email = value;
                        });
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      decoration:
                          textInputDecoration.copyWith(hintText: 'Password'),
                      validator: (val) => val.length < 6
                          ? "Enter a password 6+ characters long"
                          : null,
                      obscureText: true,
                      onChanged: (value) {
                        setState(() {
                          password = value;
                        });
                      },
                    ),
                    SizedBox(height: 20.0),
                    RaisedButton(
                      color: Colors.pink[400],
                      child: Text(
                        "Sign In",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          setState(() {
                            loading = true;
                          });
                          dynamic result = await _auth
                              .signInWithEmailAndPassword(email, password);
                          if (result == null) {
                            setState(() {
                              loading = false;
                              error =
                                  'could not sign in with those credentials ';
                            });
                          }
                        }
                      },
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      error,
                      style: TextStyle(color: Colors.red, fontSize: 14.0),
                    )
                  ]),
                )),
          );
  }
}
