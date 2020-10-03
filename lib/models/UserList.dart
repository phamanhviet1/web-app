class UserList {
  List user = [];
  String a;

  UserList();

  UserList.fromMap(Map<String, dynamic> data) {
    user = data['user'];
    a = data["a"];
  }
  Map<String, dynamic> toMap() {
    return {'user': user, "a": a};
  }
}
