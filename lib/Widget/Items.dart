import 'package:flutter/material.dart';
import 'package:flutter_food_delivery/Screen/MainScreen.dart';
import 'package:flutter_food_delivery/Widget/Responsive.dart';
import 'package:flutter_food_delivery/Widget/widget.dart';
import 'package:flutter_food_delivery/models/Food.dart';
import 'package:flutter_food_delivery/notifier/notifier.dart';

class CategoriesPage extends StatefulWidget {
  final String categories;
  CategoriesPage(this.categories);
  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  @override
  Widget build(BuildContext context) {
    FoodNotifier foodNotifier =
        Provider.of<FoodNotifier>(context, listen: false);
    List<Food> cart = [];
    foodNotifier.foodList.forEach((element) {
      if (element.category == widget.categories) {
        cart.add(element);
      }
    });
    print(cart.length);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Center(
            child: Text(widget.categories),
          ),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MainScreen(
                          returnPage: [0, 0],
                        )),
              );
            },
          ),
        ),
        body: Container(
          child: GridView.builder(
            scrollDirection: Axis.vertical,
            gridDelegate: Responsive.isMobile(context)
                ? SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 5 / 4)
                : SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, childAspectRatio: 5 / 3),
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    color: Colors.blue,
                    child: Column(
                      children: [
                        FlatButton(
                            onPressed: () {
                              foodNotifier.currentFood = cart[index];
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return ItemShow();
                              }));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Stack(children: [
                                Image.network(cart[index].image[0],
                                    height: 100,
                                    width: 300,
                                    fit: BoxFit.fitWidth),
                                cart[index].sale != "0"
                                    ? Align(
                                        alignment: Alignment.topRight,
                                        child: Container(
                                          height: 20,
                                          width: 50,
                                          color: Colors.yellow[200],
                                          child: Center(
                                              child: Column(
                                            children: [
                                              Text("-${cart[index].sale} %"),
                                            ],
                                          )),
                                        ),
                                      )
                                    : Container(),
                              ]),
                            )),
                        Text(cart[index].name),
                        cart[index].sale != "0"
                            ? Column(
                                children: [
                                  Text(
                                    "${int.parse(cart[index].price) * (100 - int.parse(cart[index].sale)) / 100}.000 VND",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "${cart[index].price}.000 VND",
                                    style: TextStyle(
                                        fontSize: 16,
                                        decoration: TextDecoration.lineThrough),
                                  )
                                ],
                              )
                            : Text("${cart[index].price}.000 VND"),
                      ],
                    )),
              );
            },
            itemCount: cart.length,
          ),
        ));
  }
}
