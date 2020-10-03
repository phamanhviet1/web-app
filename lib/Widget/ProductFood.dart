import 'package:flutter/material.dart';
import 'package:flutter_food_delivery/API/foodapi.dart';
import 'package:flutter_food_delivery/Widget/widget.dart';
import 'package:flutter_food_delivery/models/Food.dart';
import 'package:flutter_food_delivery/notifier/notifier.dart';

class ProductFood extends StatefulWidget {
  final bool home;

  ProductFood({
    this.home,
  });
  @override
  _ProductFoodState createState() => _ProductFoodState();
}

class _ProductFoodState extends State<ProductFood> {
  List<Food> filteredUsers = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    FoodNotifier foodNotifier =
        Provider.of<FoodNotifier>(context, listen: false);
    if (foodNotifier.foodList.length == 0 ||
        foodNotifier.foodList.length != filteredUsers.length) {
      Future.delayed(Duration(milliseconds: 1000)).then((_) {
        getFoods(foodNotifier);
      });
    }
    filteredUsers = foodNotifier.foodList;
    print("a");
  }

  @override
  Widget build(BuildContext context) {
    FoodNotifier foodNotifier = Provider.of<FoodNotifier>(
      context,
    );

    final Size screenSize = MediaQuery.of(context).size;

    print("b${filteredUsers.length}");
    return WillPopScope(
      onWillPop: () async {
        print(false);
        return false;
      },
      child: Container(
        child: Column(
          children: [
            Container(
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          offset: Offset(1, 1),
                          blurRadius: 4)
                    ],
                    borderRadius: BorderRadius.circular(20)),
                child: ListTile(
                  leading: Icon(
                    Icons.search,
                    color: Colors.blueGrey,
                  ),
                  title: TextField(
                    decoration: InputDecoration(
                        hintText: "Search any Food", border: InputBorder.none),
                    onChanged: (string) {
                      setState(() {
                        filteredUsers = foodNotifier.foodList
                            .where((u) => (u.name
                                    .toLowerCase()
                                    .contains(string.toLowerCase()) ||
                                u.category
                                    .toLowerCase()
                                    .contains(string.toLowerCase())))
                            .toList();
                      });
                    },
                  ),
                )),
            Container(
              height: widget.home
                  ? (screenSize.height - 350)
                  : screenSize.height - 150,
              child: GridView.builder(
                  // physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection:
                      widget.home ? Axis.horizontal : Axis.vertical,
                  itemCount: filteredUsers.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: widget.home ? 1 : 2),
                  itemBuilder: (_, index) {
                    return Stack(
                      children: <Widget>[
                        GestureDetector(
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.network(
                                        filteredUsers[index].image[0],
                                        fit: BoxFit.fitWidth,
                                        loadingBuilder:
                                            (context, child, progress) {
                                          return progress == null
                                              ? child
                                              : Center(
                                                  child:
                                                      CircularProgressIndicator());
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            onTap: () {
                              foodNotifier.currentFood = filteredUsers[index];

                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return ItemShow();
                              }));
                              // Navigator.of(context).pushNamed('/second');
                            }),
                        filteredUsers[index].sale != "0"
                            ? Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  color: Colors.yellow[200],
                                  child: Center(
                                      child: Column(
                                    children: [
                                      Text("-${filteredUsers[index].sale} %"),
                                      Text(
                                        "Sale",
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  )),
                                ),
                              )
                            : Container(),
                        Positioned(
                          left: 8,
                          bottom: 8,
                          right: 8,
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [Colors.black, Colors.black12],
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topCenter),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 15,
                          bottom: 10,
                          right: 15,
                          child: Column(children: <Widget>[
                            Text(
                              filteredUsers[index].name,
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            filteredUsers[index].sale != "0"
                                ? Column(
                                    children: [
                                      Text(
                                        "${int.parse(filteredUsers[index].price) * (100 - int.parse(filteredUsers[index].sale)) / 100}.000 VND",
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        "${filteredUsers[index].price}.000 VND",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            decoration:
                                                TextDecoration.lineThrough),
                                      )
                                    ],
                                  )
                                : Text(
                                    "${filteredUsers[index].price}.000 VND",
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ]),
                        )
                      ],
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
