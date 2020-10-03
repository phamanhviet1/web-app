import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_food_delivery/API/foodapi.dart';
import 'package:flutter_food_delivery/Widget/ProductFood.dart';
import 'package:flutter_food_delivery/Widget/Responsive.dart';
import 'package:flutter_food_delivery/Widget/categories.dart';
import 'package:flutter_food_delivery/notifier/authNotifier.dart';
import 'package:flutter_food_delivery/notifier/orderNotifier.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController _controller;

  bool bottom = false;
  void initState() {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    initializeCurrentUser(authNotifier);
    OrderNotifier orderNotifier =
        Provider.of<OrderNotifier>(context, listen: false);
    getInfor(orderNotifier, authNotifier.user.email);
    print("first");
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();
  }

  _scrollListener() {
    print(_controller.position.pixels);
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        bottom = true;
        print("reach the bottom $bottom");
      });
    }
    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        bottom = false;
        print("reach the top");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);
    final Size screenSize = MediaQuery.of(context).size;
    print("build");
    return Scaffold(
      body: Responsive.isMobile(context)
          ? ListView(
              controller: _controller,
              shrinkWrap: true,
              children: <Widget>[
                Container(
                  height: 90,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                                text: 'What would\n',
                                style: TextStyle(
                                    fontSize: 23,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700)),
                            TextSpan(
                                text: 'you like to eat?',
                                style: TextStyle(
                                    fontSize: 23,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500))
                          ]),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            // FlatButton(
                            //   onPressed: (){
                            //     signout(authNotifier).whenComplete(() => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => SignInPage())));
                            //   },
                            Card(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("${authNotifier.user.email}"),
                            )),

                            Icon(Icons.notifications_none,
                                color: Theme.of(context).primaryColor),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Categories(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 30,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Frequently Bought Foods",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Text(
                            "View All",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                ProductFood(home: true),
              ],
            )
          : Row(
              children: [
                Image.network(
                    "https://www.foodiesfeed.com/wp-content/uploads/2019/06/top-view-for-box-of-2-burgers-home-made-413x619.jpg",
                    width: screenSize.width - 1100,
                    height: double.infinity,
                    fit: BoxFit.fitHeight),

                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Container(
                    width: 800.0,
                    child: ListView(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Categories(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Frequently Bought Foods",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: Text(
                                  "View All",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange),
                                ),
                              )
                            ],
                          ),
                        ),
                        ProductFood(home: true),
                      ],
                    ),
                  ),
                ),
                // const Spacer(),
                Flexible(
                  child: Image.network(
                      "https://www.foodiesfeed.com/wp-content/uploads/2019/06/top-view-for-box-of-2-burgers-home-made-413x619.jpg",
                      width: screenSize.width - 950,
                      height: double.infinity,
                      fit: BoxFit.fitHeight),
                ),
                // Expanded(child: Spacer()),
              ],
            ),
    );
  }
}
