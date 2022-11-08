import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:uberlog/models/user.dart' as ub;
import 'package:uberlog/services/database.dart';

class AuthService {
  final fb.FirebaseAuth _auth = fb.FirebaseAuth.instance;

  // create user based on firebase user
  ub.User _userFromFirebaseUser(fb.User user) {
    return user != null ? ub.User(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<ub.User> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  // sign in anon
  Future signInAnon() async {
    try {
      fb.UserCredential result = await _auth.signInAnonymously();
      fb.User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      fb.UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      fb.User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // register email & password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      fb.UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      fb.User user = result.user;
      // print(user);
      await DatabaseService(uid: user.uid)
          .updateUserData('new user', 0, 'default logbook', 'N0CALL', '', true);
      return _userFromFirebaseUser(user);
    } on fb.FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      return null;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
