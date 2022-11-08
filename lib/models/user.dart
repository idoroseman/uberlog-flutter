class User {
  final String uid;

  User({this.uid});
}

class UserData {
  final String uid;
  final String name;
  final Map logbooks;
  UserData({this.uid, this.name, this.logbooks});
}
