import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_food_delivery/models/Food.dart';

class FoodNotifier with ChangeNotifier {
  List<Food> _foodList = [];
  Food _currentFood;

  UnmodifiableListView<Food> get foodList => UnmodifiableListView(_foodList);

  Food get currentFood => _currentFood;

  set foodList(List<Food> foodList) {
    _foodList = foodList;
    print(foodList.length);
    notifyListeners();
  }

  set currentFood(Food food) {
    _currentFood = food;
    notifyListeners();
  }

  addFood(Food food) {
    _foodList.insert(0, food);
    notifyListeners();
  }

  deleteFood(Food food) {
    _foodList.removeWhere((_food) => _food.id == food.id);
    notifyListeners();
  }

  List<Food> _cardList = [];
  Food _orderFood;

  UnmodifiableListView<Food> get cardList => UnmodifiableListView(_cardList);

  Food get orderFood => _orderFood;

  set cardList(List<Food> cardList) {
    _cardList = cardList;
    notifyListeners();
  }

  set cardFood(Food food) {
    _orderFood = food;
    notifyListeners();
  }

  addCard(Food food) {
    _cardList.insert(0, food);
    notifyListeners();
  }

  deleteCard(Food food) {
    _cardList.removeWhere((_food) => _food.id == food.id);
    notifyListeners();
  }
}
