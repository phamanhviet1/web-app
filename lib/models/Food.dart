import 'package:cloud_firestore/cloud_firestore.dart';

class Food {
  String name;
  String category;
  List image = [];
  String total;
  Timestamp createdAt;
  Timestamp updatedAt;
  String id;
  String flag;
  String price;
  String content;
  String sale;
  String quantity;
  String size;
  Food();

  Food.fromMap(Map<String, dynamic> data) {
    name = data['name'];
    category = data['category'];
    image = data['image'];
    total = data['total'];
    createdAt = data['createdAt'];
    updatedAt = data['updatedAt'];
    id = data['id'];
    flag = data['flag'];
    price = data['price'];
    content = data['content'];
    sale = data['sale'];
    quantity = data['quantity'];
    size = data['size'];
  }
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'image': image,
      'total': total,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'id': id,
      'flag': flag,
      'price': price,
      'content': content,
      'sale': sale,
      'quantity': quantity,
      'size': size
    };
  }
}
