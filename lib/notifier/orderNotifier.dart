import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_food_delivery/models/Food.dart';
import 'package:flutter_food_delivery/models/InforUser.dart';

class OrderNotifier with ChangeNotifier {
  List<Food> _orderList = [];
  Food _orderitem;
  Infor _infor, _selectInfor;
  Infor get infor => _infor;
  set infor(Infor infor) {
    _infor = infor;
    notifyListeners();
  }

  Infor get selectInfor => _selectInfor;
  set selectInfor(Infor infor) {
    _selectInfor = infor;
    notifyListeners();
  }

  UnmodifiableListView<Food> get orderList => UnmodifiableListView(_orderList);

  Food get orderitem => _orderitem;

  set orderList(List<Food> orderList) {
    _orderList = orderList;
    notifyListeners();
  }

  set orderitem(Food food) {
    _orderitem = food;
    notifyListeners();
  }

  addItem(Food food) {
    _orderList.insert(0, food);
    notifyListeners();
  }

  deleteItem(Food food) {
    _orderList.removeWhere((_food) => _food.id == food.id);
    notifyListeners();
  }

  String selectUser;
}
