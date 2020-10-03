import 'package:flutter/material.dart';
import 'package:flutter_food_delivery/Widget/ItemShow.dart';
import 'package:flutter_food_delivery/Widget/ProductFood.dart';
import 'package:flutter_food_delivery/Widget/Responsive.dart';
import 'package:flutter_food_delivery/notifier/authNotifier.dart';
import 'package:flutter_food_delivery/notifier/foodNotifier.dart';
import 'package:flutter_food_delivery/pages/ProfilePage.dart';
import 'package:flutter_food_delivery/pages/HomePage.dart';
import 'package:flutter_food_delivery/pages/OrderPage.dart';
import 'package:flutter_food_delivery/pages/Admin.dart';

import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  final List<int> returnPage;

  MainScreen({
    this.returnPage,
  });
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  List<Widget> home = [HomePage(), ItemShow()];
  HomePage homePage;
  OrderPage orderPage;
  ProfilePage profilePage;
  AdminPage adminPage;
  String admin = "123@gmail.com";

  TabController _tabController;
  @override
  void initState() {
    super.initState();
    homePage = HomePage();
    orderPage = OrderPage();
    profilePage = ProfilePage();
    adminPage = AdminPage();

    _tabController = new TabController(
        initialIndex: widget.returnPage[0], vsync: this, length: 4);
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    FoodNotifier foodNotifier = Provider.of<FoodNotifier>(
      context,
    );
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    return Scaffold(
      appBar: Responsive.isDesktop(context)
          ? PreferredSize(
              preferredSize: Size(screenSize.width, 100),
              child: Row(
                children: [
                  Flexible(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
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
                    ),
                  ),
                  Container(
                    height: double.infinity,
                    width: 800.0,
                    child: new TabBar(
                      labelColor: Colors.black,
                      tabs: <Widget>[
                        new Tab(
                          icon: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Icon(Icons.home),
                          ),
                        ),
                        new Tab(
                            icon: Stack(children: <Widget>[
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
                                      borderRadius: BorderRadius.circular(40)),
                                  child: Text(
                                      " ${foodNotifier.cardList.length} ")))
                        ])),
                        new Tab(
                          icon: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: authNotifier.user.email == admin
                                ? Icon(Icons.security)
                                : Icon(Icons.search),
                          ),
                        ),
                        new Tab(
                          icon: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Icon(Icons.person),
                          ),
                        ),
                      ],
                      controller: _tabController,
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: <Widget>[
                              // FlatButton(
                              //   onPressed: (){
                              //     signout(authNotifier).whenComplete(() => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => SignInPage())));
                              //   },
                              Expanded(
                                child: Card(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("${authNotifier.user.email}"),
                                )),
                              ),

                              Icon(Icons.notifications_none,
                                  color: Theme.of(context).primaryColor),
                            ],
                          )),
                    ),
                  ),
                ],
              ),
            )
          : null,
      body: new TabBarView(
        controller: _tabController,
        children: <Widget>[
          home[widget.returnPage[1]],
          // Responsive.isMobile(context)
          //     ? home[widget.returnPage[1]]
          //     : Row(
          //         children: [

          //           const Spacer(),
          //           Container(width: 800,
          //           child: home[widget.returnPage[1]]
          //           ),
          //           const Spacer(),
          //         ],
          //       ),
          Responsive.isMobile(context)
              ? orderPage
              : Row(
                  children: [
                    const Spacer(),
                    Container(width: 600, child: orderPage),
                    const Spacer(),
                  ],
                ),

          authNotifier.user.email == admin
              ? Responsive.isMobile(context)
                  ? adminPage
                  : Row(
                      children: [
                        const Spacer(),
                        Container(width: 600, child: adminPage),
                        const Spacer(),
                      ],
                    )
              : Responsive.isMobile(context)
                  ? ProductFood(home: false)
                  : Row(
                      children: [
                        const Spacer(),
                        Container(width: 600, child: ProductFood(home: false)),
                        const Spacer(),
                      ],
                    ),
          Responsive.isMobile(context)
              ? profilePage
              : Row(
                  children: [
                    const Spacer(),
                    Container(width: 600, child: profilePage),
                    const Spacer(),
                  ],
                ),
        ],
      ),
      bottomNavigationBar: Responsive.isMobile(context)
          ? PreferredSize(
              preferredSize: Size(screenSize.width, 100.0),
              child: new TabBar(
                  labelColor: Colors.black,
                  tabs: <Widget>[
                    new Tab(
                      icon: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(Icons.home),
                      ),
                    ),
                    new Tab(
                        icon: Stack(children: <Widget>[
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
                                  borderRadius: BorderRadius.circular(40)),
                              child: Text(" ${foodNotifier.cardList.length} ")))
                    ])),
                    new Tab(
                      icon: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: authNotifier.user.email == admin
                            ? Icon(Icons.security)
                            : Icon(Icons.search),
                      ),
                    ),
                    new Tab(
                      icon: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(Icons.person),
                      ),
                    ),
                  ],
                  controller: _tabController),
            )
          : null,
    );
  }
}
