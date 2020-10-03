import 'package:flutter/material.dart';
import 'package:flutter_food_delivery/Widget/Responsive.dart';
import 'package:flutter_food_delivery/models/Food.dart';
import 'package:flutter_food_delivery/notifier/notifier.dart';

class ItemShow extends StatefulWidget {
  @override
  _ItemShowState createState() => _ItemShowState();
}

class _ItemShowState extends State<ItemShow> {
  List quantity = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"];
  List size = ["...", "XS", "S", "M", "L", "XL", "XXL"];
  String getQ = "0";
  String getS = "...";
  int _index = 0, _index1 = 0;
  Food _currentfood;
  static List<bool> isSelected = [true, false, false];

  @override
  void initState() {
    super.initState();
    FoodNotifier foodNotifier =
        Provider.of<FoodNotifier>(context, listen: false);
    _currentfood = foodNotifier.currentFood;
  }

  @override
  Widget build(BuildContext context) {
    FoodNotifier foodNotifier =
        Provider.of<FoodNotifier>(context, listen: false);

    List<Food> cart = [];
    foodNotifier.foodList.forEach((element) {
      if (element.category == foodNotifier.currentFood.category) {
        cart.add(element);
      }
    });

    Widget _showImageList() {
      return Align(
        alignment: Alignment.topCenter,
        child: Container(
            height: 300,
            width: 350,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _currentfood.image.length,
                itemBuilder: (_, _index) {
                  return Container(
                      width: 350,
                      decoration: BoxDecoration(
                        border: Border.all(),
                      ),
                      child: Stack(children: [
                        Center(
                          child: Image.network(
                            _currentfood.image[_index],
                            height: 300,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        Container(
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _currentfood.image.length,
                                itemBuilder: (_, index) {
                                  return Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height: 5,
                                        width: 20,
                                        color: index == _index
                                            ? Colors.black
                                            : Colors.blue,
                                      ),
                                    ),
                                  );
                                })),
                      ]));
                })),
      );
    }

    Widget _listInfor(double h) {
      return Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(), borderRadius: BorderRadius.circular(20)),
            width: 500,
            height: h,
            child: ListView(
                physics: Responsive.isMobile(context)
                    ? NeverScrollableScrollPhysics()
                    : AlwaysScrollableScrollPhysics(),
                children: [
                  Center(
                    child: Text("Name : ${_currentfood.name}",
                        style: TextStyle(
                            fontSize: 23,
                            color: Colors.black,
                            fontWeight: FontWeight.w700)),
                  ),
                  Divider(
                    color: Colors.black26,
                    thickness: 1,
                    height: 20,
                  ),
                  Center(
                    child: Text(
                        "Price : ${int.parse(_currentfood.price) * (1 - int.parse(_currentfood.sale) / 100)}.000 VND"),
                  ),
                  Divider(
                    color: Colors.black26,
                    thickness: 1,
                    height: 20,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("Quantity :"),
                        _index >= 2
                            ? IconButton(
                                icon: Icon(Icons.remove),
                                onPressed: () => setState(() {
                                      _index--;
                                      this.getQ = quantity[_index];
                                    }))
                            : Container(
                                width: 50,
                              ),
                        Text(getQ),
                        _index < 8
                            ? IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () => setState(() {
                                      _index++;
                                      this.getQ = quantity[_index];
                                    }))
                            : Container(
                                width: 10,
                              ),
                        Text("Size :"),
                        _index1 >= 2
                            ? IconButton(
                                icon: Icon(Icons.remove),
                                onPressed: () => setState(() {
                                      _index1--;
                                      this.getS = size[_index1];
                                    }))
                            : Container(
                                width: 50,
                              ),
                        Text(getS),
                        _index1 < 6
                            ? IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () => setState(() {
                                      _index1++;
                                      this.getS = size[_index1];
                                    }))
                            : Container(
                                width: 10,
                              ),
                      ]),
                  Divider(
                    color: Colors.black26,
                    thickness: 1,
                    height: 20,
                  ),
                  FlatButton(
                      color: Colors.blue,
                      onPressed: () {
                        bool check = false;
                        foodNotifier.cardList.forEach((element) {
                          if (element.id == _currentfood.id &&
                              element.size == _currentfood.size) check = true;
                        });
                        if (check == false && getQ != "0" && getS != "...") {
                          setState(() {
                            _currentfood.size = size[_index1];
                            _currentfood.quantity = quantity[_index];

                            foodNotifier.addCard(_currentfood);
                          });
                        }
                      },
                      child: Container(
                          width: 500,
                          child: Center(
                            child: Text(
                              "Add To Cart",
                            ),
                          ))),
                  Responsive.isMobile(context)
                      ? Container()
                      : ExpansionTile(
                          title: Center(child: Text("Content")),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(_currentfood.content),
                            )
                          ],
                        ),
                ]),
          ),
        ),
      );
    }

    Widget _listOrder(double h, w) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: h,
          width: w,
          decoration: BoxDecoration(
              border: Border.all(), borderRadius: BorderRadius.circular(20)),
          child: ListView.separated(
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 50,
                        child: Image.network(
                          foodNotifier.cardList[index].image[0],
                          width: 200,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Text(foodNotifier.cardList[index].name),
                        Text("Size: ${foodNotifier.cardList[index].size}")
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                            "${int.parse(foodNotifier.cardList[index].price) * (1 - int.parse(foodNotifier.cardList[index].sale) / 100) * int.parse(foodNotifier.cardList[index].quantity)}.000 VND "),
                        Text(
                            "Quantity: ${foodNotifier.cardList[index].quantity}")
                      ],
                    ),
                    IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            foodNotifier
                                .deleteCard(foodNotifier.cardList[index]);
                          });
                        })
                  ]);
            },
            itemCount: foodNotifier.cardList.length,
            separatorBuilder: (BuildContext context, int index) {
              return Divider(color: Colors.black);
            },
          ),
        ),
      );
    }

    Widget _listCategory(double h, w) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(),
          ),
          height: h,
          width: w,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: cart.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentfood = cart[index];
                      });
                    },
                    child: Container(
                        child: Column(children: [
                      FlatButton(
                          onPressed: () {
                            foodNotifier.currentFood = cart[index];
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return ItemShow();
                            }));
                          },
                          child: Stack(children: [
                            Image.network(cart[index].image[0],
                                height: 100, width: 100, fit: BoxFit.fitWidth),
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
                          ])),
                      Text(cart[index].name),
                      cart[index].sale != "0"
                          ? Column(
                              children: [
                                Text(
                                  "${int.parse(cart[index].price) * (100 - int.parse(cart[index].sale)) / 100}.000 VND",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "${cart[index].price}.000 VND",
                                  style: TextStyle(
                                      fontSize: 12,
                                      decoration: TextDecoration.lineThrough),
                                )
                              ],
                            )
                          : Text("${cart[index].price}.000 VND"),
                    ])),
                  ));
            },
          ),
        ),
      );
    }

    return Scaffold(
      body: WillPopScope(
          child: Container(
              child: Responsive.isMobile(context)
                  ? ListView(
                      children: [
                        Row(
                          children: [
                            const Spacer(),
                            _showImageList(),
                            const Spacer(),
                          ],
                        ),
                        _listInfor(220),
                        ToggleButtons(
                          children: <Widget>[
                            Icon(Icons.list),
                            Icon(Icons.info_outline),
                            Stack(children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Icon(Icons.shopping_cart),
                              ),
                              Positioned(
                                  right: 0,
                                  top: 0,
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(40)),
                                      child: Text(
                                          " ${foodNotifier.cardList.length} ")))
                            ])
                          ],
                          onPressed: (int index) {
                            setState(() {
                              for (int buttonIndex = 0;
                                  buttonIndex < isSelected.length;
                                  buttonIndex++) {
                                if (buttonIndex == index) {
                                  isSelected[buttonIndex] = true;
                                } else {
                                  isSelected[buttonIndex] = false;
                                }
                              }
                            });
                          },
                          isSelected: isSelected,
                        ),
                        isSelected[0]
                            ? _listCategory(200, 300)
                            : isSelected[1]
                                ? Container(
                                    height: 200,
                                    width: 300,
                                    decoration: BoxDecoration(
                                      border: Border.all(),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(_currentfood.content),
                                    ))
                                : _listOrder(200, 300)
                      ],
                    )
                  : ListView(
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          children: [
                            const Spacer(),
                            _showImageList(),
                            const Spacer(),
                            _listInfor(300)
                          ],
                        ),
                        Container(
                            height: 50,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text("List Catagories",
                                      style: TextStyle(
                                          fontSize: 25,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700)),
                                  Text("List Shop Cart",
                                      style: TextStyle(
                                          fontSize: 25,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700)),
                                ],
                              ),
                            )),
                        Row(
                          children: [
                            _listCategory(200, 800),
                            Spacer(),
                            _listOrder(200, 500)
                          ],
                        )
                      ],
                    )),
          onWillPop: () async {
            print("return");
            Navigator.of(context).pop();
            return true;
          }),
    );
  }
}
