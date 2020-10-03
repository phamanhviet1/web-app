import 'package:flutter/material.dart';
import 'package:flutter_food_delivery/Screen/MainScreen.dart';
import 'package:flutter_food_delivery/Widget/widget.dart';
import 'package:flutter_food_delivery/notifier/notifier.dart';
import 'package:flutter_food_delivery/API/foodapi.dart';
import 'package:random_string/random_string.dart';
import '../models/Food.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  String data;
  List<String> cartname = [];

  static bool check = false;
  String _key;
  String foos = 'Select Cart';
  String selectuser;
  _collapse(String a) {
    String newKey;
    do {
      _key = randomNumeric(4);
      foos = a;
    } while (newKey == _key);
  }

  @override
  void initState() {
    super.initState();
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    OrderNotifier orderNotifier =
        Provider.of<OrderNotifier>(context, listen: false);

    selectuser = orderNotifier.selectUser;
    if (selectuser != null)
      getOrder(orderNotifier, selectuser, cartname);
    else
      getOrder(orderNotifier, authNotifier.user.email, cartname);
    _collapse(this.foos);
  }

  Widget _cart() {
    return Container(
      height: 500,
      child: Stack(
        children: [
          ListView.separated(
            itemBuilder: (_, index) {
              return ListTile(
                title: Text(cartname[index]),
                onTap: () {
                  setState(() {
                    this.foos = cartname[index];
                    _collapse(this.foos);
                    check = !check;
                  });
                },
              );
            },
            itemCount: cartname.length,
            separatorBuilder: (BuildContext context, int index) {
              return Divider(color: Colors.black);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    FoodNotifier foodNotifier = Provider.of<FoodNotifier>(
      context,
    );
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    OrderNotifier orderNotifier = Provider.of<OrderNotifier>(
      context,
    );
    print(orderNotifier.selectUser);
    selectuser = orderNotifier.selectUser;

    print("build");

    Widget _builderItem() {
      List<Food> cart = [];
      if (check == true) {
        if (selectuser != null)
          getSelectInfor(orderNotifier, selectuser);
        else
          getSelectInfor(orderNotifier, authNotifier.user.email);
      }
      check = false;
      orderNotifier.orderList.forEach((element) {
        if (element.flag == foos) {
          cart.add(element);
        }
      });
      print(cart.length);
      return orderNotifier.selectInfor != null
          ? Column(
              children: [
                Container(
                  height: 220,
                  child: ClipRRect(
                    child: GridView.builder(
                      scrollDirection: Axis.horizontal,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1),
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                child: Card(
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      foodNotifier.currentFood = cart[index];
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ItemShow(),
                                        ),
                                      );
                                    },
                                    child: Image.network(
                                      cart[index].image[0],
                                      height: 100,
                                      width: 300,
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                  Text(cart[index].name),
                                  Text("Quantity : ${cart[index].quantity}"),
                                  Text("Size : ${cart[index].size}"),
                                ],
                              ),
                            )));
                      },
                      itemCount: cart.length,
                    ),
                  ),
                ),
                cart.isNotEmpty
                    ? Container(
                        color: Colors.blue[200],
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Total : ${cart[0].total}"),
                                  IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        setState(() {
                                          cart.forEach((element) {
                                            if (selectuser != null)
                                              deleteOrder(element, selectuser);
                                            else
                                              deleteOrder(element,
                                                  authNotifier.user.email);
                                          });
                                          cart.removeWhere((element) =>
                                              element.flag == foos);
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          MainScreen(
                                                            returnPage: [3, 0],
                                                          )));
                                        });
                                      })
                                ],
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                    "Address : ${orderNotifier.selectInfor.address}"),
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                    "Phone : ${orderNotifier.selectInfor.phone}"),
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                    "Created at : ${cart[0].createdAt.toDate()}"),
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text("Take Note : ${cart[0].content}"),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container()
              ],
            )
          : Container();
    }

    return WillPopScope(
      onWillPop: () => Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => MainScreen(
                    returnPage: [0, 0],
                  )),
          (Route<dynamic> route) => false),
      child: Scaffold(
          appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Center(child: Text("Profile ")),
              actions: <Widget>[
                MaterialButton(
                    onPressed: () {
                      if (selectuser != null)
                        getOrder(orderNotifier, selectuser, cartname);
                      else
                        getOrder(
                            orderNotifier, authNotifier.user.email, cartname);
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return MainScreen(
                          returnPage: [3, 0],
                        );
                      }));
                      print("total ${orderNotifier.orderList.length}");
                    },
                    child: Icon(Icons.refresh)),
              ]),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                UserProfile(),
                new RefreshIndicator(
                  child: ExpansionTile(
                    key: new Key(_key),
                    initiallyExpanded: false,
                    title: new Text(foos),
                    children: [
                      _cart(),
                    ],
                  ),
                  onRefresh: () async {
                    cartname = [];
                    if (selectuser != null)
                      getOrder(orderNotifier, selectuser, cartname);
                    else
                      getOrder(
                          orderNotifier, authNotifier.user.email, cartname);
                  },
                ),
                new RefreshIndicator(
                    key: _refreshIndicatorKey,
                    onRefresh: () async {},
                    child: _builderItem()),
              ],
            ),
          )),
    );
  }
}
