import 'package:flutter/material.dart';
import 'package:flutter_food_delivery/models/category.dart';
import 'package:flutter_food_delivery/Widget/Items.dart';

List<Category> categoriesList = [
  Category(name: "Burger", url: "assets/images/burger.png", number: 12),
  Category(name: "Pizza", url: "assets/images/pizza.png", number: 10),
  Category(name: "Beer", url: "assets/images/beer.png", number: 7),
  Category(name: "Coffee", url: "assets/images/coffee-cup.png", number: 2),
  Category(name: "Turkey", url: "assets/images/turkey.png", number: 9),
];

class Categories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final Size screenSize = MediaQuery.of(context).size;
    return Container(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categoriesList.length,
        itemBuilder: (_, index) {
          return Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 50,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          offset: Offset(1, 1),
                          blurRadius: 4)
                    ],
                    // borderRadius: BorderRadius.circular(20)
                  ),
                  child: Container(
                    color: Colors.blue,
                    child: RaisedButton(
                        color: Colors.white,
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  CategoriesPage(categoriesList[index].name)));
                        },
                        child: Align(
                          alignment: Alignment.center,
                          child: Image.asset(
                            categoriesList[index].url,
                            width: 200,
                          ),
                        )),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  categoriesList[index].name,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
