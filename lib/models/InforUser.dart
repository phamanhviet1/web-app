class Infor {
  String address;
  String phone;
  String flag;
  List user;

  Infor();

  Infor.fromMap(Map<String, dynamic> data) {
    address = data['Address'];
    phone = data['Phone'];
    flag = data["flag"];
    user = data['user'];
  }
  Map<String, dynamic> toMap() {
    return {'Address': address, 'Phone': phone, 'flag': flag, 'user': user};
  }
}
