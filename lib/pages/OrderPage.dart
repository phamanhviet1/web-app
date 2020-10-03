import 'package:flutter/material.dart';
import 'package:flutter_food_delivery/API/foodapi.dart';

import 'package:flutter_food_delivery/Screen/MainScreen.dart';
import 'package:random_string/random_string.dart';
import '../notifier/notifier.dart';

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  double total = 0;
  bool checkInfor = false;
  String phone, address;
  @override
  void initState() {
    super.initState();
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    FoodNotifier foodNotifier =
        Provider.of<FoodNotifier>(context, listen: false);
    OrderNotifier orderNotifier =
        Provider.of<OrderNotifier>(context, listen: false);
    foodNotifier.cardList.forEach((element) {
      total += int.parse(element.quantity) *
          int.parse(element.price) *
          (1 - int.parse(element.sale) / 100);
    });
    print(total);
    getInfor(orderNotifier, authNotifier.user.email);
    phone = orderNotifier.infor.phone;
    address = orderNotifier.infor.address;
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    FoodNotifier foodNotifier =
        Provider.of<FoodNotifier>(context, listen: false);
    OrderNotifier orderNotifier =
        Provider.of<OrderNotifier>(context, listen: false);

    return WillPopScope(
      onWillPop: () => Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => MainScreen(
                    returnPage: [0, 0],
                  )),
          (Route<dynamic> route) => false),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: Center(child: Text('Shop Card')),
        ),
        body: ListView(
          children: [
            !checkInfor
                ? Container(
                    height: screenSize.height - 220,
                    child: ListView.separated(
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.network(
                              foodNotifier.cardList[index].image[0],
                              height: 100,
                              width: 200,
                              fit: BoxFit.fitWidth,
                            ),
                            Column(
                              children: [
                                Text(foodNotifier.cardList[index].name),
                                Text(
                                    "Size: ${foodNotifier.cardList[index].size}"),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                    "${int.parse(foodNotifier.cardList[index].price) * (1 - int.parse(foodNotifier.cardList[index].sale) / 100) * int.parse(foodNotifier.cardList[index].quantity)}.000 VND"),
                                Text(
                                    "Quantity: ${foodNotifier.cardList[index].quantity}"),
                              ],
                            ),
                            FlatButton(
                                onPressed: () => setState(() {
                                      total = total -
                                          int.parse(foodNotifier
                                                  .cardList[index].quantity) *
                                              int.parse(foodNotifier
                                                  .cardList[index].price) *
                                              (1 -
                                                  int.parse(foodNotifier
                                                          .cardList[index]
                                                          .sale) /
                                                      100);
                                      print("total $total");
                                      foodNotifier.deleteCard(
                                          foodNotifier.cardList[index]);
                                    }),
                                child: Icon(Icons.delete))
                          ],
                        );
                      },
                      itemCount: foodNotifier.cardList.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider(color: Colors.black);
                      },
                    ),
                  )
                : Container(
                    child: Column(
                      children: [
                        TextFormField(
                          initialValue: orderNotifier.infor.address,
                          keyboardType: TextInputType.multiline,
                          maxLines: 2,
                          style: TextStyle(fontSize: 20),
                          decoration: InputDecoration(
                            labelText: 'Address',
                          ),
                          onChanged: (String save) {
                            address = save;
                            print('onchanged $save');
                          },
                        ),
                        TextFormField(
                          initialValue: orderNotifier.infor.phone,
                          keyboardType: TextInputType.multiline,
                          maxLines: 2,
                          style: TextStyle(fontSize: 20),
                          decoration: InputDecoration(
                            labelText: 'Phone',
                          ),
                          onChanged: (String save) {
                            phone = save;
                            print('onchanged $save');
                          },
                        ),
                        TextFormField(
                          initialValue: "...",
                          keyboardType: TextInputType.multiline,
                          maxLines: 2,
                          style: TextStyle(fontSize: 20),
                          decoration: InputDecoration(
                            labelText: 'Take Note',
                          ),
                          onChanged: (String save) {
                            foodNotifier.cardList[0].content = save;
                            print('onchanged $save');
                          },
                        ),
                      ],
                    ),
                  ),
            Align(
              alignment: FractionalOffset.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: Text('Total :'),
                        subtitle: Text(
                          "$total",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    Expanded(
                      child: MaterialButton(
                        onPressed: () {
                          if (foodNotifier.cardList.isNotEmpty) {
                            setState(() {
                              if (!checkInfor) {
                                checkInfor = true;
                              } else {
                                String name = randomAlpha(5);

                                for (var i = 0;
                                    i < foodNotifier.cardList.length;
                                    i++) {
                                  foodNotifier.cardList[i].flag = name;
                                  foodNotifier.cardList[i].total =
                                      total.toString();
                                  UploadOrderCard(foodNotifier.cardList[i],
                                      authNotifier.user.email);
                                  print(i.toString());
                                }

                                for (var i = 0;
                                    i < foodNotifier.cardList.length;) {
                                  foodNotifier
                                      .deleteCard(foodNotifier.cardList[i]);
                                  print(foodNotifier.cardList.length);
                                }
                                addAddress(authNotifier.user.email, address);
                                addPhone(authNotifier.user.email, phone);
                                checkInfor = false;
                                total = 0;
                              }
                            });
                          } else
                            print("empty");
                        },
                        child:
                            checkInfor ? Text('Order Now') : Text('Check Out'),
                        color: Colors.orange,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
