import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uberlog/models/ham.dart';
import 'package:uberlog/models/qso.dart';
import 'package:uberlog/models/user.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  final CollectionReference hamsCollection =
      FirebaseFirestore.instance.collection('hams');

  Future updateUserData(String name, int index, String title, String callsign,
      String grid, bool isDefault) async {
    DocumentSnapshot result = await hamsCollection.doc(uid).get();
    var doc = result.data() ??
        {
          'name': name,
          'defaultLog': 0,
          'logbooks': {
            index.toString(): {'title': '', 'callsign': '', 'grid': ''}
          }
        };
    doc['name'] = name;
    doc['logbooks'][index.toString()] = {
      'title': title,
      'callsign': callsign,
      'grid': grid
    };
    return await hamsCollection.doc(uid).set(doc);
  }

  // ham from snapshot
  List<Ham> _hamListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Ham(
          name: doc.data()['name'] ?? '',
          callsign: doc.data()['callsign'] ?? "");
    }).toList();
  }

  // userData from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    var user = snapshot.data();
    return UserData(uid: uid, name: user['name'], logbooks: user['logbooks']);
  }

  List<QSO> _qsoListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return QSO(data: doc.data());
    }).toList();
  }

  // get hams stream
  Stream<List<Ham>> get haminfo {
    return hamsCollection.snapshots().map(_hamListFromSnapshot);
  }

  // get user doc stream
  Stream<UserData> get userData {
    return hamsCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  Stream<List<QSO>> get logbook {
    return hamsCollection
        .doc(uid)
        .collection('log_0')
        .snapshots()
        .map(_qsoListFromSnapshot);
  }

  void addQso(Map<String, String> map) async {
    return await hamsCollection.doc(uid).collection('log_0').doc().set(map);
  }

  createQso(Map map) {
    hamsCollection.doc(uid).collection('log_0').add(map);
  }
}
