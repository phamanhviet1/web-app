import 'package:flutter/material.dart';
import 'package:flutter_food_delivery/Screen/MainScreen.dart';
import 'package:flutter_food_delivery/notifier/authNotifier.dart';
import 'package:flutter_food_delivery/notifier/foodNotifier.dart';
import 'package:flutter_food_delivery/notifier/orderNotifier.dart';
import 'package:flutter_food_delivery/pages/SignInPage.dart';
import 'package:provider/provider.dart';

void main() => runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthNotifier(),
        ),
        ChangeNotifierProvider(
          create: (context) => FoodNotifier(),
        ),
        ChangeNotifierProvider(
          create: (context) => OrderNotifier(),
        ),
      ],
      child: MyApp(),
    ));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // routes: <String, WidgetBuilder>{
      //   '/': (context) => Consumer<AuthNotifier>(
      //         builder: (context, notifier, child) {
      //           print('main ${notifier.user}');
      //           return notifier.user != null
      //               ? MainScreen(
      //                   returnPage: [0, 0],
      //                 )
      //               : SignInPage();
      //         },
      //       ),
      //   '/second': (context) => ItemShow(),
      //   '/order': (context) => OrderPage(),
      // },

      debugShowCheckedModeBanner: false,
      title: 'Food Delivery',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Consumer<AuthNotifier>(
        builder: (context, notifier, child) {
          print('main ${notifier.user}');
          return notifier.user != null
              ? MainScreen(
                  returnPage: [0, 0],
                )
              : SignInPage();
        },
      ),
    );
  }
}
